--# made by: minipunch
--# for: USA REALISM RP

-----------------
-- tattoo list --
-----------------
local TATTOOS = {}

function LoadTattoos()
	---------------------------------
	-- Load JSON tattoo data --
	---------------------------------
	local resource_name = GetCurrentResourceName()
	local mpbeach = json.decode(LoadResourceFile(resource_name, "tattoos/mpbeach_overlays.json"))
	local mpairraces = json.decode(LoadResourceFile(resource_name, "tattoos/mpairraces_overlays.json"))
	local mpbiker = json.decode(LoadResourceFile(resource_name, "tattoos/mpbiker_overlays.json"))
	local mpbusiness = json.decode(LoadResourceFile(resource_name, "tattoos/mpbusiness_overlays.json"))
	local mpchristmas2 = json.decode(LoadResourceFile(resource_name, "tattoos/mpchristmas2_overlays.json"))
	local mpchristmas2017 = json.decode(LoadResourceFile(resource_name, "tattoos/mpchristmas2017_overlays.json"))
	local mpgunrunning = json.decode(LoadResourceFile(resource_name, "tattoos/mpgunrunning_overlays.json"))
	local mphipster = json.decode(LoadResourceFile(resource_name, "tattoos/mphipster_overlays.json"))
	local mpimportexport = json.decode(LoadResourceFile(resource_name, "tattoos/mpimportexport_overlays.json"))
	local mplowrider = json.decode(LoadResourceFile(resource_name, "tattoos/mplowrider_overlays.json"))
	local mplowrider2 = json.decode(LoadResourceFile(resource_name, "tattoos/mplowrider2_overlays.json"))
	local mpluxe = json.decode(LoadResourceFile(resource_name, "tattoos/mpluxe_overlays.json"))
	local mpluxe2 = json.decode(LoadResourceFile(resource_name, "tattoos/mpluxe2_overlays.json"))
	local mpsmuggler = json.decode(LoadResourceFile(resource_name, "tattoos/mpsmuggler_overlays.json"))
	local mpstunt = json.decode(LoadResourceFile(resource_name, "tattoos/mpstunt_overlays.json"))
	local multiplayer = json.decode(LoadResourceFile(resource_name, "tattoos/multiplayer_overlays.json"))
	------------------------------
	-- construct data struct --
	------------------------------
	TATTOOS = {
		["MP Beach"] = {
			tattoos = mpbeach,
			category = "mpbeach_overlays"
		},
		["MP Air Races"] = {
			tattoos = mpairraces,
			category = "mpairraces_overlays"
		},
		["MP Biker"] = {
			tattoos = mpbiker,
			category = "mpbiker_overlays"
		},
		["MP Business"] = {
			tattoos = mpbusiness,
			category = "mpbusiness_overlays"
		},
		["MP Christmas2"] = {
			tattoos = mpchristmas2,
			category = "mpchristmas2_overlays"
		},
		["MP Christmas2017"] = {
			tattoos = mpchristmas2017,
			category = "mpchristmas2017_overlays"
		},
		["MP Gun Running"] = {
			tattoos = mpgunrunning,
			category = "mpgunrunning_overlays"
		},
		["MP Hipster"] = {
			tattoos = mphipster,
			category = "mphipster_overlays"
		},
		["MP Import / Export"] = {
			tattoos = mpimportexport,
			category = "mpimportexport_overlays"
		},
		["MP Lowrider"] = {
			tattoos = mplowrider,
			category = "mplowrider_overlays"
		},
		["MP Lowrider 2"] = {
			tattoos = mplowrider2,
			category = "mplowrider2_overlays"
		},
		["MP Luxe"] = {
			tattoos = mpluxe,
			category = "mpluxe_overlays"
		},
		["MP Luxe 2"] = {
			tattoos = mpluxe2,
			category = "mpluxe2_overlays"
		},
		["MP Smuggler"] = {
			tattoos = mpsmuggler,
			category = "mpsmuggler_overlays"
		},
		["MP Stunt"] = {
			tattoos = mpstunt,
			category = "mpstunt_overlays"
		},
		["MP Multiplayer"] = {
			tattoos = multiplayer,
			category = "multiplayer_overlays"
		}
	}
	print("tattoos loaded!")
end

LoadTattoos()

function CalculateCost(purchased_tattoos)
  local total_cost = 0
  for k = 1, #purchased_tattoos do
    for name, info in pairs(TATTOOS) do
      if purchased_tattoos[k].category == info.category then
        for i = 1, #info.tattoos do
            if purchased_tattoos[k].human_readable_name == info.tattoos[i].LocalizedName then
              total_cost = total_cost + info.tattoos[i].Price
              --print("tattoo price: $" .. info.tattoos[i].Price)
            end
        end
      end
    end
  end
  return total_cost
end

function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

RegisterServerEvent("tattoo:loadTattoos")
AddEventHandler("tattoo:loadTattoos", function()
	TriggerClientEvent("tattoo:loadTattoos", source, TATTOOS)
end)

RegisterServerEvent("tattoo:checkout") -- TODO: give businesses money from purchases
AddEventHandler("tattoo:checkout", function(purchased_tattoos, business)
  local char = exports["usa-characters"]:GetCharacter(source)
  local cost = CalculateCost(purchased_tattoos)
  print("TATTOO: Checking out with total tattoo cost[" .. cost .. "] for "..GetPlayerName(source).."["..GetPlayerIdentifier(source).."]!")
  if char.get("money") >= cost then
    char.removeMoney(cost)
	if business then
		exports["usa-businesses"]:GiveBusinessCashPercent(business, cost)
	end
    local appearance = char.get("appearance")
	if appearance.tattoos then
	    for i = 1, #purchased_tattoos do
	      table.insert(appearance.tattoos, purchased_tattoos[i])
	    end
	else
		appearance.tattoos = purchased_tattoos
	end
    char.set("appearance", appearance)
    TriggerEvent("usa:loadPlayerComponents", source)
	TriggerClientEvent("usa:notify", source, "You have paid ~w~$" .. comma_value(cost))
  else
    TriggerClientEvent("usa:notify", source, "You don't have enough money to pay the total: $" .. comma_value(cost))
  end
end)

RegisterServerEvent("tattoo:removeTattoos")
AddEventHandler("tattoo:removeTattoos", function()
  local char = exports["usa-characters"]:GetCharacter(source)
  local appearance = char.get("appearance")
  appearance.tattoos = nil
  char.set("appearance", appearance)
  TriggerClientEvent("tattoo:removeTattoos", source)
end)
