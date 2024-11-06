
tbls = {}
if settings.startup["pneumatic-no-belts"].value then
  table.insert(tbls, data.raw["transport-belt"])
  table.insert(tbls, data.raw["underground-belt"])
  table.insert(tbls, data.raw["splitter"])
  table.insert(tbls, data.raw["loader"])
end

if settings.startup["pneumatic-no-wagons"].value then
  table.insert(tbls, data.raw["cargo-wagon"])
end

if settings.startup["pneumatic-no-inserters"].value then
  table.insert(tbls, data.raw["inserter"])
  table.insert(tbls, data.raw["loader"])
  table.insert(tbls, data.raw["loader-1x1"])
end

--find all the entities we wish to remove

local suspiciousEntities = {}
for _, tbl in ipairs(tbls) do for name, entity in pairs(tbl) do
  suspiciousEntities[name] = 1
  entity.next_upgrade = nil
  entity.placeable_by = nil
end end

--remove place results for all suspicious entities (in regular gameplay all {belts & splitters}/{cargo wagons}/{inserters} will no longer be placeable)

local suspiciousItems = {}
for _, tbl in ipairs({data.raw["item"], data.raw["item-with-entity-data"]}) do for name, item in pairs(tbl) do
  if item.place_result and suspiciousEntities[item.place_result] then
    suspiciousItems[name] = 1
    item.place_result = nil

    if data.raw["item-subgroup"]["intermediate-product"] then item.subgroup = "intermediate-product"
    elseif data.raw["item-subgroup"]["raw-material"] then item.subgroup = "raw-material"
    elseif data.raw["item-subgroup"]["science-pack"] then item.subgroup = "science-pack"
    end

    item.localised_name = {"entity-name."..name}
    item.localised_description = {"entity-description."..name}
  end
end end

--check recipes to see if the selected items are needed for non-selected items (ex: science) in which case leave them alone, otherwise disable them

local itemLinks = {} -- suspicious item -> array of non-suspicions items

for name, recipe in pairs(data.raw.recipe) do
  if not string.find(name, "pneumatic-") then
    ingredients = recipe.ingredients
    if recipe.normal then ingredients = recipe.normal.ingredients end
    if recipe.expensive then ingredients = recipe.expensive.ingredients end

    if ingredients then
      for _, ingredient in ipairs(ingredients) do
        foundItem = (ingredient[1] and suspiciousItems[ingredient[1]] and ingredient[1]) or (ingredient.type=="item" and suspiciousItems[ingredient.name] and ingredient.name)
        if foundItem then
          if not itemLinks[foundItem] then
            itemLinks[foundItem] = {}
          end

          if recipe.results then
            for _, result in ipairs(recipe.results) do
              if result[1] then
                table.insert(itemLinks[foundItem], result[1])
              else
                table.insert(itemLinks[foundItem], result.name)
              end
            end
          elseif recipe.result then
            table.insert(itemLinks[foundItem], recipe.result)
          end
        end
      end
    end
  end
end

local searchedItems = {} --for dfs search - emptied out at start of new search

--depth first search to see if the crafting chain ends with non-selected items
local function dfsCanRemoveItem(itemName)
  if searchedItems[itemName] then
    return true
  else
    searchedItems[itemName] = 1
  end
	
  if (not suspiciousItems[itemName]) and (not string.find(itemName, "pneumatic-")) then
    return false
  elseif itemLinks[itemName] == nil then
    return true
  else
    for _, name in ipairs(itemLinks[itemName]) do
      if not dfsCanRemoveItem(name) then
        return false
      end
    end
    return true
  end
end

--If we can remove the item based on the dfs, then we also hide the liquify/solidify recipes for said items
local removedItems = {}
for name, _ in pairs(suspiciousItems) do
  --log("REMOVED: "..name)
  searchedItems = {}
  if dfsCanRemoveItem(name) then
    removedItems[name] = 1

    if data.raw.recipe["pneumatic-liquify-"..name] then
      data.raw.recipe["pneumatic-liquify-"..name].enabled = false
      data.raw.recipe["pneumatic-liquify-"..name].hidden = true
    end
    if data.raw.recipe["pneumatic-solidify-"..name] then
      data.raw.recipe["pneumatic-solidify-"..name].enabled = false
      data.raw.recipe["pneumatic-solidify-"..name].hidden = true
    end
  end
end

--If we are removing the items, then we also want to remove the recipes that craft those items (note: we dont have to search for recipes that use the items as ingredients, since either they are also being removed (as they craft items being removed), or we arent removing this item (dfs check!)
suspiciousRecipes = {}
for name, recipe in pairs(data.raw.recipe) do
  resultOrigin = recipe
  if recipe.normal then resultOrigin = recipe.normal end
  if recipe.expensive then resultOrigin = recipe.expensive end
  if (not resultOrigin.results) and (not resultOrigin.result) then resultOrigin = recipe end

  if resultOrigin.results then
    for _, result in ipairs(resultOrigin.results) do
      if (result[1] and removedItems[result[1]]) or (result.type == "item" and removedItems[result.name]) then
        suspiciousRecipes[name] = 1
        recipe.enabled = false
        recipe.hidden = true
      end
    end
  elseif resultOrigin.result and removedItems[resultOrigin.result] then
    suspiciousRecipes[name] = 1
    recipe.enabled = false
    recipe.hidden = true
  end
end

--If we are removing the recipes, then we need to remove them from tech. If any tech is left with empty effects (ex: removal of belts resulting in empty logistics research) then we also hide the tech
suspiciousTech = {}
for name, tech in pairs(data.raw.technology) do
  if tech.effects then
    techcheck = false
    neweffects = {}
    for _, effect in ipairs(tech.effects) do
      if (effect.type ~= "unlock-recipe") then
        table.insert(neweffects, effect)
      else
        if suspiciousRecipes[effect.recipe] then
          techcheck = true
        else
          table.insert(neweffects, effect)
        end
      end
    end
    tech.effects = neweffects

    if techcheck and not neweffects[1] then
      suspiciousTech[name] = tech.prerequisites or {}
      tech.enabled = false
      tech.hidden = true
    end
  end
end

--if we hid the tech then pass its prerequisites to its children.
--NOTE: ignore prerequisite chains (ex: tech A requires logistics 2 which requires logistics 1 and green science -> tech A now requires green science and we ignore the logistic 1 requirement)
for name, tech in pairs(data.raw.technology) do
  if tech.prerequisites then
--    edited = false
    original = util.table.deepcopy(tech.prerequisites)

    if type(tech.prerequisites) == "string" then
      tech.prerequisites = {tech.prerequisites}
    end

    newPrereq = {}
    for _, prereq in ipairs(tech.prerequisites) do
      if suspiciousTech[prereq] then
--        edited = true
        for _, addPrereq in ipairs(suspiciousTech[prereq]) do
          if not suspiciousTech[addPrereq] then
            table.insert(newPrereq, addPrereq)
          end
        end
      else
        table.insert(newPrereq, prereq)
      end
    end
    tech.prerequisites = newPrereq

--    if edited then
--      log("NAME: "..name)
--      for _, t in ipairs(original) do log("    ORIG>>"..t) end
--      for _, t in ipairs(newPrereq) do log("        NEW>>"..t) end
--    end

  end
end