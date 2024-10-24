-- this is a simple recycling recipe for stone brick


local stoneFurnace = table.deepcopy(data.raw["furnace"]["stone-furnace"]) -- copy the table that defines the heavy armor item into the fireArmor variable

stoneFurnace.name = "reverse-stone-furnace"
stoneFurnace.icons = {
  {
    icon = stoneFurnace.icon,
    icon_size = stoneFurnace.icon_size,
    tint = {r=1,g=0,b=0,a=0.3}
  },
}

local recipe = {
  type = "recipe",
  name = "reverse-stone-furnace",
  category = "crafting",
  enabled = true,
  energy_required = 5, -- time to craft in seconds (at crafting speed 1)
  ingredients = {
    {type = "item", name = "stone-furnace", amount = 1}
  },
  results = {{type = "item", name = "stone-furnace", amount = 1}},
  hide_from_player_crafting = true,
  order = "a[stone-furnace]-b[reverse-stone-furnace]"  -- Sort order
}

data:extend{stoneFurnace, recipe}

-- TODO: make it so the player cant craft this on their person.
-- also make it so the name is actually showing in the game list, also maybe sort it to be after the stone furnace.

-- Upgrade items: stone-furnace, electric-furnace, boiler, steam-turbine
-- if do it from a list, will it actually do the locale config correctly.