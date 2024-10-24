-- this is a simple recycling recipe for stone brick


-- local stoneFurnace = table.deepcopy(data.raw["furnace"]["stone-furnace"]) -- copy the table that defines the heavy armor item into the fireArmor variable

-- stoneFurnace.name = "reverse-stone-furnace"
-- stoneFurnace.icons = {
--   {
--     icon = stoneFurnace.icon,
--     icon_size = stoneFurnace.icon_size,
--     tint = {r=1,g=0,b=0,a=0.3}
--   },
-- }

-- local recipe = {
--   type = "recipe",
--   name = "reverse-stone-furnace",
--   localised_name = {"", "Stone Furnace Upgrade Attempt"},
--   category = "crafting",
--   enabled = true,
--   energy_required = 5, -- time to craft in seconds (at crafting speed 1)
--   ingredients = {
--     {type = "item", name = "stone-furnace", amount = 1}
--   },
--   results = {{type = "item", name = "stone-furnace", amount = 1}},
--   hide_from_player_crafting = true,
--   order = "a[stone-furnace]-b[reverse-stone-furnace]"  -- Sort order
-- }

-- data:extend{stoneFurnace, recipe}

-- TODO: make it so the player cant craft this on their person.
-- also make it so the name is actually showing in the game list, also maybe sort it to be after the stone furnace.

-- Upgrade items: stone-furnace, electric-furnace, boiler, steam-turbine
-- if do it from a list, will it actually do the locale config correctly.

-- debug

local function table_to_string(tbl)
  local result = {}
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      table.insert(result, k .. " = {" .. table_to_string(v) .. "}")
    else
      table.insert(result, k .. " = " .. tostring(v))
    end
  end
  return table.concat(result, ", ")
end

-- end debug

local recipes_to_modify = {
  {"furnace", "stone-furnace"},
--  {"furnace", "electric-furnace"}, -- these aren't being ordered correctly
--  {"furnace", "steel-furnace"}, -- these aren't being ordered correctly
  -- 
  -- {"furnace", "steel-furnace"}
} -- Add your desired recipes as {base_type, recipe_name}

for _, recipe_info in ipairs(recipes_to_modify) do
  local base_type = recipe_info[1]
  local recipe_name = recipe_info[2]

  local source = table.deepcopy(data.raw[base_type][recipe_name]) -- Copy the furnace definition


  local existing_recipe = data.raw.item[recipe_name] -- data.raw.recipe

  log(table_to_string(existing_recipe))
  log(table_to_string(source))

  -- Modify the furnace properties
  source.name = "upgrade-" .. recipe_name
  source.icons = {
    {
      icon = source.icon,
      icon_size = source.icon_size,
      tint = {r=1, g=0, b=0, a=0.3}
    },
  }

  -- print(source)
  -- game.print("Modifying recipe: " .. recipe_name)


  local localized_name = recipe_name:gsub("-(%w)", function(c) return " " .. c:upper() end):gsub("^%l", string.upper)


  -- Define the recipe for the reversed furnace
  local recipe = {
    type = "recipe",
    name = "upgrade-" .. recipe_name,
    localised_name = {"", localized_name  .. " Upgrade Attempt"},
    category = "advanced-crafting",
    enabled = true,
    energy_required = 5, -- Time to craft in seconds (at crafting speed 1)
    ingredients = {
      {type = "item", name = recipe_name, amount = 1}
    },
    results = {{type = "item", name = recipe_name, amount = 1}},
    hide_from_player_crafting = true,
    order = (source.order or "z") .. "upgraded"
    --order = "a[" .. recipe_name .. "]-b[upgrade-" .. recipe_name .. "]"  -- Sort order
  }

  -- Extend the data with the new source and recipe
  data:extend{source, recipe}
end


-- {
--   type = "item",
--   name = "boiler",
--   icon = "__base__/graphics/icons/boiler.png",
--   subgroup = "energy",
--   order = "b[steam-power]-a[boiler]",
--   inventory_move_sound = item_sounds.steam_inventory_move,
--   pick_sound = item_sounds.steam_inventory_pickup,
--   drop_sound = item_sounds.steam_inventory_move,
--   place_result = "boiler",
--   stack_size = 50,
--   random_tint_color = item_tints.iron_rust
-- },

-- if I do the recycle     allowed_effects = {"consumption", "speed", "pollution", "quality"}, this needs to be modified, to not allow quality.
-- for items that are smelted in the upgraded ones, it seems to not have the  item key in the locale