--# Public vehicle parking garages to store player vehicles
--# For: USA Realism RP
--# By: minipunch

local WITHDRAW_FEE = 50
local IMPOUND_FEE = 500

local recentlyChangedPlates = {}

RegisterServerEvent("garage:notifyOfPlateChange")
AddEventHandler("garage:notifyOfPlateChange", function(src, oldPlate, newPlate)
	print("adding recently changed plate!")
	local c = exports["usa-characters"]:GetCharacter(src)
	recentlyChangedPlates[c.get("_id")] = {}
	recentlyChangedPlates[c.get("_id")][oldPlate] = newPlate
end)

RegisterServerEvent("garage:giveKey")
AddEventHandler("garage:giveKey", function(key, src)
	if src then source = src end
	local char = exports["usa-characters"]:GetCharacter(source)
	local invKey = char.getItemWithField("plate", key.plate)
	if not invKey then
		char.giveItem(key)
	end
	-- add to server side list of plates being tracked for locking resource:
	TriggerEvent("lock:addPlate", key.plate)
end)

RegisterServerEvent("garage:storeKey")
AddEventHandler("garage:storeKey", function(plate)
	local char = exports["usa-characters"]:GetCharacter(source)
	local key = char.getItemWithField("plate", plate)
	if key then
		char.removeItem(key, 1)
		TriggerEvent("lock:removePlate", key.plate)
	end
end)

RegisterServerEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function(handle, numberPlateText, required_jobs)
	local char = exports["usa-characters"]:GetCharacter(source)
	local isAuthorized = false
	local usource = source

	if required_jobs then
		local job = char.get("job")
		for i = 1, #required_jobs do
			if job == required_jobs[i] or (required_jobs[i] == 'sheriff' and char.get('policeRank') > 0) or (required_jobs[i] == 'corrections' and char.get('bcsoRank') > 0) or (required_jobs[i] == 'ems' and char.get('emsRank') > 0) or (required_jobs[i] == 'doctor' and char.get('emsRank') > 0) then
				isAuthorized = true
				break
			end
		end
	else
		isAuthorized = true
	end

	if isAuthorized then
		-- does player own vehicle as determined by the list of plates of their vehicles?
		local vehicles = char.get("vehicles")
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			if numberPlateText and vehicle then
				numberPlateText = exports.globals:trim(numberPlateText)
				if numberPlateText == vehicle then -- make sure player owns it
					TriggerEvent('es:exposeDBFunctions', function(couchdb)
						couchdb.updateDocument("vehicles", numberPlateText, { stored = true }, function(doc, err, rtext)
							TriggerClientEvent("garage:storeVehicle", usource)
						end)
					end)
					return
				end
			end
		end
		-- no, so was plate recently changed?
		if recentlyChangedPlates[char.get("_id")] and recentlyChangedPlates[char.get("_id")][numberPlateText] then
			TriggerEvent('es:exposeDBFunctions', function(couchdb)
				local newPlate = recentlyChangedPlates[char.get("_id")][numberPlateText]
				couchdb.updateDocument("vehicles", newPlate, { stored = true }, function(doc, err, rtext)
					TriggerClientEvent("garage:storeVehicle", usource)
					recentlyChangedPlates[char.get("_id")][numberPlateText] = nil
				end)
			end)
			return
		end
		-- nope to either, just notify and abort
		TriggerClientEvent("usa:notify", usource, "You do not own that vehicle!")
		return
	else
		TriggerClientEvent("usa:notify", usource, "Garage prohibited!")
	end
end)

-- ask to retrieve vehicle from garage --
RegisterServerEvent("garage:vehicleSelected")
AddEventHandler("garage:vehicleSelected", function(vehicle, business, playerCoords)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	local vehicles = char.get("vehicles")
	local money = char.get("money")
	vehicle.upgrades = exports["usa_mechanicjob"]:GetUpgradeObjectsFromIds(vehicle.upgrades)
	if vehicle.impounded == true and not vehicle.stored_location then
		if money >= IMPOUND_FEE then
			TriggerClientEvent("usa:notify", usource, "~y~STATE IMPOUND: ~s~Vehicle retrieved from the impound! Fee: ~y~$"..IMPOUND_FEE..".00")
			GetVehicleCustomizations(vehicle.plate, function(customizations)
				vehicle.customizations = customizations
				TriggerClientEvent("garage:vehicleStored", usource, vehicle)
				TriggerEvent('es:exposeDBFunctions', function(couchdb)
					couchdb.updateDocument("vehicles", vehicle.plate, { impounded = false, stored = false }, function()
						char.removeMoney(IMPOUND_FEE)
						if business then
							exports["usa-businesses"]:GiveBusinessCashPercent(business, IMPOUND_FEE)
						end
					end)
				end)
			end)
		else
			TriggerClientEvent("usa:notify", usource, "~y~STATE IMPOUND: ~s~Your vehicle is impounded and can be retrieved for ~y~$"..IMPOUND_FEE..".00~s~!")
		end
	elseif vehicle.stored == true and not vehicle.stored_location then
		local doPay = true
		if isAtProperty(char, playerCoords) then
			doPay = false
		end
		if doPay and money < WITHDRAW_FEE then
			TriggerClientEvent("usa:notify", usource, "Your vehicle can be retrieved for a fee of ~y~$".. WITHDRAW_FEE ..".00~s~!")
			return
		end
		GetVehicleCustomizations(vehicle.plate, function(customizations)
			vehicle.customizations = customizations
			TriggerClientEvent("garage:vehicleStored", usource, vehicle)
			TriggerEvent('es:exposeDBFunctions', function(couchdb)
				couchdb.updateDocument("vehicles", vehicle.plate, { stored = false }, function()
					if doPay then
						char.removeMoney(WITHDRAW_FEE)
						TriggerClientEvent("usa:notify", usource, "Vehicle retrieved from garage! Fee: ~y~$" .. WITHDRAW_FEE ..'.00')
					else 
						TriggerClientEvent("usa:notify", usource, "Vehicle retrieved from garage!")
					end
				end)
			end)
		end)
	else
		TriggerClientEvent("usa:notify", usource, "~y~Sorry!~s~ That vehicle is not stored at any of our garages.")
	end
end)

RegisterServerEvent("garage:openMenu")
AddEventHandler("garage:openMenu", function(required_jobs, _closest_shop)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	if required_jobs then
		local job = char.get("job")
		for i = 1, #required_jobs do
			if required_jobs[i] == job or (required_jobs[i] == 'sheriff' and char.get('policeRank') > 0) or (required_jobs[i] == 'corrections' and char.get('bcsoRank') > 0) or (required_jobs[i] == 'ems' and char.get('emsRank') > 0) or (required_jobs[i] == 'doctor' and char.get('emsRank') > 0) then
				GetVehiclesForMenu(char.get("vehicles"), function(vehs)
					TriggerClientEvent("garage:openMenuWithVehiclesLoaded", usource, vehs)
				end)
				return
			end
		end
		TriggerClientEvent("usa:notify", usource, "Garage prohibited!")
	else
		GetVehiclesForMenu(char.get("vehicles"), function(vehs)
			TriggerClientEvent("garage:openMenuWithVehiclesLoaded", usource, vehs, _closest_shop)
		end)
	end
end)

function GetVehiclesForMenu(plates, cb)
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehiclesForGarageMenu"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseVehArray = {}
			--print(responseText)
			local data = json.decode(responseText)
			if data.rows then
				for i = 1, #data.rows do
					local veh = {
						plate = data.rows[i].value[1], -- plate
						make = data.rows[i].value[2], -- make
						model = data.rows[i].value[3], -- model
						impounded = data.rows[i].value[4], -- impounded
						stored = data.rows[i].value[5], -- stored
						hash = data.rows[i].value[6], -- hash
						owner = data.rows[i].value[7], -- owner
						stats = data.rows[i].value[8], -- vehicle stats
						upgrades = data.rows[i].value[9], -- vehicle upgrades
						stored_location = data.rows[i].value[10] -- stored_location
					}
					table.insert(responseVehArray, veh)
				end
			end
			cb(responseVehArray)
		end
	end, "POST", json.encode({
		keys = plates
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

function GetVehicleCustomizations(plate, cb)
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehicleCustomizationsByPlate"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local customizations = {}
			local data = json.decode(responseText)
			if data.rows and data.rows[1].value then
				customizations = data.rows[1].value[1] -- customizations
			end
			cb(customizations)
		end
	end, "POST", json.encode({
		keys = { plate }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

function IsDriverLicenseValid(source)
	local char = exports["usa-characters"]:GetCharacter(source)
	local license = char.getItem("Driver's License")
	if license and license.status == "valid" then
		return true
	end
	return false
end

function isAtProperty(char, coords)
	local gcoords = char.get("property")["garageCoords"]
	if not gcoords then
		return false
	end
	return exports.globals:getCoordDistance({x = gcoords[1], y = gcoords[2], z = gcoords[3]}, coords) < 10.0
end