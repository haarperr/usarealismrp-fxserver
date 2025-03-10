------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
----                                                    ----
---- Resource: tokovoip_script                          ----
----                                                    ----
---- File: s_utils.lua                                  ----
------------------------------------------------------------
------------------------------------------------------------

--------------------------------------------------------------------------------
--	Server_utils: Data system functions
--------------------------------------------------------------------------------

local playersData = {};

function setPlayerData(playerServerId, key, data, shared)
	if (shared) then
		if (not playersData[playerServerId]) then
			playersData[playerServerId] = {};
		end
		playersData[playerServerId][key] = data;
		TriggerClientEvent("Tokovoip:setPlayerData", -1, playerServerId, key, data);
	else
		TriggerClientEvent("Tokovoip:setPlayerData", playerServerId, playerServerId, key, data);
	end
end
RegisterServerEvent("Tokovoip:setPlayerData");
AddEventHandler("Tokovoip:setPlayerData", setPlayerData);

function refreshAllPlayerData(toEveryone)
	if (toEveryone) then
		TriggerClientEvent("Tokovoip:doRefreshAllPlayerData", -1, playersData);
	else
		TriggerClientEvent("Tokovoip:doRefreshAllPlayerData", source, playersData);
	end
end
RegisterServerEvent("Tokovoip:refreshAllPlayerData");
AddEventHandler("Tokovoip:refreshAllPlayerData", refreshAllPlayerData);

AddEventHandler("playerDropped", function()
	playersData[source] = nil;
	refreshAllPlayerData(true);
end);

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
