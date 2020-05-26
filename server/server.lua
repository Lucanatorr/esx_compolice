ESX = nil

local isOnDuty = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getLoadout()
    for k, v in pairs(Config.LoadoutItems) do
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        local itemName = v.item
        local count = v.count

        if xPlayer.canCarryItem(itemName, count) then
            xPlayer.addInventoryItem(itemName, count)
        end
    end 

    for k, v in pairs(Config.LoadoutWeapons) do
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        local weapon = v.weapon
        local ammo = v.ammo
        local component = v.component

        xPlayer.addWeapon(weapon, ammo)

        if component ~= nil then
            xPlayer.addWeaponComponent(weapon, component)
        end
    end
end

function removeLoadout()
    for k, v in pairs(Config.LoadoutItems) do
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        local itemName = v.item
        local count = v.count

        xPlayer.removeInventoryItem(itemName, count)

    end 

    for k, v in pairs(Config.LoadoutWeapons) do
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        local weapon = v.weapon
        local ammo = v.ammo
        local component = v.component

        xPlayer.removeWeapon(weapon, ammo)
    end
end



RegisterServerEvent('esx_compolice:onDuty')
AddEventHandler('esx_compolice:onDuty', function(_source, isOnDuty)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
        if xPlayer.getJob().name == 'compolice' then
            getLoadout()

            if Config.UseMarker then
                TriggerClientEvent('esx_compolice:spawnVehicle', _source)
                isOnDuty = true
                
            else 
                TriggerClientEvent('esx_compolice:localSpawnVeh', _source)
                isOnDuty = true
            end
        elseif xPlayer.getJob().name == 'offcompolice' then
            xPlayer.setJob('compolice', 0)

            getLoadout()

            if Config.UseMarker then
                TriggerClientEvent('esx_compolice:spawnVehicle', _source)
                isOnDuty = true
                
            else 
                TriggerClientEvent('esx_compolice:localSpawnVeh', _source)
                isOnDuty = true
            end
        else 
            xPlayer.showNotification(_U('invalid_job'), false, true, 70)
        end
end)

RegisterServerEvent('esx_compolice:offDuty')
AddEventHandler('esx_compolice:offDuty', function(_source, isOnDuty)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
        if xPlayer.getJob().name == 'compolice' then
            xPlayer.setJob('offcompolice', 0)
            
            removeLoadout()

            TriggerClientEvent('esx_compolice:removeVehicle', _source)
            isOnDuty = false

        else 
            xPlayer.showNotification(_U('invalid_job'), false, true, 70)
        end
end)
