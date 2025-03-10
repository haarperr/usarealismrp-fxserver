--# Public vehicle parking garages to store player vehicles
--# For: USA Realism RP
--# By: minipunch

locations = {
	{ ['x'] = -301.94973754883, ['y'] = 6123.2309570313, ['z'] = 31.499670028687 },
	{ ['x'] = 1698.5390625, ['y'] = 4941.4189453125, ['z'] = 42.126735687256 },
	{ ['x'] = 1502.3321533203, ['y'] = 3758.8825683594, ['z'] = 33.960582733154 },
	{ ['x'] = 2724.9311523438, ['y'] = 1348.2045898438, ['z'] = 24.523973464966 },
	{ ['x'] = 2544.4921875, ['y'] = -389.66342163086, ['z'] = 92.992828369141 },
	{ ['x'] = 1185.3264160156, ['y'] = -1546.4693603516, ['z'] = 39.400947570801 },
	{ ['x'] = -307.64028930664, ['y'] = -757.61248779297, ['z'] = 33.968524932861 },
	{ ['x'] = 248.066, ['y'] = -746.955, ['z'] = 30.8214 },
	{ ['x'] = -982.3, ['y'] = -2880.6, ['z'] = 14.3 }, -- LSIA
	{ ['x'] = -795.98, ['y'] = 322.67, ['z'] = 85.70},
	{ ['x'] = -740.66, ['y'] = -67.24, ['z'] = 41.75},
	{ ['x'] = -11.58, ['y'] = -303.64, ['z'] = 45.80},
	{ ['x'] = -1439.64, ['y'] = -677.51, ['z'] = 26.38},
	{ ["x"] = 196.30528259277, ["y"] = -1664.2943115234, ["z"] = 29.803218841553, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "doctor"} }, -- FD in LS
	{ ["x"] = -455.9, ["y"] = 6040.9, ["z"] = 31.3, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- paleto PD
	{ ["x"] = -357.1, ["y"] = 6094.2, ["z"] = 31.4, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "doctor"} }, -- paleto FD
	{ ['x'] = 1877.0660400391, ['y'] = 3707.8864746094, ['z'] = 33.546321868896, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "doctor"} }, -- sandy PD
	{ ["x"] = 1712.8, ["y"] = 3599.5, ["z"] = 35.3, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "doctor"} }, -- sandy FD
	{ ['x'] = 445.236328125, ['y'] = -991.69458007813, ['z'] = 25.699808120728, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- MRPD
	{ ['x'] = 326.3464, ['y'] = -588.4531, ['z'] = 28.7968, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "doctor"} }, -- pillbox medical
	{ ['x'] = -842.25219726562, ['y'] = -1233.0513916016, ['z'] = 6.9339327812195, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "doctor"} }, -- viceroy medical
	{ ["x"] = 326.4, ["y"] = -1475.6, ["z"] = 29.8, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "doctor"} }, -- one of the hospitals in LS, forgot exaclty the name
	{ ["x"] = 1834.5, ["y"] = 2542.2, ["z"] = 45.9, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "da"} },
	{ ['x'] = 911.6, ['y'] = -163.6, ['z'] = 74.4, ["jobs"] = {"taxi"}},
	{ ['x'] = -77.19, ['y'] = -808.706, ['z'] = 36.48, ['jobs'] = {"da"}},
	{ ['x'] = -311.8, ['y'] = 228.2, ['z'] = 87.8, ['noBlip'] = true}, -- studio los santos
	{ ['x'] = -620.3, ['y'] = 52.7, ['z'] = 43.7, ['noBlip'] = true}, -- Tinsel Towers Apartments
	{ ['x'] = 364.4, ['y'] = -1700.6, ['z'] = 32.5}, -- court house (davis, LS)
	{ ["x"] = -1073.4, ["y"] = -879.7, ["z"] = 4.8, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"}, ["noBlip"] = true }, -- Vespucci PD
	{ ['x'] = 1127.5, ['y'] = 2670.8, ['z'] = 38.1, ['noBlip'] = true}, -- Sandy Shores Motel
	{ ['x'] = 388.5, ['y'] = 2647.6, ['z'] = 44.5, ['noBlip'] = true}, -- Eastern Motel (sandy)
	{ ['x'] = 967.45831298828, ['y'] = -128.59553527832, ['z'] = 74.387634277344, ['noBlip'] = true}, -- LS biker compound
	{ ['x'] = 2362.2, ['y'] = 3113.97, ['z'] = 48.26, ['noBlip'] = true}, -- Sandy tow
	{ ['x'] = 1754.54, ['y'] = 3293.54, ['z'] = 41.13, ['noBlip'] = true}, -- Sandy airport
	{ ['x'] = 2148.8, ['y'] = 4798.39, ['z'] = 41.1, ['noBlip'] = true}, -- Grapeseed airport
	-- Luxury Autos
	{ ['x'] = -781.39, ['y'] = -235.93, ['z'] = 37.08, ['noBlip'] = true},
	-- Mosleys Autos
	{ ['x'] = -52.32, ['y'] = -1692.79, ['z'] = 29.49, ['noBlip'] = true},
	-- Boat Dock
	{ ['x'] = -725.25, ['y'] = -1409.93, ['z'] = 5.0, ['noBlip'] = false},
	--Boat Dock Paleto
	{ ['x'] = -202.36, ['y'] = 6567.08, ['z'] = 10.96, ['noBlip'] = false},
	-- trucking job garage, parking lot
	{ ['x'] = 1156.6257324219, ['y'] = -3132.2739257813, ['z'] = 5.8998193740845, ['noBlip'] = true },
	-- casino
	{['x'] = 919.86614990234, ['y'] = 48.851104736328, ['z'] = 80.898368835449, ['noBlip'] = true},
	-- VU
	{['x'] = 150.37, ['y'] = -1308.71, ['z'] = 29.2, ['noBlip'] = true},
	-- Weazel News LS
	{['x'] = -616.91394042969, ['y'] = -912.09826660156, ['z'] = 24.021999359131, ["noBlip"] = true},
	{['x'] = 1130.8927001953, ['y'] = 255.72273254395, ['z'] = 80.85563659668, ["noBlip"] = true}, -- casino racetrack
	{x = 419.80194091797, y = -1629.1114501953, z = 29.282044067383, noBlip = true}, -- Davis, LS tow yard
	{x = 4527.1513671875, y = -4529.048828125, z = 4.2344647407532}, -- cayo perico island
	{x = 5171.826171875, y = -4635.3139648438, z = 2.5622141551971, noBlip = true},
	{x=1121.6781, y=-774.7593, z=57.8709, noBlip = true}, -- mirror park repair shop
	{x = -1080.6645507813, y = -1257.9010009766, z = 5.5575938224792, noBlip = true},
	{x = -2187.1748046875, y = 1135.5759277344, z = -23.259094238281, noBlip = true}, -- LS Car Meet
	{x =  1013.5130004883, y = -2358.1096191406, z = 30.509565353394, noBlip = true}, -- LS Fight Club 
	{x = -424.23614501953, y = -38.142559051514, z = 46.215244293213, noBlip = true}, -- cocaktoos
	{x = 550.98217773438, y = -206.7356262207, z = 54.104431152344, noBlip = true} -- auto exotic repair on elgin ave

}

local VEHICLE_DAMAGES = {}
closest_shop = nil

Citizen.CreateThread(function()
    for _, info in pairs(locations) do
			if type(info["jobs"]) == "nil" then
				if not info['noBlip'] then
					info.blip = AddBlipForCoord(info['x'], info['y'], info['z'])
					SetBlipSprite(info.blip, 357)
					SetBlipDisplay(info.blip, 4)
					SetBlipScale(info.blip, info['blipScale'] or 0.7)
					SetBlipAsShortRange(info.blip, true)
					SetBlipColour(info.blip, 18)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Garage")
					EndTextCommandSetBlipName(info.blip)
				end
			end
    end
end)

local nearbyLocations = {}

-- thread to record nearby locations as an optimization
Citizen.CreateThread(function()
	while true do
		local mycoords = GetEntityCoords(PlayerPedId())
		for i = 1, #locations do
			if Vdist(mycoords, locations[i].x, locations[i].y, locations[i].z) < 70 then
				nearbyLocations[i] = true
			else
				nearbyLocations[i] = nil
			end
		end
		Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		for i, isNearby in pairs(nearbyLocations) do
			local info = locations[i]
			local dist = Vdist(GetEntityCoords(ped), info.x, info.y, info.z)
			DrawMarker(27, vector3(info['x'], info['y'], info['z'] - 0.98), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, vector3(4.0, 4.0, 3.0),  118, 137, 122, 150, false, true, 2, false, nil, nil, false)
			if dist < 10 then
				DrawText3D(info['x'], info['y'], info['z'], '[E] - Garage')
			end
			if IsControlJustPressed(0, 86) and dist < 2 then
				Citizen.Wait(50)
				if IsPedInAnyVehicle(ped, true) then
					local handle = GetVehiclePedIsIn(ped, false)
					local numberPlateText = GetVehicleNumberPlateText(handle)
					numberPlateText = exports.globals:trim(numberPlateText)
					TriggerServerEvent("garage:storeVehicle", handle, numberPlateText, info["jobs"])
				else
					closest_shop = info
					TriggerServerEvent("garage:openMenu", info["jobs"])
				end
			end
		end
		Wait(1)
	end
end)

RegisterNetEvent("garage:removeDamages")
AddEventHandler("garage:removeDamages", function(plate)
	if VEHICLE_DAMAGES[plate] then
		VEHICLE_DAMAGES[plate] = nil
	end
end)

RegisterNetEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function()
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	local plate = GetVehicleNumberPlateText(veh)
	plate = exports.globals:trim(plate)
	exports.globals:notify("Vehicle has been returned to the garage!")
	-- store engine / body damage --
	VEHICLE_DAMAGES[plate] = {
		engine_health = GetVehicleEngineHealth(veh),
		body_health = GetVehicleBodyHealth(veh),
		dirt_level = GetVehicleDirtLevel(veh),
		windows = {
			[0] = IsVehicleWindowIntact(veh, 0),
			[1] = IsVehicleWindowIntact(veh, 1),
			[2] = IsVehicleWindowIntact(veh, 2),
			[3] = IsVehicleWindowIntact(veh, 3)
		},
		tires = {
			[0] = IsVehicleTyreBurst(veh, 0, false),
			[1] = IsVehicleTyreBurst(veh, 1, false),
			[4] = IsVehicleTyreBurst(veh, 4, false),
			[5] = IsVehicleTyreBurst(veh, 5, false)
		}
	}
	-- delete veh --
	SetEntityAsMissionEntity(veh, true, true)
	TriggerEvent('persistent-vehicles/forget-vehicle', veh)
	DeleteVehicle(veh)
	-- store vehicle key with vehicle
	TriggerServerEvent("garage:storeKey", plate)
	-- save fuel
	TriggerServerEvent("fuel:save", plate)
end)

RegisterNetEvent("garage:vehicleStored")
AddEventHandler("garage:vehicleStored", function(vehicle)
	TriggerEvent("garage:spawn", vehicle)
end)

RegisterNetEvent("garage:spawn")
AddEventHandler("garage:spawn", function(vehicle)
	local playerVehicle = vehicle
	local modelHash = vehicle.hash
	local plateText = vehicle.plate
	local numberHash = modelHash

	local vehicle_key = {
		name = "Key -- " .. vehicle.plate,
		quantity = 1,
		type = "key",
		owner = vehicle.owner,
		make = vehicle.make,
		model = vehicle.model,
		plate = vehicle.plate
	}

	-- give key to owner
	TriggerServerEvent("garage:giveKey", vehicle_key)

	if type(numberHash) ~= "number" then
		numberHash = GetHashKey(numberHash)
	end

	Citizen.CreateThread(function()

		RequestModel(numberHash)

		while not HasModelLoaded(numberHash) do
			Wait(500)
		end

		local playerPed = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(playerPed, false)
		local heading = GetEntityHeading(playerPed)
		local vehicle = CreateVehicle(numberHash, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
		SetVehicleNumberPlateText(vehicle, plateText)
		SetVehicleOnGroundProperly(vehicle)
		SetVehRadioStation(vehicle, "OFF")
		SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		SetVehicleEngineOn(vehicle, true, false, false)
		SetEntityAsMissionEntity(vehicle, true, true)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)

		-- car customizations
		if playerVehicle.customizations then
			TriggerEvent("customs:applyCustomizations", playerVehicle.customizations)
		end

		-- veh fuel level
		if playerVehicle.stats then
			if playerVehicle.stats.fuel then
				TriggerServerEvent("fuel:setFuelAmount", playerVehicle.plate, playerVehicle.stats.fuel)
			end
		end

		-- any mechanic-installed upgrades
		if playerVehicle.upgrades then
			exports["usa_mechanicjob"]:ApplyUpgrades(vehicle, playerVehicle.upgrades)
		end

		-- apply any damage
		if VEHICLE_DAMAGES[playerVehicle.plate] then
			SetVehicleBodyHealth(vehicle, VEHICLE_DAMAGES[playerVehicle.plate].body_health)
			SetVehicleEngineHealth(vehicle, VEHICLE_DAMAGES[playerVehicle.plate].engine_health)
			SetVehicleDirtLevel(vehicle, VEHICLE_DAMAGES[playerVehicle.plate].dirt_level)
			for index, intact in pairs(VEHICLE_DAMAGES[playerVehicle.plate].windows) do
				if not intact then
					SmashVehicleWindow(vehicle, index)
				end
			end
			for index, isBursted in pairs(VEHICLE_DAMAGES[playerVehicle.plate].tires) do
				if isBursted then
					SetVehicleTyreBurst(vehicle, index, true, 1000.0)
				end
			end
		end

	end)

end)

function DrawText3D(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 470
	DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
end
