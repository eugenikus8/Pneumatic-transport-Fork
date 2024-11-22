require("prototypes.fluids")
require("prototypes.recipe_paste_update")

require("prototypes.entity_update")

if mods["space-age"] then
     data.raw["furnace"]["pneumatic-intake"].heating_energy = "30kW"
     data.raw["furnace"]["pneumatic-outtake"].heating_energy = "30kW"
     data.raw["assembling-machine"]["pneumatic-intake-filtered"].heating_energy = "30kW"
     data.raw["assembling-machine"]["pneumatic-outtake-filtered"].heating_energy = "30kW"
end 

