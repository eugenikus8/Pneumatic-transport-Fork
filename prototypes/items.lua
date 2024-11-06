local icons_path = "__pneumatic-transport__/graphics/icon/entities/"

data:extend({
  {
    type = "item",
    name = "pneumatic-intake-filtered",
    icon = icons_path .. "intake-filtered.png",
    icon_size = 32,
    place_result = "pneumatic-end-point-intake-filtered",
    subgroup = "inserter",
    order = "h[pneumatic]-a3",
    stack_size = 50,
  },
  {
    type = "item",
    name = "pneumatic-intake",
    icon = icons_path .. "intake.png",
    icon_size = 32,
    place_result = "pneumatic-end-point-intake",
    subgroup = "inserter",
    order = "h[pneumatic]-a2",
    stack_size = 50,
  },
  {
    type = "item",
    name = "pneumatic-outtake",
    icon = icons_path .. "outtake.png",
    icon_size = 32,
    place_result = "pneumatic-end-point-outtake",
    subgroup = "inserter",
    order = "h[pneumatic]-a1",
    stack_size = 50,
  },
})
