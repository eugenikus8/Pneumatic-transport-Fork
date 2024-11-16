boardname = "electronic-circuit"
if data.raw.item["basic-circuit-board"] then
   boardname = "basic-circuit-board"
end

data:extend({
  {
    type = "recipe",
    name = "pneumatic-intake",
    energy_required = 2.0,
    enabled = false,
    ingredients = {
      {type = "item", name = "iron-plate", amount = 2},
      {type = "item", name = "pipe", amount = 1},
      {type = "item", name = "iron-gear-wheel", amount = 2},
      {type = "item", name = boardname, amount = 1},
    },
    results = {{type = "item", name = "pneumatic-intake", amount = 1}},
    category = "crafting",
  },
  {
    type = "recipe",
    name = "pneumatic-intake-filtered",
    energy_required = 2.0,
    enabled = false,
    ingredients = {
      {type = "item", name = "iron-plate", amount = 2},
      {type = "item", name = "pipe", amount = 1},
      {type = "item", name = "iron-gear-wheel", amount = 2},
      {type = "item", name = boardname, amount = 1},
    },
    results = {{type = "item", name = "pneumatic-intake-filtered", amount = 1}},
    category = "crafting",
  },
  {
    type = "recipe",
    name = "pneumatic-outtake",
    energy_required = 2.0,
    enabled = false,
    ingredients = {
      { type = "item", name = "iron-plate", amount = 2 },
      { type = "item", name = "pipe", amount = 1 },
      { type = "item", name = "iron-gear-wheel", amount = 2 },
      { type = "item", name = boardname, amount = 1 },
    },
    results = {{type = "item", name = "pneumatic-outtake", amount = 1}},
    category = "crafting",
  },
})
