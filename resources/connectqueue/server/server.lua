local Config = {}
----------------------------------------------------------------------------------------------------------------------
-- Priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other priorities
Config.Priority = {
    ["STEAM_0:1:#######"] = 50,
    ["steam:110000######"] = 25,
    ["ip:127.0.0.0"] = 85
    -- end examples, start real peeps...
}

Config.RequireSteam = true
Config.PriorityOnly = false -- whitelist only server

Config.IsBanned = function(src, callback)
    callback(false) -- not banned
    -- or callback(true, "reason") -- banned and the reason
end

-- easy localization
Config.Language = {
    joining = "Joining...",
    connecting = "Connecting, get ready...",
    err = "Error: Couldn't retrieve any of your id's, try restarting.",
    _err = "There was an error",
    pos = "[Auto Queue] You are %d/%d in queue",
    connectingerr = "Error adding you to connecting list",
    banned = "You are banned, you may appeal it at https://usarrp.enjin.com | Reason: %s",
    steam = "Error: Steam must be running",
    prio = "This server is whitelisted! Apply to join the closed testing at: https://forms.gle/c6DcxREwr15fLdxx9"
}
-----------------------------------------------------------------------------------------------------------------------

local Queue = {}
Queue.QueueList = {}
Queue.PlayerList = {}
Queue.PlayerCount = 0
Queue.Priority = {}
Queue.Connecting = {}
Queue.ThreadCount = 0
Queue.PublicPlayerCount = 0
Queue.MaxPublicPlayerCount = 1500000 -- temporary because broken

local debug = false
local displayQueue = false
local initHostName = false
local maxPlayers = 110

local tostring = tostring
local tonumber = tonumber
local ipairs = ipairs
local pairs = pairs
local print = print
local string_sub = string.sub
local string_format = string.format
local string_lower = string.lower
local math_abs = math.abs
local math_floor = math.floor
local os_time = os.time
local table_insert = table.insert
local table_remove = table.remove

for k,v in pairs(Config.Priority) do
    Queue.Priority[string_lower(k)] = v
end

-- converts hex steamid to SteamID 32
function Queue:HexIdToSteamId(hexId)
    local cid = math_floor(tonumber(string_sub(hexId, 7), 16))
	local steam64 = math_floor(tonumber(string_sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math_floor(math_abs(6561197960265728 - steam64 - a) / 2)
	local sid = "steam_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end

function Queue:IsSteamRunning(src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 5) == "steam" then
            return true
        end
    end

    return false
end

function Queue:DebugPrint(msg)
    if debug then
        msg = "QUEUE: " .. tostring(msg)
        print(msg)
    end
end

function Queue:IsInQueue(ids, rtnTbl, bySource, connecting)
    for k,v in ipairs(connecting and self.Connecting or self.QueueList) do
        local inQueue = false

        if not bySource then
            for i,j in ipairs(v.ids) do
                if inQueue then break end

                for q,e in ipairs(ids) do
                    if e == j then inQueue = true break end
                end
            end
        else
            inQueue = ids == v.source
        end

        if inQueue then
            if rtnTbl then
                return k, connecting and self.Connecting[k] or self.QueueList[k]
            end

            return true
        end
    end

    return false
end

function Queue:IsPriority(ids)
    for k,v in ipairs(ids) do
        v = string_lower(v)

        if string_sub(v, 1, 5) == "steam" and not self.Priority[v] then
            local steamid = self:HexIdToSteamId(v)
            if self.Priority[steamid] then return self.Priority[steamid] ~= nil and self.Priority[steamid] or false end
        end

        if self.Priority[v] then return self.Priority[v] ~= nil and self.Priority[v] or false end
    end
end

function Queue:AddToQueue(ids, connectTime, name, src, deferrals)
    if self:IsInQueue(ids) then return end

    local tmp = {
        source = src,
        ids = ids,
        name = name,
        firstconnect = connectTime,
        priority = self:IsPriority(ids) or (src == "debug" and math.random(0, 15)),
        timeout = 0,
        deferrals = deferrals
    }

    local _pos = false
    local queueCount = self:GetSize() + 1

    for k,v in ipairs(self.QueueList) do
        if tmp.priority then
            if not v.priority then
                _pos = k
            else
                if tmp.priority > v.priority then
                    _pos = k
                end
            end

            if _pos then
                self:DebugPrint(string_format("%s[%s] was prioritized and placed %d/%d in queue", tmp.name, ids[1], _pos, queueCount))
                break
            end
        end
    end

    if not _pos then
        _pos = self:GetSize() + 1
        self:DebugPrint(string_format("%s[%s] was placed %d/%d in queue", tmp.name, ids[1], _pos, queueCount))
    end

    table_insert(self.QueueList, _pos, tmp)
end

function Queue:RemoveFromQueue(ids, bySource)
    if self:IsInQueue(ids, false, bySource) then
        local pos, data = self:IsInQueue(ids, true, bySource)
        table_remove(self.QueueList, pos)
    end
end

function Queue:GetSize()
    return #self.QueueList
end

function Queue:ConnectingSize()
    return #self.Connecting
end

function Queue:IsInConnecting(ids, bySource, refresh)
    local inConnecting, tbl = self:IsInQueue(ids, refresh and true or false, bySource and true or false, true)

    if not inConnecting then return false end

    if refresh and inConnecting and tbl then
        self.Connecting[inConnecting].timeout = 0
    end

    return true
end

function Queue:RemoveFromConnecting(ids, bySource)
    for k,v in ipairs(self.Connecting) do
        local inConnecting = false

        if not bySource then
            for i,j in ipairs(v.ids) do
                if inConnecting then break end

                for q,e in ipairs(ids) do
                    if e == j then inConnecting = true break end
                end
            end
        else
            inConnecting = ids == v.source
        end

        if inConnecting then
            table_remove(self.Connecting, k)
            return true
        end
    end

    return false
end

function Queue:AddToConnecting(ids, ignorePos, autoRemove, done)
    local function removeFromQueue()
        if not autoRemove then return end

        done(Config.Language.connectingerr)
        self:RemoveFromConnecting(ids)
        self:RemoveFromQueue(ids)
        self:DebugPrint("Player could not be added to the connecting list")
    end

    if self:ConnectingSize() >= 5 then removeFromQueue() return false end
    if ids[1] == "debug" then
        table_insert(self.Connecting, {source = ids[1], ids = ids, name = ids[1], firstconnect = ids[1], priority = ids[1], timeout = 0})
        return true
    end

    if self:IsInConnecting(ids) then self:RemoveFromConnecting(ids) end

    local pos, data = self:IsInQueue(ids, true)
    if not ignorePos and (not pos or pos > 1) then removeFromQueue() return false end

    table_insert(self.Connecting, data)
    self:RemoveFromQueue(ids)
    return true
end

function Queue:GetIds(src)
    local ids = GetPlayerIdentifiers(src)
    ids = (ids and ids[1]) and ids or {"ip:" .. GetPlayerEP(src)}
    ids = ids ~= nil and ids or false

    if ids and #ids > 1 then
        for k,v in ipairs(ids) do
            if string.sub(v, 1, 3) == "ip:" then table_remove(ids, k) end
        end
    end

    return ids
end

function Queue:AddPriority(id, power)
    if not id then return false end

    if type(id) == "table" then
        for k, v in pairs(id) do
            if k and type(k) == "string" and v and type(v) == "number" then
                self.Priority[k] = v
            else
                self:DebugPrint("Error adding a priority id, invalid data passed")
                return false
            end
        end

        return true
    end

    power = (power and type(power) == "number") and power or 10
    self.Priority[string_lower(id)] = power

    return true
end

function Queue:RemovePriority(id)
    if not id then return false end
    self.Priority[id] = nil
    return true
end

function Queue:UpdatePosData(src, ids, deferrals)
    local pos, data = self:IsInQueue(ids, true)
    self.QueueList[pos].source = src
    self.QueueList[pos].ids = ids
    self.QueueList[pos].timeout = 0
    self.QueueList[pos].deferrals = deferrals
end

function Queue:NotFull(firstJoin)
    local canJoin = self.PlayerCount + self:ConnectingSize() < maxPlayers and self:ConnectingSize() < 5
    canJoin = firstJoin and (self:GetSize() <= 1 and canJoin) or canJoin
    return canJoin
end

function Queue:SetPos(ids, newPos)
    local pos, data = self:IsInQueue(ids, true)

    table_remove(self.QueueList, pos)
    table_insert(self.QueueList, newPos, data)

    Queue:DebugPrint("Set " .. data.name .. "[" .. data.ids[1] .. "] pos to " .. newPos)
end

-- export
function AddPriority(id, power)
    return Queue:AddPriority(id, power)
end

-- export
function RemovePriority(id)
    return Queue:RemovePriority(id)
end

Citizen.CreateThread(function()
    local function playerConnect(name, setKickReason, deferrals)
        maxPlayers = GetConvarInt("sv_maxclients", 60)
        debug = GetConvar("sv_debugqueue", "true") == "true" and true or false
        displayQueue = GetConvar("sv_displayqueue", "true") == "true" and true or false
        initHostName = not initHostName and GetConvar("sv_hostname") or initHostName

        local src = source
        local ids = Queue:GetIds(src)
        local connectTime = os_time()
        local connecting = true

        deferrals.defer()

        Citizen.CreateThread(function()
            while connecting do
                Citizen.Wait(500)
                if not connecting then return end
                deferrals.update(Config.Language.connecting)
            end
        end)

        Citizen.Wait(1000)

        local function done(msg)
            connecting = false
            if not msg then deferrals.done() else deferrals.done(tostring(msg) and tostring(msg) or "") CancelEvent() end
        end

        local function update(msg)
            connecting = false
            deferrals.update(tostring(msg) and tostring(msg) or "")
        end

        if not ids then
            -- prevent joining
            done(Config.Language.err)
            CancelEvent()
            Queue:DebugPrint("Dropped " .. name .. ", couldn't retrieve any of their id's")
            return
        end

        if Config.RequireSteam and not Queue:IsSteamRunning(src) then
            done(Config.Language.steam)
            CancelEvent()
            return
        end

        local banned

        Config.IsBanned(src, function(_banned, _reason)
            banned = _banned
            _reason = _reason and tostring(_reason) or ""

            if _banned then
                local msg = string_format(Config.Language.banned, tostring(_reason))
                done(msg)

                Queue:RemoveFromQueue(ids)
                Queue:RemoveFromConnecting(ids)
            end
        end)

        while banned == nil do Citizen.Wait(0) end
        if banned then CancelEvent() return end

        local reason = "You were kicked from joining the queue"

        local function setReason(msg)
            reason = tostring(msg)
        end

        TriggerEvent("queue:playerJoinQueue", src, setReason)

        if WasEventCanceled() then
            done(reason)

            Queue:RemoveFromQueue(ids)
            Queue:RemoveFromConnecting(ids)

            CancelEvent()
            return
        end

        if Config.PriorityOnly and not Queue:IsPriority(ids) then
			print("**player tried to connect who is NOT whitelisted!**")
			if Queue.PublicPlayerCount >= Queue.MaxPublicPlayerCount then
				print("all public slots full!")
				done(Config.Language.prio)
				return
			else
				print("***still " .. Queue.MaxPublicPlayerCount - Queue.PublicPlayerCount .. " public slots were available! letting non-whitelisted person join!***")
				Queue.PublicPlayerCount = Queue.PublicPlayerCount + 1
			end
		end

        local rejoined = false

        if Queue:IsInQueue(ids) then
            rejoined = true
            Queue:UpdatePosData(src, ids, deferrals)
            Queue:DebugPrint(string_format("%s[%s] has rejoined queue after cancelling", name, ids[1]))
			if not Queue:IsPriority(ids) then
				Queue.PublicPlayerCount = Queue.PublicPlayerCount - 1
				print("Decremented public player count after player rejoined, at: " .. Queue.PublicPlayerCount)
			end
        else
            Queue:AddToQueue(ids, connectTime, name, src, deferrals)
        end

        if Queue:IsInConnecting(ids, false, true) then
            Queue:RemoveFromConnecting(ids)

            if Queue:NotFull() then
                local added = Queue:AddToConnecting(ids, true, true, done)
                if not added then CancelEvent() return end

                done()

                return
            else
                Queue:AddToQueue(ids, connectTime, name, src, deferrals)
                Queue:SetPos(ids, 1)
            end
        end

        local pos, data = Queue:IsInQueue(ids, true)

        if not pos or not data then
            done(Config.Language._err .. "[3]")

            RemoveFromQueue(ids)
            RemoveFromConnecting(ids)

            -- experimental: added by minipunch to test fixing broken player count staying too high
            if not Queue:IsPriority(ids) then
              Queue.PublicPlayerCount = Queue.PublicPlayerCount - 1
            end

            CancelEvent()
            return
        end

        if Queue:NotFull(true) then
            -- let them in the server
            local added = Queue:AddToConnecting(ids, true, true, done)
            if not added then CancelEvent() return end

            done()
            Queue:DebugPrint(name .. "[" .. ids[1] .. "] is loading into the server")

            return
        end

        update(string_format(Config.Language.pos, pos, Queue:GetSize()))

        Citizen.CreateThread(function()
            if rejoined then return end

            Queue.ThreadCount = Queue.ThreadCount + 1
            local dotCount = 0

            while true do
                Citizen.Wait(1000)

                local dots = ""

                dotCount = dotCount + 1
                if dotCount > 3 then dotCount = 0 end

                -- hopefully people will notice this and realize they don't have to keep reconnecting...
                for i = 1 , dotCount do dots = dots .. "." end

                local pos, data = Queue:IsInQueue(ids, true)

                -- will return false if not in queue; timed out?
                if not pos or not data then
                    if data and data.deferrals then data.deferrals.done(Config.Language._err) end
                    CancelEvent()
                    Queue:RemoveFromQueue(ids)
                    Queue:RemoveFromConnecting(ids)
                    Queue.ThreadCount = Queue.ThreadCount - 1
                    -- experimental: added by minipunch to test fixing broken player count staying too high
                    if not Queue:IsPriority(ids) then
                      Queue.PublicPlayerCount = Queue.PublicPlayerCount - 1
                    end
                    return
                end

                if pos <= 1 and Queue:NotFull() then
                    -- let them in the server
                    local added = Queue:AddToConnecting(ids)

                    data.deferrals.update(Config.Language.joining)
                    Citizen.Wait(500)

                    if not added then
                        data.deferrals.done(Config.Language.connectingerr)
                        CancelEvent()
                        Queue.ThreadCount = Queue.ThreadCount - 1
                        -- maybe dec pub player count here too?
                        return
                    end

                    data.deferrals.done()

                    Queue:RemoveFromQueue(ids)
                    Queue.ThreadCount = Queue.ThreadCount - 1
                    Queue:DebugPrint(name .. "[" .. ids[1] .. "] is loading into the server")

                    return
                end

                -- send status update
                local msg = string_format(Config.Language.pos .. "%s", pos, Queue:GetSize(), dots)
                data.deferrals.update(msg)
            end
        end)
    end

    AddEventHandler("playerConnecting", playerConnect)

    local function checkTimeOuts()
        local i = 1

        while i <= Queue:GetSize() do
            local data = Queue.QueueList[i]
            local lastMsg = GetPlayerLastMsg(data.source)

            if lastMsg == 0 or lastMsg >= 30000 then
                data.timeout = data.timeout + 1
            else
                data.timeout = 0
            end

            -- check just incase there is invalid data
            if not data.ids or not data.name or not data.firstconnect or data.priority == nil or not data.source then
                data.deferrals.done(Config.Language._err .. "[1]")
                table_remove(Queue.QueueList, i)
                Queue:DebugPrint(tostring(data.name) .. "[" .. tostring(data.ids[1]) .. "] was removed from the queue because it had invalid data")
				if not Queue:IsPriority(data.ids) then
					print("**Decrementing public player count!**")
					Queue.PublicPlayerCount = Queue.PublicPlayerCount - 1
				end
            elseif (data.timeout >= 120) and data.source ~= "debug" and os_time() - data.firstconnect > 5 then
                -- remove by source incase they rejoined and were duped in the queue somehow
                data.deferrals.done(Config.Language._err .. "[2]")
                Queue:RemoveFromQueue(data.source, true)
                Queue:RemoveFromConnecting(data.source, true)
                Queue:DebugPrint(data.name .. "[" .. data.ids[1] .. "] was removed from the queue because they timed out")
				if not Queue:IsPriority(data.ids) then
					print("**Decrementing public player count!**")
					Queue.PublicPlayerCount = Queue.PublicPlayerCount - 1
				end
            else
                i = i + 1
            end
        end

        i = 1

        while i <= Queue:ConnectingSize() do
            local data = Queue.Connecting[i]

            local lastMsg = GetPlayerLastMsg(data.source)

            data.timeout = data.timeout + 1

            if ((data.timeout >= 300 and lastMsg >= 35000) or data.timeout >= 340) and data.source ~= "debug" and os_time() - data.firstconnect > 5 then
                Queue:RemoveFromQueue(data.source, true)
                Queue:RemoveFromConnecting(data.source, true)
                Queue:DebugPrint(data.name .. "[" .. data.ids[1] .. "] was removed from the connecting queue because they timed out")
				if not Queue:IsPriority(data.ids) then
					print("**Decrementing public player count!**")
					Queue.PublicPlayerCount = Queue.PublicPlayerCount - 1
				end
            else
                i = i + 1
            end
        end

        local qCount = Queue:GetSize()

        -- show queue count in server name
        if displayQueue and initHostName then SetConvar("sv_hostname", (qCount > 0 and "[" .. tostring(qCount) .. "] " or "") .. initHostName) end

        SetTimeout(1000, checkTimeOuts)
    end

    checkTimeOuts()
end)

local function playerActivated()
    local src = source
    local ids = Queue:GetIds(src)

    if not Queue.PlayerList[src] then
        Queue.PlayerCount = Queue.PlayerCount + 1
        Queue.PlayerList[src] = true
        Queue:RemoveFromQueue(ids)
        Queue:RemoveFromConnecting(ids)
    end
end

RegisterServerEvent("Queue:addPlayerToPriorityList")
AddEventHandler("Queue:addPlayerToPriorityList", function(player)
    Queue.Priority[string_lower(player.steamIdentifier)] = player.priorityLevel
    print("player " .. player.name .. " was added to the server priority list!")
    print("ident: " .. player.steamIdentifier)
    print("level: " .. player.priorityLevel)
end)

RegisterServerEvent("Queue:playerActivated")
AddEventHandler("Queue:playerActivated", playerActivated)

local function playerDropped()
    local src = source
    local ids = Queue:GetIds(src)

    if Queue.PlayerList[src] then
        Queue.PlayerCount = Queue.PlayerCount - 1
        Queue.PlayerList[src] = nil
        Queue:RemoveFromQueue(ids)
        Queue:RemoveFromConnecting(ids)
		if not Queue:IsPriority(ids) then
			print("**Decrementing public player count!**")
			Queue.PublicPlayerCount = Queue.PublicPlayerCount - 1
		end
    end
end

AddEventHandler("playerDropped", playerDropped)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if exports and exports.connectqueue then TriggerEvent("queue:onReady") return end
    end
end)

-- debugging / testing commands
local testAdds = 0

function fetchWhitelistFromDb()
	print("fetching all whitelisted players from DB...")
	PerformHttpRequest("http://127.0.0.1:5984/whitelist/_all_docs?include_docs=true", function(err, text, headers)
		print("finished getting whitelisted players...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			Queue.Priority = {} -- reset table
			print("#(response.rows) = " .. #(response.rows))
			-- insert all bans from 'bans' db into lua table
			for i = 1, #(response.rows) do
                if response.rows[i] then
                    local playerDoc = response.rows[i].doc
                    if playerDoc.steam and playerDoc.priority then
                        Queue.Priority[playerDoc.steam] = playerDoc.priority
                    end
                end
			end
			print("finished loading whitelisted players table...")
			print("# of WL players: " .. #(response.rows))
		end
	end, "GET", "", { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

-- PERFORM FIRST TIME DB CHECK--
exports["globals"]:PerformDBCheck("connectqueue whitelist", "whitelist", fetchWhitelistFromDb)

AddEventHandler("rconCommand", function(command, args)
  --[[
  This command is for admins to use to add, remove, and update people's priority in the queue
  USAGE:
  prioritize [steam-id] [level] [name] (insert/update record)
  OR
  prioritize [steam-id] false (remove record)
  ]]
  if command == "settotalcount" then
    local total = tonumber(args[1])
    if total then
      Queue.PlayerCount = total
    end
  elseif command == "setpubliccount" then
      local count = tonumber(args[1])
      if count then
        Queue.PublicPlayerCount = count
      end
  elseif command == "prioritize" then
    local player = {}
    local streamIdentifier, priorityLevel, name
    if #args < 2 then -- incorrect usage
      RconPrint("Usage: prioritize [steam-id] [level] [name] to update or insert a member\n")
      RconPrint("Example:\n")
      RconPrint("prioritize STEAM_0:1:####### 1 Jonny Whitelisted Cash\n")
      RconPrint("Or\n")
      RconPrint("prioritize steam:110000###### 50 Impotent Kubane\n")
      RconPrint("\nTo remove a member: ")
      RconPrint("\nprioritize [steam-identifier] false")
      CancelEvent()
      return
    elseif #args < 3 then -- no name, must be remove priority command
      steamIdentifier = args[1]
      priorityLevel = string.lower(args[2])
      -- See if user typed "false" for priority level
      if priorityLevel == "false" then
        RconPrint("\nRemoving " .. steamIdentifier .. " from the priority list!")
        -- See if a user with that steam identifier exists in the prority list
        if Queue.Priority[steamIdentifier] then
          -- Remove from lua dictionary
          RconPrint("\nFound user with that identifier!\nRemoving from dictionary...")
          Queue.Priority[steamIdentifier] = nil
          -- Remove from database
          RconPrint("\nRemoving from database...")
          TriggerEvent('es:exposeDBFunctions', function(db)
            RconPrint("\nRetrieving document...")
            -- Get the document based on that steam identifier
            db.getDocumentByRow("whitelist", "steam", steamIdentifier, function(doc, rText)
              RconPrint("\nFinished retrieving.")
              if rText then
                -- something went wrong?
                RconPrint("\nrText = " .. rText)
              end
              if doc then
                -- doc existed, remove it...
                RconPrint("\nRemoving document...")
                PerformHttpRequest("http://127.0.0.1:5984/whitelist/"..doc._id.."?rev="..doc._rev, function(err, rText, headers)
                  RconPrint("\nFinished removing.")
                  if err == 0 then
                    RconPrint("\nrText = " .. rText)
                    RconPrint("\nerr = " .. err)
                  end
                end, "DELETE", "", { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
              end
            end)
          end)
        end
      end
    else -- label/name was included, must be adding or modifying
      steamIdentifier = string.lower(args[1])
      priorityLevel = args[2]
      table.remove(args,1)
      table.remove(args,1)
      name = table.concat(args, " ")
      RconPrint("\nAdding player " .. name .. " to the priority list!")
      -- Check for valid input
      if type(steamIdentifier) == "string" and type(tonumber(priorityLevel)) == "number" then
        print("steam ident was string and priority level was number")
        local whitelist_member = Queue.Priority[steamIdentifier]
        if whitelist_member then
          RconPrint("\nPlayer with that identifier already exists!")
          -- That identifier was associated with someone already prioritized, just modify it.
          Queue.Priority[steamIdentifier] = priorityLevel
          -- Also update the DB
          TriggerEvent('es:exposeDBFunctions', function(db)
            -- Get the document based on that steam identifier
            db.getDocumentByRow("whitelist", "steam", steamIdentifier, function(doc, rText)
              if rText then
                RconPrint("\nrText = " .. rText)
              end
              if doc then
                db.updateDocument("whitelist", doc._id, {name = name, priority = priorityLevel}, function(status)
                  if status == true then
                    RconPrint("\nDocument updated.")
                  else
                    RconPrint("\nStatus Response: " .. status)
                    if status == "201" then
                      RconPrint("\nDocument successfully updated!")
                    end
                  end
                end)
              end
            end)
          end)
        else
          -- Player did not exist previously, need to add
          Queue.Priority[steamIdentifier] = priorityLevel
          -- Create document in database.
          TriggerEvent('es:exposeDBFunctions', function(db)
            db.createDocument("whitelist",  {name = name, steam = steamIdentifier, priority = priorityLevel, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
              RconPrint("\nPlayer " .. name .. " added to whitelist!")
            end)
          end)
        end
      else
        print("invalid input!")
      end
    end
    CancelEvent()
    -- adds a fake player to the queue for debugging purposes, this will freeze the queue
  elseif command == "addq" then
    print("==ADDED FAKE QUEUE==")
    Queue:AddToQueue({"steam:110000103fd1bb1"..testAdds}, os_time(), "Fake Player", "debug")
    testAdds = testAdds + 1
    CancelEvent()

    -- removes targeted id from the queue
  elseif command == "removeq" then
    if not args[1] then return end
    print("REMOVED " .. Queue.QueueList[tonumber(args[1])].name .. " FROM THE QUEUE")
    table_remove(Queue.QueueList, args[1])
    CancelEvent()

    -- print the current queue list
  elseif command == "printq" then
    print("==CURRENT QUEUE LIST==")
    for k,v in ipairs(Queue.QueueList) do
      print(k .. ": [src: " .. v.source .. "] " .. v.name .. "[" .. v.ids[1] .. "] | Priority: " .. (tostring(v.priority and true or false)) .. " | Last Msg: " .. (v.source ~= "debug" and GetPlayerLastMsg(v.source) or "debug") .. " | Timeout: " .. v.timeout)
    end
    CancelEvent()

    -- adds a fake player to the connecting list
  elseif command == "addc" then
    print("==ADDED FAKE CONNECTING QUEUE==")
    Queue:AddToConnecting({"debug"})
    CancelEvent()

    -- removes a player from the connecting list
  elseif command == "removec" then
    print("==REMOVED FAKE CONNECTING QUEUE==")
    if not args[1] then return end
    table_remove(Queue.Connecting, args[1])
    CancelEvent()

    -- prints a list of players that are connecting
  elseif command == "printc" then
    print("==CURRENT CONNECTING LIST==")
    for k,v in ipairs(Queue.Connecting) do
      print(k .. ": [src: " .. v.source .. "] " .. v.name .. "[" .. v.ids[1] .. "] | Priority: " .. (tostring(v.priority and true or false)) .. " | Last Msg: " .. (v.source ~= "debug" and GetPlayerLastMsg(v.source) or "debug") .. " | Timeout: " .. v.timeout)
    end
    CancelEvent()

    -- prints a list of activated players
  elseif command == "printl" then
    for k,v in pairs(Queue.PlayerList) do
      print(k .. ": " .. tostring(v))
    end
    CancelEvent()

    -- prints a list of priority id's
  elseif command == "printp" then
    print("==CURRENT PRIORITY LIST==")
    for k,v in pairs(Queue.Priority) do
      print(k .. ": " .. tostring(v))
    end
    CancelEvent()

  elseif command == "printplist" then
    print("Player List:")
    for i = 1, #Queue.PlayerList do
      print(i .. ": " .. tostring(Queue.PlayerList[i]))
    end
    -- prints the current player count
  elseif command == "printcount" then
    print("Total Player Count: " .. Queue.PlayerCount .. " ")
    CancelEvent()

  elseif command == "printt" then
    print("Thread Count: " .. Queue.ThreadCount)
    CancelEvent()
  end
end)

-- prevent duplicating queue count in server name
AddEventHandler("onResourceStop", function(resource)
    if displayQueue and resource == GetCurrentResourceName() then SetConvar("sv_hostname", initHostName) end
end)

--[[

AddEventHandler("queue:playerJoinQueue", function(src, setKickReason)
    setKickReason("No, you can't join")
    CancelEvent()
end)

exports.connectqueue:AddPriority("steam:110000#####", 50)
exports.connectqueue:AddPriority("ip:127.0.0.1", 50)
exports.connectqueue:AddPriority("STEAM_0:1:########", 50)

local prioritize = {
    ["STEAM_0:1:########"] = 10,
    ["ip:127.0.0.1"] = 20,
    ["steam:110000#####"] = 100
}
exports.connectqueue:AddPriority(prioritize)

exports.connectqueue:RemovePriority("STEAM_0:1:########")

set sv_debugqueue true
set sv_displayqueue true

 ]]
