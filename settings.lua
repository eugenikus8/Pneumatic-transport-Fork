data:extend{
  {
    type = "bool-setting",
    name = "pneumatic-no-belts",
    setting_type = "startup",
    default_value = true,
    order = "pneumatic-1",
  },
  {
    type = "bool-setting",
    name = "pneumatic-no-wagons",
    setting_type = "startup",
    default_value = true,
    order = "pneumatic-2",
  },
  {
    type = "bool-setting",
    name = "pneumatic-no-inserters",
    setting_type = "startup",
    default_value = false,
    order = "pneumatic-3",
  },
  --[[
  {
    type = "bool-setting",
    name = "pneumatic-thin-pipes",
    setting_type = "startup",
    default_value = false,
    order = "pneumatic-4",
  },
  --]]
  {
    type = "int-setting",
    name = "pneumatic-recipe-multiplier",
    setting_type = "startup",
    default_value = 10,
	minimum_value = 1,
	maximum_value = 50,
    order = "pneumatic-6",
  },
  {
    type = "int-setting",
    name = "pneumatic-fluid-per-item",
    setting_type = "startup",
    default_value = 10,
	minimum_value = 1,
	maximum_value = 100,
    order = "pneumatic-7",
  },
  {
    type = "int-setting",
    name = "pneumatic-inserter-stack-size",
    setting_type = "runtime-global",
    default_value = 10,
	minimum_value = 1,
	maximum_value = 40,
    order = "pneumatic-7",
  },
  {
    type = "string-setting",
    name = "pneumatic-heavy-items",
    setting_type = "startup",
    default_value = "uranium-235,rocket-silo",
	allow_blank = true,
    order = "pneumatic-5",
  },
}