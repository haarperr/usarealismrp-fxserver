--# by minipunch
--# for USA REALISM rp
--# Made for the 24/7 stores as general stores for various items

local GENERAL_STORE_LOCATIONS = {
    {x=1960.981, y=3739.764, z=32.543 }, -- Sandy Shores
    { x=372.996, y=325.607, z=103.766 }, -- Clinton Ave
    --{ x=1136.534, y=-971.131, z=45.415 },
    {x = 1134.92, y = -983.06, z = 46.6}, -- El Rancho Blvd
    { x=-1221.888, y=-907.435, z=12.526 }, -- San Andreas Ave
    { x=25.07, y=-1348.019, z=29.697 }, -- Innocence Blvd
    { x=-47.877, y=-1758.3689, z=29.621 }, -- Grove St.
    {x=-706.714, y=-914.608, z=19.415 }, -- Ginger St.
    { x=1165.2210, y=2710.220, z=38.357 }, -- Route 68
    { x=1697.578, y=4924.014, z=42.263 }, -- Grapeseed Main St.
    { x=1728.165, y=6414.316, z=35.237 }, -- Paleto Bay
    { x=-3038.484, y=585.294, z=8.108 }, -- Ineseno Road
    { x=1164.349, y=-323.805, z=69.355 }, -- Mirror Park Blvd.
    {  x=2557.936, y=381.366, z=108.822 }, -- Palomino Fwy
    { x=2678.981, y=3279.541, z=55.441 }, -- Senora Fwy.
    { x=548.286, y=2672.005, z=42.35 }, -- Harmony
    { x=-1819.872, y=793.053, z=138.259 }, -- Banham Canyon Dr.
    { x=-3241.570, y=1000.506, z=12.990 }, -- Barbareno Rd.
    {x=-2967.086, y=391.539, z=15.243 }, -- Great Ocean Hwy
    {x = 1780.9207763672,y = 2598.8671875, z = 45.797817230225, prison = true}, -- Prison
    {x = 4503.35546875, y = -4520.0258789062, z = 4.4123592376709}, -- Cayo Perico island
    {x = -689.92376708984, y = 5798.9174804688, z = 17.3327293396}, -- bayview lodge in paleto bay
    {x = -1486.119140625, y = -378.06628417969, z = 40.163429260254}, -- prosperity st
    {x = 1335.2287597656, y = -1650.7325439453, z = 52.239276885986} -- near fudge (secret coke lab mlo)
}

local ShopliftingAreas = {}

RegisterNetEvent('generalStore:loadShopliftAreas')
AddEventHandler('generalStore:loadShopliftAreas', function(areas)
  ShopliftingAreas = areas
end)

TriggerServerEvent('generalStore:loadShopliftAreas')

local HARDWARE_STORE_LOCATIONS = {
  {x = 46.38, y = -1749.47, z = 29.63},
  {x = 2748.35, y = 3472.56, z = 55.67}
}

--------------------
-- Spawn job peds --
--------------------
local JOB_PEDS = { -- Z coords are Z-1 or the ped will float!
  --{x = -331.043, y = 6086.09, z = 30.40, heading = 180.0}
  --[[
  {x = 1727.7, y = 6415.6, z = 34.03, heading = 250.0},
  {x = 549.2, y = 2670.9, z = 41.2, heading = 95.0, hash = -573920724}, -- harmony
  {x = 1165.9, y = 2710.9, z = 37.2, heading = 180.0, hash = -573920724}, -- harmony
  {x = 1959.96, y = 3740.2, z = 32.3, heading = 300.0, hash = -573920724}, -- sandy shores
  {x = -3242.6, y = 999.9, z = 11.83, heading = 320.0, hash = -573920724}, -- north west los santos coast
  {x = -3039.1, y = 584.5, z = 6.9, heading = 30.0, hash = -573920724}, -- north west los santos coast
  {x = -2966.1, y = 390.8, z = 15.0, heading = 85.0, hash = -573920724}, -- north west los santos coast
  {x = 372.5, y = 326.7, z = 102.6, heading = 250.0, hash = -573920724}, -- los santos
  {x = -1221.7, y = -908.5, z = 11.3, heading = 40.0, hash = -573920724}, -- los santos
  {x = 1133.9, y = -982.6, z = 46.2, heading = 260.0, hash = -573920724}, -- los santos
  {x = -47.0, y = -1758.6, z = 28.4, heading = 90.0}, -- los santos
  {x = 24.34, y = -1347.215, z = 28.49, heading = 270.0}, -- los santos
  {x = -705.99, y = -914.53, z = 18.21, heading = 95.55}, -- los santos
  {x = 1697.088, y = 4923.35, z = 41.06, heading = 322.0}, -- los santos
  {x = 1165.02, y = -323.60, z = 68.2, heading = 95.0}, -- los santos
  {x = 2557.145, y = 380.64, z = 107.62, heading = 350.0, hash = -573920724}, -- sandy
  {x = 2677.729, y = 3279.42, z = 54.24, heading = 330.0, hash = -573920724}, -- senora fwy
  {x = -1819.304, y = 793.56, z = 137.088, heading = 132.0}, -- richman
  --]]
  {x = 1335.4675292969, y = -1651.5319824219, z = 51.249050140381, heading = 40.0}
}

local BLIPS = {}
local GENERAL_STORE_ITEMS = {} -- loaded from server
local HARDWARE_STORE_ITEMS = {}
local closest_location = nil

local MENU_KEY = 38

local TIMEOUT = nil

-------------------
-- utility funcs --
-------------------
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

function IsNearStore(store)
  local mycoords = GetEntityCoords(GetPlayerPed(-1))
  if Vdist(store.x, store.y, store.z, mycoords.x, mycoords.y, mycoords.z) < 1.7 then
    return true
  else
    return false
  end
end

function DrawText3D(x, y, z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
end

----------------------
---- Set up blips ----
----------------------
for i = 1, #GENERAL_STORE_LOCATIONS do
  if not GENERAL_STORE_LOCATIONS[i].prison then
    local blip = AddBlipForCoord(GENERAL_STORE_LOCATIONS[i].x, GENERAL_STORE_LOCATIONS[i].y, GENERAL_STORE_LOCATIONS[i].z)
    SetBlipSprite(blip, 52)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 36)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('General Store')
    EndTextCommandSetBlipName(blip)
  end
end
for i = 1, #HARDWARE_STORE_LOCATIONS do
  local blip = AddBlipForCoord(HARDWARE_STORE_LOCATIONS[i].x, HARDWARE_STORE_LOCATIONS[i].y, HARDWARE_STORE_LOCATIONS[i].z)
  SetBlipSprite(blip, 473)
  SetBlipDisplay(blip, 4)
  SetBlipScale(blip, 0.7)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip, 64)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Hardware Store')
  EndTextCommandSetBlipName(blip)
end

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("General Store", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
mainMenuHardware = NativeUI.CreateMenu("Hardware Store", "~b~Welcome!", 0, 320)
_menuPool:Add(mainMenu)
_menuPool:Add(mainMenuHardware)

--------------------------------
-- Construct GUI menu buttons --
--------------------------------
function CreateGeneralStoreMenu(menu, generalStoreItems)
  -----------------------------------
  -- Adds button for each category --
  -----------------------------------
  for category, items in pairs(generalStoreItems) do
    local submenu = _menuPool:AddSubMenu(menu, category, "See our selection of " .. category .. " items", true --[[KEEP POSITION]])
    for i = 1, #items do
      ---------------------------------------------
      -- Button for each item in each category --
      ---------------------------------------------
      local item = NativeUI.CreateItem(items[i].name, "Purchase price: $" .. comma_value(items[i].price))
      item.Activated = function(parentmenu, selected)
        if not TIMEOUT then
          TIMEOUT = GetGameTimer()
          local business = exports["usa-businesses"]:GetClosestStore(15)
          TriggerServerEvent("generalStore:buyItem", items[i], 'GENERAL', closest_location.prison, business)
          Citizen.CreateThread(function()
            while GetGameTimer() - TIMEOUT < 200 do
              Wait(100)
            end
            TIMEOUT = nil
          end)
        end
      end
      ----------------------------------------
      -- add to sub menu created previously --
      ----------------------------------------
      submenu.SubMenu:AddItem(item)
    end
  end
  ----------------------------
  -- Close menu button --
  ----------------------------
  local item = NativeUI.CreateItem("Close", "Close the menu.")
  item.Activated = function(parentmenu, selected)
    _menuPool:CloseAllMenus()
  end
  menu:AddItem(item)
  menu:Visible(true)
end

function CreateHardwareStoreMenu(menu, hardwareStoreItems)
  -----------------------------------
  -- Adds button for each category --
  -----------------------------------
  for category, items in pairs(hardwareStoreItems) do
    local submenu = _menuPool:AddSubMenu(menu, category, "See our selection of " .. category .. " items", true --[[KEEP POSITION]])
    for i = 1, #items do
      -------------------------------------------
      -- Button for each item in each category --
      -------------------------------------------
      local item = NativeUI.CreateItem(items[i].name, "Purchase price: $" .. comma_value(items[i].price))
      item.Activated = function(parentmenu, selected)
        if not TIMEOUT then
          TIMEOUT = GetGameTimer()
          local business = exports["usa-businesses"]:GetClosestStore(15)
          TriggerServerEvent("generalStore:buyItem", items[i], 'HARDWARE', nil, business)
          Citizen.CreateThread(function()
            while GetGameTimer() - TIMEOUT < 200 do
              Wait(100)
            end
            TIMEOUT = nil
          end)
        end
      end
      ----------------------------------------
      -- add to sub menu created previously --
      ----------------------------------------
      submenu.SubMenu:AddItem(item)
    end
  end
  ----------------------------
  -- Close menu button --
  ----------------------------
  local item = NativeUI.CreateItem("Close", "Close the menu.")
  item.Activated = function(parentmenu, selected)
    _menuPool:CloseAllMenus()
  end
  menu:AddItem(item)
  menu:Visible(true)
end

local NEARBY_GENERAL_STORE_LOCATIONS = {}
local NearbyShopliftingAreas = {}
local NEARBY_HARDWARE_STORE_LOCATIONS = {}

Citizen.CreateThread(function()
  while true do
    local mycoords = GetEntityCoords(GetPlayerPed(-1))

    for i = 1, #GENERAL_STORE_LOCATIONS do
      local dist = Vdist(mycoords.x, mycoords.y, mycoords.z, GENERAL_STORE_LOCATIONS[i].x, GENERAL_STORE_LOCATIONS[i].y, GENERAL_STORE_LOCATIONS[i].z)
      if dist < 5 then
        NEARBY_GENERAL_STORE_LOCATIONS[i] = true
      else
        NEARBY_GENERAL_STORE_LOCATIONS[i] = nil
      end
    end

    for i = 1, #ShopliftingAreas do
      local dist = Vdist(mycoords.x, mycoords.y, mycoords.z, ShopliftingAreas[i].x, ShopliftingAreas[i].y, ShopliftingAreas[i].z)
      if dist < 1.5 then
        NearbyShopliftingAreas[i] = true
      else
        NearbyShopliftingAreas[i] = nil
      end
    end

    for i = 1, #HARDWARE_STORE_LOCATIONS do
      local dist = Vdist(mycoords.x, mycoords.y, mycoords.z, HARDWARE_STORE_LOCATIONS[i].x, HARDWARE_STORE_LOCATIONS[i].y, HARDWARE_STORE_LOCATIONS[i].z)
      if dist < 7 then
        NEARBY_HARDWARE_STORE_LOCATIONS[i] = true
      else
        NEARBY_HARDWARE_STORE_LOCATIONS[i] = nil
      end
    end

    Wait(500)
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(1)
    _menuPool:MouseControlsEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:ProcessMenus()
    local mycoords = GetEntityCoords(GetPlayerPed(-1))
    for index, isNearby in pairs(NEARBY_GENERAL_STORE_LOCATIONS) do
      DrawText3D(GENERAL_STORE_LOCATIONS[index].x, GENERAL_STORE_LOCATIONS[index].y, GENERAL_STORE_LOCATIONS[index].z, '[E] - General Store')
    end

    for index, isNearby in pairs(NearbyShopliftingAreas) do
      exports.globals:DrawText3D(ShopliftingAreas[index].x, ShopliftingAreas[index].y, ShopliftingAreas[index].z, '[E] - Shoplift')
      if IsControlJustPressed(1, MENU_KEY) then
        if IsNearStore(ShopliftingAreas[index]) then
          TriggerServerEvent('generalStore:attemptShoplift', index)
        end
      end
    end

    for index, isNearby in pairs(NEARBY_HARDWARE_STORE_LOCATIONS) do
      DrawText3D(HARDWARE_STORE_LOCATIONS[index].x, HARDWARE_STORE_LOCATIONS[index].y, HARDWARE_STORE_LOCATIONS[index].z, '[E] - Hardware Store')
    end

    if IsControlJustPressed(1, MENU_KEY) and not _menuPool:IsAnyMenuOpen() then
      -- see if close to any stores --
      for i = 1, #GENERAL_STORE_LOCATIONS do
        if IsNearStore(GENERAL_STORE_LOCATIONS[i]) then
          mainMenu:Visible(true)
          closest_location = GENERAL_STORE_LOCATIONS[i]
        end
      end
      for i = 1, #HARDWARE_STORE_LOCATIONS do
        if IsNearStore(HARDWARE_STORE_LOCATIONS[i]) then
          mainMenuHardware:Visible(true)
          closest_location = HARDWARE_STORE_LOCATIONS[i]
        end
      end
    end
    -- close menu when far away --
    if closest_location then
      if not IsNearStore(closest_location) then
        if _menuPool:IsAnyMenuOpen() then
          closest_location = nil
          _menuPool:CloseAllMenus()
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    local playerCoords = GetEntityCoords(PlayerPedId(), false)
    for i = 1, #JOB_PEDS do
      if Vdist(JOB_PEDS[i].x, JOB_PEDS[i].y, JOB_PEDS[i].z, playerCoords.x, playerCoords.y, playerCoords.z) < 60 then
        if not JOB_PEDS[i].pedHandle then
          local hash = -840346158
          if JOB_PEDS[i].hash then
            hash = JOB_PEDS[i].hash
          end
          RequestModel(hash)
          while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(0)
          end
          local ped = CreatePed(4, hash, JOB_PEDS[i].x, JOB_PEDS[i].y, JOB_PEDS[i].z, JOB_PEDS[i].heading, false, true)
          SetEntityCanBeDamaged(ped,false)
          SetPedCanRagdollFromPlayerImpact(ped,false)
          TaskSetBlockingOfNonTemporaryEvents(ped,true)
          SetPedFleeAttributes(ped,0,0)
          SetPedCombatAttributes(ped,17,1)
          SetPedRandomComponentVariation(ped, true)
          TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true)
          JOB_PEDS[i].pedHandle = ped
        end
      else 
        if JOB_PEDS[i].pedHandle then
          DeletePed(JOB_PEDS[i].pedHandle)
          JOB_PEDS[i].pedHandle = nil
        end
      end
    end
    Wait(100)
  end
end)

RegisterNetEvent('generalStore:performShoplift')
AddEventHandler('generalStore:performShoplift', function(area)
  local beginTime = GetGameTimer()
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)
  local SHOPLIFT_ANIMATION_TIME_SECONDS = 10

  if math.random() < 0.2 then -- 20% chance to call police
    local x, y, z = table.unpack(playerCoords)
    local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
    local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
    local isMale = true
    if GetEntityModel(playerPed) == GetHashKey("mp_f_freemode_01") then
      isMale = false
    elseif GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01") then 
      isMale = true
    else
      isMale = IsPedMale(playerPed)
    end
    TriggerServerEvent("911:Shoplifting", x, y, z, lastStreetNAME, isMale)
  end

  exports.globals:loadAnimDict("anim@am_hold_up@male") -- play animation
  while GetGameTimer() - beginTime < SHOPLIFT_ANIMATION_TIME_SECONDS * 1000 do
    exports.globals:DrawTimerBar(beginTime, SHOPLIFT_ANIMATION_TIME_SECONDS * 1000, 1.42, 1.475, 'Stealing')
    if not IsEntityPlayingAnim(playerPed, "anim@am_hold_up@male", "shoplift_mid", 3) then
      TaskPlayAnim(playerPed, "anim@am_hold_up@male", "shoplift_mid", 8.0, 1.0, SHOPLIFT_ANIMATION_TIME_SECONDS * 1000, 11, 1.0, false, false, false)
    end
    DisableControlAction(0, 86, true) -- disable spamming E
    Wait(1)
  end
  ClearPedTasks(playerPed)

  TriggerServerEvent('generalStore:giveStolenItem') -- give item
end)

RegisterNetEvent('generalStore:markAsShoplifted')
AddEventHandler('generalStore:markAsShoplifted', function(area)
  ShopliftingAreas[area].shoplifted = true
end)


RegisterNetEvent("generalStore:loadItems")
AddEventHandler("generalStore:loadItems", function(items)
  -----------------
  -- Create Menu --
  -----------------
  CreateGeneralStoreMenu(mainMenu, items)
  mainMenu:Visible(false)
  _menuPool:RefreshIndex()
end)

RegisterNetEvent("hardwareStore:loadItems")
AddEventHandler("hardwareStore:loadItems", function(items)
  -----------------
  -- Create Menu --
  -----------------
  CreateHardwareStoreMenu(mainMenuHardware, items)
  mainMenuHardware:Visible(false)
  _menuPool:RefreshIndex()
end)

TriggerServerEvent("hardwareStore:loadItems")
TriggerServerEvent("generalStore:loadItems")