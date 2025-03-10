local vehicles = {}
local lastNitro = 0
local nitroCooldown = 30000 -- TODO: per-vehicle cooldown?

local defaultNitroFuelSize = 0
local nitroFuelDrainRate = 10
local nitroPurgeFuelDrainRate = nitroFuelDrainRate * 2
local nitroRechargeRate = nitroFuelDrainRate / 2

function InitNitroFuel(vehicle)
  if not vehicles[vehicle] then
    vehicles[vehicle] = defaultNitroFuelSize
  end
end

function DrainNitroFuel(vehicle, purge)
  if not purge then
    purge = false
  end

  if not vehicles[vehicle] then
    vehicles[vehicle] = defaultNitroFuelSize
  end

  if vehicles[vehicle] > 0 then
    if purge then
      vehicles[vehicle] = vehicles[vehicle] - nitroFuelDrainRate * 2
    else
      vehicles[vehicle] = vehicles[vehicle] - nitroFuelDrainRate
    end
    lastNitro = GetGameTimer()
  end
end

function RechargeNitroFuel(vehicle)
  if not vehicles[vehicle] then
    vehicles[vehicle] = defaultNitroFuelSize
  end

  if vehicles[vehicle] and vehicles[vehicle] < defaultNitroFuelSize then
    vehicles[vehicle] = vehicles[vehicle] + nitroRechargeRate
  end
end

function GetNitroFuelLevel(vehicle)
  if vehicles[vehicle] then
    return math.max(0, vehicles[vehicle])
  end

  return 0
end

function SetNitroFuelLevel(vehicle, level)
  print("nitro fuel level set to: " .. level)
  vehicles[vehicle] = level
end

Citizen.CreateThread(function ()
  local function FuelLoop()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local isRunning = GetIsVehicleEngineRunning(vehicle)
    local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
    local isPurging = IsVehicleNitroPurgeEnabled(vehicle)

    if vehicle == 0 or driver ~= player or not isRunning then
      return
    end

    if isRunning then
      if isBoosting == true then
        DrainNitroFuel(vehicle, false)
      elseif isPurging == true then
        DrainNitroFuel(vehicle, true)
      end
    end
  end

  while true do
    Citizen.Wait(0)
    FuelLoop()
  end
end)