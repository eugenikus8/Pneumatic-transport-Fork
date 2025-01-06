heavyItems = {}
str = 'cat,dog'
for item in string.gmatch(settings.startup["pneumatic-heavy-items"].value, '([^,]+)') do
   heavyItems[item] = 1
end

validRecipes = {}
for name, tech in pairs(data.raw.technology) do
   if tech.effects then
      for _, effect in ipairs(tech.effects) do
         if effect.type == "unlock-recipe" then validRecipes[effect.recipe] = 1 end
      end
   end
end

validItems = {}
--special cases (aka: not sure why these arent picked up by the check, probably something to do with how they handle things)
validItems["se-rocket-science-pack"] = 1
validItems["singularity-tech-card"] = 1


for name, recipe in pairs(data.raw.recipe) do

   if (not recipe.hidden) and (recipe.enabled == nil or recipe.enabled or validRecipes[name] == 1) then
      checklocations = { recipe }
      if recipe.expensive then table.insert(checklocations, recipe.expensive) end
      if recipe.normal then table.insert(checklocations, recipe.normal) end

      for _, checklocation in ipairs(checklocations) do

         if checklocation.ingredients then
            for _, ingredient in ipairs(checklocation.ingredients) do
               if ingredient[1] then validItems[ingredient[1]] = 1 end
               if ingredient.type == "item" then validItems[ingredient.name] = 1 end
            end
         end

         if checklocation.result then validItems[checklocation.result] = 1 end

         if checklocation.results then
            if checklocation.results and type(checklocation.results) == "table" then
               for _, result in ipairs(checklocation.results) do
                  if result.type == "item" then validItems[result.name] = 1 end
               end
            end
         end
      end
   end
end

for name, item in pairs(data.raw.item) do
   if item.rocket_launch_product then
      if item.rocket_launch_product[1] then validItems[item.rocket_launch_product[1]] = 1 end
      if item.rocket_launch_product.name then validItems[item.rocket_launch_product.name] = 1 end
   end

   if item.rocket_launch_product then
      for _, product in item.rocket_launch_product do
         if product[1] then validItems[product[1]] = 1 end
         if product.name then validItems[product.name] = 1 end 
      end
   end
end

pneumaticFluids = {}
pneumaticRecipes = {}
for _, tbl in ipairs({ data.raw.item, data.raw.module, data.raw.ammo, data.raw.armor, data.raw.capsule, data.raw.tool, data.raw["repair-tool"], data.raw["item-with-entity-data"], data.raw["rail-planner"] }) do

   for name, item in pairs(tbl) do

      if string.find(name, "-barrel") and name ~= "empty-barrel" then goto continue end

      if string.find(name, "textplate") or string.find(name, "deadlock-crate") then goto continue end

      if not validItems[name] then goto continue end
      pneumaticFluid = util.table.deepcopy(item)

      if item.place_result == nil then
         pneumaticFluid.localised_name = {"fluid-name.pneumatic-fluid", item.localised_name or {"item-name." .. item.name}}
      else
         pneumaticFluid.localised_name = {"fluid-name.pneumatic-fluid", item.localised_name or {"entity-name." .. item.place_result}}
      end

      pneumaticFluid.type = "fluid"
      pneumaticFluid.name = "pneumatic-" .. item.name
      pneumaticFluid.hidden_in_factoriopedia = true    --hide in factoriopedia
      pneumaticFluid.base_color = {math.random(), math.random(), math.random()}
      pneumaticFluid.default_temperature = 15
      pneumaticFluid.flow_color = {1, 1, 1}
      pneumaticFluid.subgroup = "pneumatic-" .. (item.subgroup or "other")

      if item.icon ~= nil or item.icons ~= nil then
         if item.icons == nil then
            pneumaticFluid.icons = { {icon = item.icon, icon_size = item.icon_size} }
         end

      table.insert(pneumaticFluid.icons, {icon = "__pneumatic-transport__/graphics/icon/fluids/water.png", icon_mipmaps = 4, icon_size = 64, scale = 0.25, shift = {12, 9}})
      end

      table.insert(pneumaticFluids, pneumaticFluid)

      quantity = settings.startup["pneumatic-recipe-multiplier"].value
      fluidSize = settings.startup["pneumatic-fluid-per-item"].value
      if item.stack_size and quantity > item.stack_size / 5 then quantity = item.stack_size / 5 end
      if quantity < 1 then quantity = 1 end
      if heavyItems[item.name] then quantity = 1 fluidSize = 100 end

      table.insert(pneumaticRecipes, {
         type = "recipe",
         name = "pneumatic-liquify-"..name,

         localised_name = {"recipe-name.pneumatic-liquify", item.localised_name or {"item-name." .. item.name}},  --add locale recipe name

         energy_required = 0.4,
         enabled = true,
         hidden_in_factoriopedia = true,    --hide in factoriopedia
         hide_from_player_crafting = true,
         hide_from_stats = true,
         ingredients = {
            { type = "item", name = name, amount = quantity },
         },
         results = {
            { type = "fluid", name = "pneumatic-"..name, amount = quantity * fluidSize },
         },
         category = "pneumatic-liquify",
         overload_multiplier = 2,
   
         --icon = item.icon,
         --icons = item.icons,
         --icon_size = item.icon_size,
         --subgroup = item.subgroup,
      })

      table.insert(pneumaticRecipes, {
         type = "recipe",
         name = "pneumatic-solidify-"..name,

         localised_name = {"recipe-name.pneumatic-solidify", item.localised_name or {"item-name." .. item.name}},  --add locale recipe name

         energy_required = 0.4,
         enabled = true,
         hidden_in_factoriopedia = true,    --hide in factoriopedia
         hide_from_player_crafting = true,
         hide_from_stats = true,
         results = {
            { type = "item", name = name, amount = quantity },
         },
         ingredients = {
            { type = "fluid", name = "pneumatic-"..name, amount = quantity * fluidSize },
         },
         category = "pneumatic-solidify",
         overload_multiplier = 2,

         --icons = pneumaticFluid.icons,
         --subgroup = pneumaticFluid.subgroup,
      })

   ::continue::
   end
end

newsubgroups = {}
for name, subgroup in pairs(data.raw["item-subgroup"]) do
   newsub = util.table.deepcopy(subgroup)
   newsub.name = "pneumatic-" .. subgroup.name
   if subgroup.order then
      newsub.order = "zzz__" .. subgroup.order
   end

   table.insert(newsubgroups, newsub)
end


data:extend(pneumaticFluids)
data:extend(pneumaticRecipes)
data:extend(newsubgroups)