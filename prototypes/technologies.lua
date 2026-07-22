--- Gets the first technology that unlocks the given recipe
--- @param recipe_name string
--- @return string
local function get_recipe_tech(recipe_name)
  for name, technology in pairs(data.raw.technology) do
    if technology.enabled ~= false and technology.effects then
      for _, effect in pairs(technology.effects) do
        if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
          return name
        end
      end
    end
  end
end

inserterTech = get_recipe_tech("inserter")
if inserterTech then
  table.insert(data.raw.technology[inserterTech].effects, {type = "unlock-recipe", recipe = "pneumatic-intake"})
  table.insert(data.raw.technology[inserterTech].effects, {type = "unlock-recipe", recipe = "pneumatic-outtake"})
  table.insert(data.raw.technology[inserterTech].effects, {type = "unlock-recipe", recipe = "pneumatic-intake-filtered"})
  table.insert(data.raw.technology[inserterTech].effects, {type = "unlock-recipe", recipe = "pneumatic-outtake-filtered"})
else
  data.raw.recipe["pneumatic-intake"].enabled = true
  data.raw.recipe["pneumatic-outtake"].enabled = true
  data.raw.recipe["pneumatic-intake-filtered"].enabled = true
  data.raw.recipe["pneumatic-outtake-filtered"].enabled = true
end
