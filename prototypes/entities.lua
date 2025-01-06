local empty_sheet = {
   filename = "__core__/graphics/empty.png",
   priority = "very-low",
   width = 1,
   height = 1,
   frame_count = 1,
}


-- Circuit connection definitions
circuit_connector_definitions["valve"] = circuit_connector_definitions.create_vector
(
  universal_connector_template,
  {
    { variation = 24,                           -- down
      main_offset = util.by_pixel(-9, -8),
      shadow_offset = util.by_pixel(11, 11),
      show_shadow = true },
    { variation = 18,                           -- left
      main_offset = util.by_pixel(-5, 0),
      shadow_offset = util.by_pixel(11, 11),
      show_shadow = true },
    { variation = 24,                           -- up
      main_offset = util.by_pixel(-9, -8),
      shadow_offset = util.by_pixel(11, 9),
      show_shadow = true },
    { variation = 22,                           -- right
      main_offset = util.by_pixel(5, 0),
      shadow_offset = util.by_pixel(11, 9),
      show_shadow = true }
  }
)

local crafting_speed = settings.startup["pneumatic-crafting-speed"].value
local bottleneck_ignore = settings.startup["pneumatic-bottleneck-ignore"].value


data:extend({
{
   type = "inserter",
   hidden = true,
   name = "pneumatic-hidden-outtake",
   energy_source = { type = "void" },
   extension_speed = 1,
   rotation_speed = 1,
   pickup_position = {0, -0.2},
   insert_position = {0, 1},
   stack = false,
   stack_size_bonus = 50,

   draw_held_item = false,
   draw_inserter_arrow = true,
   chases_belt_items = false,

   se_allow_in_space = true,

   platform_picture = empty_sheet,
   hand_base_picture = empty_sheet,
   hand_open_picture = empty_sheet,
   hand_closed_picture = empty_sheet,

   collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
   collision_mask = {layers = {}},
   --selection_box = {{-0.5, -0.5}, {0.5, 0.5}},

   selectable_in_game = false,
   flags={"not-on-map","not-blueprintable","not-deconstructable","not-flammable"},
},

{
   type = "inserter",
   hidden = true,
   name = "pneumatic-hidden-intake",
   energy_source = { type = "void" },
   extension_speed = 1,
   rotation_speed = 1,
   pickup_position = {0, 1},
   insert_position = {0, -0.2},
   stack = false,
   stack_size_bonus = 50,

   draw_held_item = false,
   draw_inserter_arrow = true,
   chases_belt_items = false,

   se_allow_in_space = true,

   platform_picture = empty_sheet,
   hand_base_picture = empty_sheet,
   hand_open_picture = empty_sheet,
   hand_closed_picture = empty_sheet,

   collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
   collision_mask = {layers = {}},
   --selection_box = {{-0.5, -0.5}, {0.5, 0.5}},

   selectable_in_game = false,
   flags={"not-on-map","not-blueprintable","not-deconstructable","not-flammable"},
},

{
   type = "assembling-machine",
   name = "pneumatic-intake-filtered",
   icon = "__pneumatic-transport__/graphics/icon/entities/intake-filtered.png",
   icon_size = 32,
   flags = {"placeable-neutral", "placeable-player", "player-creation"},
   minable = {mining_time = 0.2, result = "pneumatic-intake-filtered"},
   fast_replaceable_group = "pneumatic-io",
   max_health = 200,
   corpse = "small-remnants",
   dying_explosion = "explosion",
   collision_box = { { -0.3, -0.3 }, { 0.3, 0.3 } },
   selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
   crafting_categories = { "pneumatic-liquify" },
   crafting_speed = crafting_speed,
   --result_inventory_size = 0,
   --source_inventory_size = 1,
   --ingredient_count = nil,
   se_allow_in_space = true,
   bottleneck_ignore = bottleneck_ignore,
   energy_source = {
      type = "electric",
      usage_priority = "primary-input",
      emissions_per_minute = { pollution = math.max(1, 0.1 * crafting_speed) }
   },
   energy_usage = "19kW",
   ingredient_count = 1,

   circuit_wire_connection_points = circuit_connector_definitions["valve"].points,
   circuit_connector_sprites = circuit_connector_definitions["valve"].sprites,
   circuit_connector = circuit_connector_definitions["valve"],
   circuit_wire_max_distance = default_circuit_wire_max_distance,

   graphics_set = {
      animation = {
         north = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-intake-filtered/intake-filtered-up.png",
            width = 66,
            height = 74,
            frame_count = 1,
            shift = {0.05,0},
         },
         east = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-intake-filtered/intake-filtered-right.png",
            priority = "extra-high",
            width = 46,
            height = 46,
            frame_count = 1,
            shift = {0.03125, 0}
         },
         south = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-intake-filtered/intake-filtered-down.png",
            width = 66,
            height = 72,
            frame_count = 1,
            shift = {-0.05,0},
         },
         west = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-intake-filtered/intake-filtered-left.png",
            priority = "extra-high",
            width = 46,
            height = 46,
            frame_count = 1,
            shift = {-0.03125, 0}
         },
      },
   },
   vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
   working_sound = {
      sound = { filename = "__base__/sound/pump.ogg", volume = 1 },
      audible_distance_modifier = 0.5,
      max_sounds_per_type = 3
   },
   fluid_boxes = {
      {
         production_type = "output",
         pipe_covers = pipecoverspictures(),
         volume = 100,
         pipe_connections = { { flow_direction="output", direction = 0, position = {0, 0} } },
      },
   },
},

{
   type = "assembling-machine",
   name = "pneumatic-outtake-filtered",
   icon = "__pneumatic-transport__/graphics/icon/entities/outtake-filtered.png",
   icon_size = 32,
   flags = {"placeable-neutral", "placeable-player", "player-creation"},
   minable = {mining_time = 0.2, result = "pneumatic-outtake-filtered"},
   fast_replaceable_group = "pneumatic-io",
   max_health = 200,
   corpse = "small-remnants",
   dying_explosion = "explosion",
   collision_box = { { -0.3, -0.3 }, { 0.3, 0.3 } },
   selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
   crafting_categories = { "pneumatic-solidify" },
   crafting_speed = crafting_speed,
   --result_inventory_size = 0,
   --source_inventory_size = 1,
   --ingredient_count = nil,
   se_allow_in_space = true,
   bottleneck_ignore = bottleneck_ignore,
   energy_source = {
      type = "electric",
      usage_priority = "primary-input",
      emissions_per_minute = { pollution = math.max(1, 0.1 * crafting_speed) }
   },
   energy_usage = "19kW",
   ingredient_count = 1,

   circuit_wire_connection_points = circuit_connector_definitions["valve"].points,
   circuit_connector_sprites = circuit_connector_definitions["valve"].sprites,
   circuit_connector = circuit_connector_definitions["valve"],
   circuit_wire_max_distance = default_circuit_wire_max_distance,

   graphics_set = {
      animation = {
         north = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-outtake-filtered/intake-filtered-up.png",
            width = 66,
            height = 74,
            frame_count = 1,
            shift = {0.05,0},
         },
         east = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-outtake-filtered/intake-filtered-right.png",
            priority = "extra-high",
            width = 46,
            height = 46,
            frame_count = 1,
            shift = {0.03125, 0}
         },
         south = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-outtake-filtered/intake-filtered-down.png",
            width = 66,
            height = 72,
            frame_count = 1,
            shift = {-0.05,0},
         },
         west = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-outtake-filtered/intake-filtered-left.png",
            priority = "extra-high",
            width = 46,
            height = 46,
            frame_count = 1,
            shift = {-0.03125, 0}
         },
      },
   },
   vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
   working_sound = {
      sound = { filename = "__base__/sound/pump.ogg", volume = 1 },
      audible_distance_modifier = 0.5,
      max_sounds_per_type = 3
   },
   fluid_boxes = {
      {
         production_type = "input",
         pipe_covers = pipecoverspictures(),
         volume = 100,
         pipe_connections = { { flow_direction="input", direction = 0, position = {0, 0} } },
      },
   },
},

{
   type = "furnace",
   name = "pneumatic-intake",
   icon = "__pneumatic-transport__/graphics/icon/entities/intake.png",
   icon_size = 32,
   flags = {"placeable-neutral", "placeable-player", "player-creation"},
   minable = {mining_time = 0.2, result = "pneumatic-intake"},
   fast_replaceable_group = "pneumatic-io",
   max_health = 200,
   corpse = "small-remnants",
   dying_explosion = "explosion",
   collision_box = { { -0.3, -0.3 }, { 0.3, 0.3 } },
   selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
   crafting_categories = { "pneumatic-liquify" },
   crafting_speed = crafting_speed,
   result_inventory_size = 0,
   source_inventory_size = 1,
   ingredient_count = nil,
   se_allow_in_space = true,
   bottleneck_ignore = bottleneck_ignore,
   energy_source = {
      type = "electric",
      usage_priority = "primary-input",
      emissions_per_minute = { pollution = math.max(1, 0.1 * crafting_speed) }
   },
   energy_usage = "19kW",
   ingredient_count = 1,
   graphics_set = {
      animation = {
         north = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-intake/intake-up.png",
            width = 66,
            height = 74,
            frame_count = 1,
            shift = {0.05, 0},
         },
         east = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-intake/intake-right.png",
            priority = "extra-high",
            width = 46,
            height = 46,
            frame_count = 1,
            shift = {0.03125, 0}
         },
         south = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-intake/intake-down.png",
            width = 66,
            height = 72,
            frame_count = 1,
            shift = {-0.05, 0},
         },
         west = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-intake/intake-left.png",
            priority = "extra-high",
            width = 46,
            height = 46,
            frame_count = 1,
            shift = {-0.03125, 0}
         },
      },
   },
   vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
   working_sound = {
      sound = { filename = "__base__/sound/pump.ogg", volume = 1 },
      audible_distance_modifier = 0.5,
      max_sounds_per_type = 3
   },
   fluid_boxes = {
      {
         production_type = "output",
         pipe_covers = pipecoverspictures(),
         volume = 100,
         pipe_connections = { { flow_direction="output", direction = 0, position = {0, 0} } },
      },
   },
},

{
   type = "furnace",
   name = "pneumatic-outtake",
   icon = "__pneumatic-transport__/graphics/icon/entities/outtake.png",
   icon_size = 32,
   flags = {"placeable-neutral", "placeable-player", "player-creation"},
   minable = {mining_time = 0.2, result = "pneumatic-outtake"},
   fast_replaceable_group = "pneumatic-io",
   max_health = 200,
   corpse = "small-remnants",
   dying_explosion = "explosion",
   collision_box = { { -0.3, -0.3 }, { 0.3, 0.3 } },
   selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
   crafting_categories = { "pneumatic-solidify" },
   crafting_speed = crafting_speed,
   result_inventory_size = 1,
   source_inventory_size = 0,
   ingredient_count = nil,
   se_allow_in_space = true,
   bottleneck_ignore = bottleneck_ignore,
   energy_source = {
      type = "electric",
      usage_priority = "primary-input",
      emissions_per_minute = { pollution = math.max(1, 0.1 * crafting_speed) }
   },
   energy_usage = "19kW",
   ingredient_count = 1,
   graphics_set = {
      animation = {
         north = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-outtake/outtake-up.png",
            width = 66,
            height = 74,
            frame_count = 1,
            shift = {0.05,0},
         },
         east = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-outtake/outtake-right.png",
            priority = "extra-high",
            width = 46,
            height = 46,
            frame_count = 1,
            shift = {0.03125, 0}
         },
         south = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-outtake/outtake-down.png",
            width = 66,
            height = 72,
            frame_count = 1,
            shift = {-0.05,0},
         },
         west = {
            filename = "__pneumatic-transport__/graphics/entity/pneumatic-outtake/outtake-left.png",
            priority = "extra-high",
            width = 46,
            height = 46,
            frame_count = 1,
            shift = {-0.03125, 0}
         },
      },
   },
   vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
   working_sound = {
      sound = { filename = "__base__/sound/pump.ogg", volume = 1 },
      audible_distance_modifier = 0.5,
      max_sounds_per_type = 3
   },
   fluid_boxes = {
      {
         production_type = "input",
         pipe_covers = pipecoverspictures(),
         volume = 100,
         pipe_connections = { { flow_direction="input", direction = 0, position = {0, 0} } },
      },
   },
},

})