ESX = nil

local isOnDuty = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_compolice:onDuty')
AddEventHandler('esx_compolice:onDuty', function(_source, isOnDuty)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
        if xPlayer.getJob().name == 'compolice' then
            xPlayer.addWeapon('WEAPON_STUNGUN', 1)
            xPlayer.addWeapon('WEAPON_FLASHLIGHT', 1)
            xPlayer.addWeapon('WEAPON_NIGHTSTICK', 1)
            xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)

            xPlayer.addWeaponComponent('WEAPON_COMBATPISTOL', 'flashlight')

            if Config.UseMarker then
                TriggerClientEvent('esx_compolice:spawnVehicle', _source)
                isOnDuty = true
                
            else 
                TriggerClientEvent('esx_compolice:localSpawnVeh', _source)
                isOnDuty = true
            end
        elseif xPlayer.getJob().name == 'offcompolice' then
            xPlayer.setJob('compolice', 0)

            xPlayer.addWeapon('WEAPON_STUNGUN', 1)
            xPlayer.addWeapon('WEAPON_FLASHLIGHT', 1)
            xPlayer.addWeapon('WEAPON_NIGHTSTICK', 1)
            xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)

            xPlayer.addWeaponComponent('WEAPON_COMBATPISTOL', 'flashlight')

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
            xPlayer.removeWeapon('WEAPON_STUNGUN')
            xPlayer.removeWeapon('WEAPON_FLASHLIGHT')
            xPlayer.removeWeapon('WEAPON_NIGHTSTICK')
            xPlayer.removeWeapon('WEAPON_COMBATPISTOL')

            TriggerClientEvent('esx_compolice:removeVehicle', _source)
            isOnDuty = false

            xPlayer.setJob('offcompolice', 0)
        else 
            xPlayer.showNotification(_U('invalid_job'), false, true, 70)
        end
end)
