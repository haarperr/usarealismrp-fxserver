--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.

RegisterServerEvent("methJob:methProduced")
AddEventHandler("methJob:methProduced", function(itemName, securityToken)
	local src = source
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), src, securityToken) then
		return false
	end
	local char = exports["usa-characters"]:GetCharacter(src)
	local methProduced = {
		name = itemName,
		type = "drug",
		legality = "illegal",
		quantity = 2,
		weight = 4,
		objectModel = 'bkr_prop_meth_scoop_01a'
	}
	if char.canHoldItem(methProduced) then
		char.giveItem(methProduced)
		TriggerClientEvent("usa:notify", src, "You have successfully proccessed the materials into a meth rock!")
    else
		TriggerClientEvent("usa:notify", src, "Your inventory is full. Can't carry anymore!")
    end
end)

RegisterServerEvent("methJob:methProcessed")
AddEventHandler("methJob:methProcessed", function(itemName, securityToken)
	local src = source
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), src, securityToken) then
		return false
	end
	local char = exports["usa-characters"]:GetCharacter(src)
	local methProduced = {
		name = itemName,
		type = 'drug',
		legality = 'illegal',
		quantity = 1,
		weight = 4,
		objectModel = 'bkr_prop_meth_smallbag_01a'
	}
	if char.canHoldItem(methProduced) then
		char.giveItem(methProduced)
		TriggerClientEvent("usa:notify", src, "You have successfully processed meth rock into packaged product!")
	else
		TriggerClientEvent("usa:notify", src, "Your inventory is full. Can't carry anymore!")
	end
end)

RegisterServerEvent("methJob:checkUserJobSupplies")
AddEventHandler("methJob:checkUserJobSupplies", function(supply, supply2)
	local hasBasicSupply = false
	local char = exports["usa-characters"]:GetCharacter(source)
	local found_supply = char.getItemWithExactName(supply)
	if found_supply then
		char.removeItem(found_supply, 1)
		TriggerClientEvent('methJob:doesUserHaveJobSupply', source, true, supply)
		return
	end

	if supply2 and char.hasItemWithExactName(supply2) then
		char.removeItem(supply2, 1)
		TriggerClientEvent('methJob:doesUserHaveJobSupply', source, true, supply2)
		return
	end
end)

RegisterServerEvent("methJob:giveChemicals")
AddEventHandler("methJob:giveChemicals", function(chemicalToGive, securityToken)
	local src = source
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), src, securityToken) then
		return false
	end
	local char = exports["usa-characters"]:GetCharacter(src)
	local chemical = {
		name = chemicalToGive,
		legality = "illegal",
		quantity = 1,
		type = "chemical",
		weight = 6,
		objectModel = "bkr_prop_meth_acetone"
	}
	char.giveItem(chemical, 1)
end)

RegisterServerEvent("methJob:giveRock")
AddEventHandler("methJob:giveRock", function(rockToGive)
	local char = exports["usa-characters"]:GetCharacter(source)
	local rock = {
		name = rockToGive,
		legality = "illegal",
		quantity = 1,
		type = "drug",
		weight = 4,
		objectModel = 'bkr_prop_meth_scoop_01a'
	}
	char.giveItem(rock, 1)
end)

RegisterServerEvent("methJob:startTimer")
AddEventHandler("methJob:startTimer", function(timerType)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	local messages = {
		"Sup! You can chill out here while I get your stuff.",
		"Long time no see!",
		"What's up good lookin!",
		"Back already?",
		"Miss me already?"
	}
	TriggerClientEvent("usa:notify", source, messages[math.random(1, tonumber(#messages))])
	if timerType == "meth_supplies_ped" then
		local seconds = 40
		local time = seconds * 1000
		SetTimeout(time, function()
			TriggerClientEvent("usa:notify", usource, "Here are the basic chemicals needed for cooking, red phosphorus might increase quality!")
			TriggerClientEvent("methJob:returnPedToStartPosition", usource, timerType)
			local suspiciousChemicals = {
				name = "Pseudoephedrine",
				legality = "illegal",
				quantity = 1,
				type = "chemical",
				weight = 5,
				objectModel = "bkr_prop_meth_acetone"
			}
			char.giveItem(suspiciousChemicals, 1)
		end)
	elseif timerType == "meth_supplies_ped_quality" then
		local seconds = 60
		local time = seconds * 1000
		SetTimeout(time, function()
			TriggerClientEvent("usa:notify", usource, "Here are the extra chemicals needed for good produce!")
			TriggerClientEvent("methJob:returnPedToStartPosition", usource, timerType)
			local suspiciousChemicals = {
				name = "Red Phosphorus",
				legality = "illegal",
				quantity = 1,
				type = "chemical",
				weight = 5,
				objectModel = "bkr_prop_meth_ammonia"
			}
			char.giveItem(suspiciousChemicals, 1)
		end)
	end
end)

RegisterServerEvent("methJob:checkUserMoney")
AddEventHandler("methJob:checkUserMoney", function(supplyType)
	local char = exports["usa-characters"]:GetCharacter(source)
	local amount = 175
	if supplyType == 'Red Phosphorus' then
		amount = 150
	end
	local suspicious_chems = {
		name = "chems bruh",
		weight = 5,
		quantity = 1,
		type = "chemicals"
	}
	if char.canHoldItem(suspicious_chems) then
		local money = char.get("money")
		if money >= amount then
		  TriggerClientEvent("methJob:getSupplies", source, supplyType)
		  char.removeMoney(amount)
		else
		  TriggerClientEvent("usa:notify", source, "Come back when you have ~y~$" .. amount .. "~w~ to get the supplies!")
		end
	else
		TriggerClientEvent("usa:notify", source, "Inventory is full!")
	end
end)
