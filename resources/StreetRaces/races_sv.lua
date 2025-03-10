-- Server side array of active races
local races = {}

-- Cleanup thread
Citizen.CreateThread(function()
    -- Loop forever and check status every 100ms
    while true do
        Citizen.Wait(100)

        -- Check active races and remove any that become inactive
        for index, race in pairs(races) do
            -- Get time and players in race
            local time = GetGameTimer()
            local players = race.players

            -- Check start time and player count
            if (time > race.startTime) and (#players == 0) then
                -- Race past start time with no players, remove race and send event to all clients
                table.remove(races, index)
                TriggerClientEvent("StreetRaces:removeRace_cl", -1, index)
            -- Check if race has finished and expired
            elseif (race.finishTime ~= 0) and (time > race.finishTime + race.finishTimeout) then
                -- Did not finish, notify players still racing
                for _, player in pairs(players) do
                    notifyPlayer(player, "DNF (timeout)")
                end

                -- Remove race and send event to all clients
                table.remove(races, index)
                TriggerClientEvent("StreetRaces:removeRace_cl", -1, index)
            end
        end
    end
end)

-- Server event for creating a race
RegisterServerEvent("StreetRaces:createRace_sv")
AddEventHandler("StreetRaces:createRace_sv", function(amount, startDelay, startCoords, checkpoints, finishTimeout)
    -- Add fields to race struct and add to races array
    local race = {
        owner = source,
        amount = amount,
        startTime = GetGameTimer() + startDelay,
        startCoords = startCoords,
        checkpoints = checkpoints,
        finishTimeout = config_sv.finishTimeout,
        players = {},
        prize = 0,
        finishTime = 0
    }
    table.insert(races, race)

    -- Send race data to all clients
    local index = #races
    TriggerClientEvent("StreetRaces:createRace_cl", -1, index, amount, startDelay, startCoords, checkpoints)
end)

-- Server event for canceling a race
RegisterServerEvent("StreetRaces:cancelRace_sv")
AddEventHandler("StreetRaces:cancelRace_sv", function()
    -- Iterate through races
    for index, race in pairs(races) do
        -- Find if source player owns a race that hasn't started
        local time = GetGameTimer()
        if source == race.owner and time < race.startTime then
            -- Send notification and refund money for all entered players
            for _, player in pairs(race.players) do
                -- Refund money to player and remove from prize pool
                addMoney(player, race.amount)
                race.prize = race.prize - race.amount

                -- Notify player race has been canceled
                local msg = "Race canceled"
                notifyPlayer(player, msg)
            end

            -- Remove race from table and send client event
            table.remove(races, index)
            TriggerClientEvent("StreetRaces:removeRace_cl", -1, index)
        end
    end
end)

-- Server event for joining a race
RegisterServerEvent("StreetRaces:joinRace_sv")
AddEventHandler("StreetRaces:joinRace_sv", function(index)
    -- Validate and deduct player money
    local race = races[index]
    local amount = race.amount
    local playerMoney = getMoney(source)
    if playerMoney >= amount then
        -- Deduct money from player and add to prize pool
        removeMoney(source, amount)
        race.prize = race.prize + amount

        -- Add player to race and send join event back to client
        table.insert(races[index].players, source)
        TriggerClientEvent("StreetRaces:joinedRace_cl", source, index)
    else
        -- Insufficient money, send notification back to client
        local msg = "Insuffient funds to join race"
        notifyPlayer(source, msg)
    end
end)

-- Server event for leaving a race
RegisterServerEvent("StreetRaces:leaveRace_sv")
AddEventHandler("StreetRaces:leaveRace_sv", function(index)
    -- Validate player is part of the race
    local race = races[index]
    local players = race.players
    for index, player in pairs(players) do
        if source == player then
            -- Remove player from race and break
            table.remove(players, index)
            break
        end
    end
end)

-- Server event for finishing a race
RegisterServerEvent("StreetRaces:finishedRace_sv")
AddEventHandler("StreetRaces:finishedRace_sv", function(index, time)
    -- Check player was part of the race
    local race = races[index]
    local players = race.players
    for index, player in pairs(players) do
        if source == player then 
            -- Calculate finish time
            local time = GetGameTimer()
            local timeSeconds = (time - race.startTime)/1000.0
            local timeMinutes = math.floor(timeSeconds/60.0)
            timeSeconds = timeSeconds - 60.0*timeMinutes

            -- If race has not finished already
            if race.finishTime == 0 then
                -- Winner, set finish time and award prize money
                race.finishTime = time
                addMoney(source, race.prize)

                -- Send winner notification to players
                for _, pSource in pairs(players) do
                    if pSource == source then
                        local msg = ("You won [%02d:%06.3f]"):format(timeMinutes, timeSeconds)
                        notifyPlayer(pSource, msg)
                    elseif config_sv.notifyOfWinner then
                        local msg = ("%s won [%02d:%06.3f]"):format(getName(source), timeMinutes, timeSeconds)
                        notifyPlayer(pSource, msg)
                    end
                end
            else
                -- Loser, send notification to only the player
                local msg = ("You lost [%02d:%06.3f]"):format(timeMinutes, timeSeconds)
                notifyPlayer(source, msg)
            end

            -- Remove player form list and break
            table.remove(players, index)
            break
        end
    end
end)

-- Server event for saving recorded checkpoints as a race
RegisterServerEvent("StreetRaces:saveRace_sv")
AddEventHandler("StreetRaces:saveRace_sv", function(name, checkpoints)
    -- Cleanup data so it can be serialized
    for _, checkpoint in pairs(checkpoints) do
        checkpoint.blip = nil
        checkpoint.coords = {x = checkpoint.coords.x, y = checkpoint.coords.y, z = checkpoint.coords.z}
    end

    -- Get saved player races, add race and save
    local src = source
    loadPlayerData(src, function(playerRaces)
        if not playerRaces[name] then
            playerRaces[name] = checkpoints
            savePlayerData(src, playerRaces)

            -- Send notification to player12
            local msg = "Saved " .. name
            notifyPlayer(src, msg)
        else 
            TriggerClientEvent("usa:notify", src, "Race name taken!")
        end
    end)
end)

-- Server event for deleting recorded race
RegisterServerEvent("StreetRaces:deleteRace_sv")
AddEventHandler("StreetRaces:deleteRace_sv", function(name)
    -- Get saved player races
    local src = source
    loadPlayerData(src, function(playerRaces)
        -- Check if race with name exists
        if playerRaces[name] ~= nil then
            print("deleteing playerRaces[" .. name .. "]!")
            print(exports.globals:dump(playerRaces[name]))
            -- Delete race and save data
            playerRaces[name] = "deleteMePlz!" -- special string used to delete rows now since setting to nil won't do it alone using .updateDocument
            savePlayerData(src, playerRaces)

            -- Send notification to player
            local msg = "Deleted " .. name
            notifyPlayer(src, msg)
        else
            local msg = "No race found with name " .. name
            notifyPlayer(src, msg)
        end
    end)
end)

-- Server event for listing recorded races
RegisterServerEvent("StreetRaces:listRaces_sv")
AddEventHandler("StreetRaces:listRaces_sv", function()
    -- Get saved player races and iterate through saved races
    local msg = "Saved races: "
    local count = 0
    local src = source
    loadPlayerData(src, function(playerRaces)
        for name, race in pairs(playerRaces) do
            if name ~= "_id" and name ~= "_rev" then
                msg = msg .. name .. ", "
                count = count + 1
            end
        end

        -- Fix string formatting
        if count > 0 then
            msg = string.sub(msg, 1, -3)
        end

        -- Send notification to player with listing
        notifyPlayer(src, msg)
    end)
end)

-- Server event for loaded recorded race
RegisterServerEvent("StreetRaces:loadRace_sv")
AddEventHandler("StreetRaces:loadRace_sv", function(name)
    -- Get saved player races and load race
    local src = source
    loadPlayerData(src, function(playerRaces)
        local race = playerRaces[name]

        -- If race was found send it to the client
        if race ~= nil then
            -- Send race data to client
            TriggerClientEvent("StreetRaces:loadRace_cl", src, race)

            -- Send notification to player
            local msg = "Loaded " .. name
            notifyPlayer(src, msg)
        else
            local msg = "No race found with name " .. name
            notifyPlayer(src, msg)
        end
    end)
end)

TriggerEvent('es:addCommand', 'race', function(source, args, char)
    table.remove(args, 1)
    TriggerClientEvent("StreetRaces:handleCommand", source, args)
end, { help = "Start or load a race! Options: clear, leave, record, start [betAmount] [delay (optional)], save [name], load [name], list, delete [name], cancel" })