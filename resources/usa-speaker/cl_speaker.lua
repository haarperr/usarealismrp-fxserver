local xSound = exports.xsound
local globals = exports.globals

local speakers = {}

local SPEAKER_MAX_VOL = 0.5

TriggerServerEvent("speaker:load")

RegisterNetEvent("speaker:loaded")
AddEventHandler("speaker:loaded", function(loadedSpeakers)
    speakers = loadedSpeakers
    for id, info in pairs(speakers) do
        if info.startedAt then
            xSound:PlayUrlPos(id, info.url, (info.volume / 100) * SPEAKER_MAX_VOL, info.coords, true)
            xSound:Distance(id, info.distance)
            Wait(1000)
            xSound:setTimeStamp(id, info.currentTimestamp)
        end
    end
end)

RegisterNetEvent("speaker:create")
AddEventHandler("speaker:create", function(newSpeaker)
    speakers[newSpeaker.id] = newSpeaker
end)

RegisterNetEvent("speaker:play")
AddEventHandler("speaker:play", function(data)
    xSound:PlayUrlPos(data.id, data.url, (data.volume / 100) * SPEAKER_MAX_VOL, speakers[data.id].coords, true)
    xSound:Distance(data.id, data.distance)
end)

RegisterNetEvent("speaker:stop")
AddEventHandler("speaker:stop", function(data)
    xSound:Destroy(data.id)
end)

RegisterNetEvent("speaker:pickUp")
AddEventHandler("speaker:pickUp", function(data)
    xSound:Destroy(data.id)
    if speakers[data.id].handle then
        DeleteObject(speakers[data.id].handle)
    end
    speakers[data.id] = nil
end)

RegisterNetEvent("speaker:updateVolume")
AddEventHandler("speaker:updateVolume", function(data)
    xSound:setVolume(data.id, (data.new / 100) * SPEAKER_MAX_VOL)
end)

function createSpeakerObject(newSpeaker)
    -- place static object with no collision
    RequestModel(GetHashKey(newSpeaker.model))
  	while not HasModelLoaded(GetHashKey(newSpeaker.model)) do
  		Citizen.Wait(100)
  	end
    local handle = CreateObject(newSpeaker.model, newSpeaker.coords.x, newSpeaker.coords.y, newSpeaker.coords.z, false, false, false)
    SetEntityAsMissionEntity(handle)
    FreezeEntityPosition(handle, true)
    SetEntityCollision(handle, false, true)
    return handle
end

CreateThread(function()
    while true do
        for id, info in pairs(speakers) do
            local dist = #(GetEntityCoords(PlayerPedId()) - info.coords)
            if dist < 100 then
                if not info.handle then
                    info.handle = createSpeakerObject(info)
                end
                if dist < 2 then
                    globals:DrawText3D(info.coords.x, info.coords.y, info.coords.z, "[E] - Interact")
                    if IsControlJustPressed(0, 38) and not showingMenu then
                        TriggerEvent("speaker:toggleMenu", id)
                    end
                end
            else
                if info.handle then
                    DeleteObject(info.handle)
                    info.handle = nil
                end
            end
        end
        Wait(1)
    end
end)