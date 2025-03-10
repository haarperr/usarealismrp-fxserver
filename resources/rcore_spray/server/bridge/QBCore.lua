if Framework.QBCORE then
    QBCore = {}
    ESX = {}

    TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

    ESX.RegisterUsableItem = function(itemName, callBack)
        QBCore.Functions.CreateUseableItem(itemName, callBack)
    end

    ESX.GetPlayerFromId = function(source)
        local xPlayer = {}
        local qbPlayer = QBCore.Functions.GetPlayer(source)

        ---------
        xPlayer.removeInventoryItem = function(itemName, count)
            qbPlayer.Functions.RemoveItem(itemName, count)
        end
        ---------
        xPlayer.getInventoryItem = function(itemName)
            local item = qbPlayer.Functions.GetItemByName(itemName) or {}

            local ItemInfo =  {
                name = itemName,
                count = item.amount or 0,
                label = item.label or "none",
                weight = item.weight or 0,
                usable = item.useable or false,
                rare = false,
                canRemove = false,
            }
            return ItemInfo
        end
        ---------

        return xPlayer
    end
end