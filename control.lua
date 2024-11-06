local event = require("lualib.event")

local compat_pickerextended = require("compat.pickerextended")

--need to search and update hidden inserter stack bonus if that setting has changed!

--helper functions (building placement, removal, rotation)

--confirm that entity is a pneumatic building
local function is_pneumatic(entity)
  return entity and (entity.name == "pneumatic-end-point-intake" or entity.name == "pneumatic-end-point-outtake" or entity.name == "pneumatic-end-point-intake-filtered")
end

local function is_pneumatic_inserter(entity)
  return entity and (entity.name == "pneumatic-hidden-intake" or entity.name == "pneumatic-hidden-outtake")
end

--update the position & direction for pneumatic inserter based off entity's new direction
local function update_inserter_direction(entity)
  local pinserters = entity.surface.find_entities_filtered { type = "inserter", name = {"pneumatic-hidden-intake", "pneumatic-hidden-outtake"}, position = entity.position, area = {{-0.5, -0.5}, {0.5, 0.5}}}
  for i=1, #pinserters do
    pinserters[i].direction = entity.direction
  end
end

--removes any pneumatic-inserters at the given entity's location (1x1 area).
local function delete_inserter(entity, buffer)
  local pinserters = entity.surface.find_entities_filtered { type = "inserter", name = {"pneumatic-hidden-intake", "pneumatic-hidden-outtake"}, position = entity.position, area = {{-0.5, -0.5}, {0.5, 0.5}}}
  for i=1, #pinserters do
    if buffer and pinserters[i].held_stack.valid_for_read then
      buffer.insert(pinserters[i].held_stack)
    end
    pinserters[i].destroy()
  end
  return heldItems
end

--adds a pneumatic-inserter to the given entity's location (based on type of entity and its orientation)
local function add_inserter(entity)
  local insertername = "pneumatic-hidden-intake"
  if entity.name == "pneumatic-end-point-outtake" then insertername = "pneumatic-hidden-outtake" end

  local new_inserter = entity.surface.create_entity{
    name = insertername,
    type = "inserter",
    position = entity.position,
    direction = entity.direction,
    force = entity.force,
  }
  new_inserter.destructible = false
  new_inserter.inserter_stack_size_override = settings.global["pneumatic-inserter-stack-size"].value
  return new_inserter
end

--recipe paste helper function
local function paste_recipe(entity, recipe, player)
  local leftovers = entity.set_recipe(recipe)
  if leftovers then
    for item, quant in pairs(leftovers) do
      player.get_main_inventory().insert({name = item, count = quant})
    end
  end
end

--next item finder function (via recipes - assembler)
local function find_next_item_from_assembler(currentRecipe, copiedRecipe)
  if copiedRecipe and copiedRecipe.products and copiedRecipe.products[1] then
    local itemList = {}
    for i=1,#(copiedRecipe.products) do
      if copiedRecipe.products[i].type == "item" then table.insert(itemList, copiedRecipe.products[i].name) end
    end
    table.sort(itemList)
    if #itemList == 0 then return nil end

    local fItem = itemList[1]

    if currentRecipe and currentRecipe.ingredients and currentRecipe.ingredients[1] then
      for i=1,#(itemList) do
        if itemList[i] == currentRecipe.ingredients[1].name and i < #itemList then
          fItem = itemList[i+1]
        end
      end
    end
    return fItem
  end
end

--next item finder function (via inventory - chests)
local function find_next_item_from_inventory(currentRecipe, inventory)
  if inventory and not inventory.is_empty() then

    local sortedItemList = {}
    for k in pairs(inventory.get_contents()) do table.insert(sortedItemList, k) end

    if inventory.is_filtered() then
      for i=1,#inventory do
        local filterItem = inventory.get_filter(i)
        if filterItem and inventory.get_item_count(filterItem) == 0 then
          table.insert(sortedItemList, filterItem)
        end
      end
    end
    table.sort(sortedItemList)

    local fItem = sortedItemList[1]
    if currentRecipe and currentRecipe.ingredients and currentRecipe.ingredients[1] then
      for i=1,#sortedItemList do
        if sortedItemList[i] == currentRecipe.ingredients[1].name and i < #sortedItemList then
          fItem = sortedItemList[i+1]
        end
      end
    end

    return fItem
  end
end

-- building recipe copy code (only works for intake as the outtake is a furnace style)
local function on_pre_settings_pasted(ev)
  if ev.destination.name == "pneumatic-end-point-intake-filtered" then
    local selectedItem = nil
    if ev.source.type == "container" or ev.source.type == "infinity-container" or ev.source.type == "cargo-wagon" then
      selectedItem = find_next_item_from_inventory(ev.destination.get_recipe(), ev.source.get_inventory(defines.inventory.chest))
    elseif ev.source.name == "pneumatic-end-point-intake" then
      if ev.source.get_recipe() then
        selectedItem = ev.source.get_recipe().ingredients[1].name
      elseif ev.source.previous_recipe then
        selectedItem = ev.source.previous_recipe.ingredients[1].name
      elseif not ev.source.get_inventory(defines.inventory.furnace_source).is_empty() then
        selectedItem = ev.source.get_inventory(defines.inventory.furnace_source)[1].name
      end
    elseif ev.source.type == "furnace" and not ev.source.get_recipe() then
      if ev.source.previous_recipe then
        selectedItem = find_next_item_from_assembler(ev.destination.get_recipe(), ev.source.previous_recipe)
      else
        selectedItem = find_next_item_from_inventory(ev.destination.get_recipe(), ev.source.get_inventory(defines.inventory.furnace_result))
      end
    else
      selectedItem = find_next_item_from_assembler(ev.destination.get_recipe(), ev.source.get_recipe())
    end

    pneumatic_recipe = selectedItem and (game.players[ev.player_index].force.recipes["pneumatic-liquify-" .. selectedItem])

    -- furnace types dont call on_settings_pasted, so this has to be done here
    -- non furnace types will overwire the paste in on_settings_pasted, so the pasting has to be done there
    if ev.source.type == "furnace" or ev.source.type == "container" or ev.source.type == "infinity-container" or ev.source.type == "cargo-wagon" then
      paste_recipe(ev.destination, pneumatic_recipe, game.players[ev.player_index])
    end
  end
end

-- paste fix post paste (finishes the building recipe copy code above)
local function on_settings_pasted(ev)
  if ev.destination.name == "pneumatic-end-point-intake-filtered" and not ev.destination.get_recipe() then
    if pneumatic_recipe and not ev.destination.get_recipe() then
      paste_recipe(ev.destination, pneumatic_recipe, game.players[ev.player_index])
    end
  end
  pneumatic_recipe = nil
end

-- event links

local function on_built(ev)
  local e = ev.created_entity or ev.entity
  if is_pneumatic(e) then add_inserter(e) end
end

local function on_rotated(ev)
  if is_pneumatic(ev.entity) then update_inserter_direction(ev.entity) end
end

local function on_player_mined_entity(ev)
  if is_pneumatic(ev.entity) then
    delete_inserter(ev.entity, ev.buffer and ev.buffer.valid and ev.buffer)
  end
end

local function on_mined(ev)
  if is_pneumatic(ev.entity) then
    local buffer = (ev.buffer and ev.buffer.valid and ev.buffer) or (ev.loot and ev.loot.valid and ev.loot)
    delete_inserter(ev.entity, buffer)
  end
end

-- event registers

script.on_load(compat_pickerextended.on_load)
script.on_init(compat_pickerextended.on_load)

event.register(defines.events.on_built_entity, on_built)
event.register(defines.events.on_robot_built_entity, on_built)
event.register(defines.events.script_raised_built, on_built)
event.register(defines.events.script_raised_revive, on_built)

event.register(defines.events.on_player_rotated_entity, on_rotated)

event.register(defines.events.on_player_mined_entity, on_player_mined_entity)
event.register(defines.events.on_robot_mined_entity, on_mined)
event.register(defines.events.on_entity_died, on_mined)
event.register(defines.events.script_raised_destroy, on_mined)


event.register(defines.events.on_entity_settings_pasted, on_settings_pasted)
event.register(defines.events.on_pre_entity_settings_pasted, on_pre_settings_pasted)