
-- TODO: make it so the player cant craft this on their person.
-- also make it so the name is actually showing in the game list, also maybe sort it to be after the stone furnace.

-- Upgrade items: stone-furnace, electric-furnace, boiler, steam-turbine
-- if do it from a list, will it actually do the locale config correctly.

-- https://github.com/marketplace/actions/factorio-mod-portal-publish



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
  {"furnace", "electric-furnace"}, -- not enabled?, not end of consumption tree.
  {"furnace", "steel-furnace"},
  {"boiler", "boiler"},
  {"storage-tank", "storage-tank"},
  {"lab", "lab"},
  {"generator", "steam-engine"},
  {"assembling-machine", "chemical-plant"},
  {"assembling-machine", "oil-refinery"},
  {"assembling-machine", "assembling-machine-1"},
  {"assembling-machine", "assembling-machine-2"},
  {"assembling-machine", "assembling-machine-3"},
} -- Add your desired recipes as {base_type, recipe_name}


local mod_name = "attempt-upgrade"
local overlayPath = "__" .. mod_name .. "__/upgrade-overlay.png"
-- local overlayPath = "__" .. script.mod_name .. "__/graphics/icons/" .. recipe_name .. ".png"

for _, recipe_info in ipairs(recipes_to_modify) do
  local base_type = recipe_info[1]
  local recipe_name = recipe_info[2]

  local source = table.deepcopy(data.raw[base_type][recipe_name]) -- Copy the furnace definition


  local existing_item = data.raw.item[recipe_name] -- data.raw.recipe
  local existing_recipe = data.raw.recipe[recipe_name] -- data.raw.recipe

  log(table_to_string(existing_item))
  log(table_to_string(existing_recipe))

  local localized_name = recipe_name:gsub("-(%w)", function(c) return " " .. c:upper() end):gsub("^%l", string.upper)


  -- Define the recipe for the reversed furnace
  local recipe = {
    type = "recipe",
    name =  "upgrade-" ..  recipe_name, -- will this override the other thing if they match
    localised_name = {"", localized_name  .. " Upgrade Attempt"},
    category = "advanced-crafting",
    enabled = true,
    energy_required = (existing_recipe.energy_required or 0.5) * 1.0, -- Time to craft in seconds (at crafting speed 1)
    -- this could be changed to be based on a research eventually!
    ingredients = {
      {type = "item", name = recipe_name, amount = 1}
    },
    results = {
      { 
        type = "item", 
        name = existing_item.name, 
        amount = 1
      }
    },
    hide_from_player_crafting = true,
    order = (existing_item.order or "z") .. "-upgraded",
    icons = {
      {
        icon = source.icon,
        icon_size = source.icon_size
      },
      {
        icon = overlayPath,
        icon_size = source.icon_size
      },
    },
    -- enabled = true -- this is going to be used when we do the science. 
  }

  -- log(table_to_string(recipe))

  -- Extend the data with the new recipe
  data:extend{recipe}
end

-- if I do the recycle     allowed_effects = {"consumption", "speed", "pollution", "quality"}, this needs to be modified, to not allow quality.
-- for items that are smelted in the upgraded ones, it seems to not have the  item key in the locale