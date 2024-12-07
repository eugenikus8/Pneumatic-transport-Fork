-- local util = require("lualib.util")

-- compatibility with PickerExtended mod
local M = {}

local function on_dolly_moved(event)
   local entity = event.moved_entity
   if not (
      entity.name == "pneumatic-intake" or
      entity.name == "pneumatic-outtake" or
      entity.name == "pneumatic-intake-filtered" or
      entity.name == "pneumatic-outtake-filtered") then
      return
   end

   local old_pos = event.start_pos
   local new_pos = entity.position

   -- move inserters
   local pinserters = entity.surface.find_entities_filtered {
      type = "inserter",
      name = {"pneumatic-hidden-intake", "pneumatic-hidden-outtake"},
      position = old_pos,
      area = {{-0.5, -0.5}, {0.5, 0.5}}
   }
   for i = 1, #pinserters do
      pinserters[i].teleport(new_pos)
   end
end

function M.on_load()
   if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["dolly_moved_entity_id"] then
      local on_dolly_moved_event = remote.call("PickerDollies", "dolly_moved_entity_id")
      script.on_event(on_dolly_moved_event, on_dolly_moved)
   end
end

return M
