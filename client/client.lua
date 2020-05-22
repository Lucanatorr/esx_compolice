ESX = nil

local currentTask = {}
local isOnDuty, isDead, hasAlreadyJoined, isHandcuffed = false, false, false, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	isDead = false
	TriggerEvent('esx_policejob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

if Config.UseMapBlip then
    Citizen.CreateThread(function()
		local blip = AddBlipForCoord(Config.OnDutyMarkerLocation.x, Config.OnDutyMarkerLocation.y, Config.OnDutyMarkerLocation.z)

		SetBlipSprite (blip, Config.BlipType.Blip.Sprite)
		SetBlipDisplay(blip, Config.BlipType.Blip.Display)
		SetBlipScale  (blip, Config.BlipType.Blip.Scale)
		SetBlipColour (blip, Config.BlipType.Blip.Color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('map2_blip'))
		EndTextCommandSetBlipName(blip)
    end)
end

Citizen.CreateThread(function()
    while isOnDuty do
        Citizen.Wait(0)

        TriggerEvent('esx_policejob:updateBlip')
    end
end)


if Config.UseCommand and not Config.UseMarker then
    RegisterCommand(Config.OnDutyCommand, function(source, args, rawCommand) -- change the name of the command in the config.lua
        TriggerServerEvent('esx_compolice:onDuty')
        isOnDuty = true
    end)

    RegisterCommand(Config.OffDutyCommand, function(source, args, rawCommand) -- change the name of the command in the config.lua
        TriggerServerEvent('esx_compolice:offDuty')
        isOnDuty = false
    end)
end


Citizen.CreateThread(function()
    while Config.UseMarker == true do
        Citizen.Wait(0)
        local player = GetPlayerPed(-1)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local blip = GetBlipFromEntity(playerPed)

        if not isOnDuty and GetDistanceBetweenCoords(coords, Config.OnDutyMarkerLocation.x, Config.OnDutyMarkerLocation.y, Config.OnDutyMarkerLocation.z, true) <= Config.DrawDistance2 then
            DrawMarker(Config.MarkerType, Config.OnDutyMarkerLocation.x, Config.OnDutyMarkerLocation.y, Config.OnDutyMarkerLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)

            if GetDistanceBetweenCoords(coords, Config.OnDutyMarkerLocation.x, Config.OnDutyMarkerLocation.y, Config.OnDutyMarkerLocation.z, true) <= 2.0 then
                ESX.ShowHelpNotification(_U('go_on_duty'))
                if IsControlJustReleased(0, 38) then
                    Citizen.Wait(50)
                    
                    TriggerServerEvent('esx_compolice:onDuty', isOnDuty)
                end
            end

        elseif GetDistanceBetweenCoords(coords, Config.RemoveMarker.x, Config.RemoveMarker.y, Config.RemoveMarker.z, true) <= Config.DrawDistance2 and IsPedInAnyVehicle(player, false) then
            DrawMarker(36, Config.RemoveMarker.x, Config.RemoveMarker.y, Config.RemoveMarker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 5.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)

            if GetDistanceBetweenCoords(coords, Config.RemoveMarker.x, Config.RemoveMarker.y, Config.RemoveMarker.z, true) <= 3.0 then
                ESX.ShowHelpNotification(_U('go_off_duty'))
                if IsControlJustReleased(0, 38) then
                    Citizen.Wait(50)
                    
                    isOnDuty = false
                    TriggerServerEvent('esx_compolice:offDuty', isOnDuty)
                end
            end

        elseif isOnDuty and GetDistanceBetweenCoords(coords, Config.RetrievalMarker.x, Config.RetrievalMarker.y, Config.RetrievalMarker.z, true) <= Config.DrawDistance then -----If you walk back up to the main marker, you can retrieve your vehicle if its lost/stolen-----
            DrawMarker(Config.MarkerType, Config.RetrievalMarker.x, Config.RetrievalMarker.y, Config.RetrievalMarker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
            
            if GetDistanceBetweenCoords(coords, Config.RetrievalMarker.x, Config.RetrievalMarker.y, Config.RetrievalMarker.z, true) <= 2.0 then
                ESX.ShowHelpNotification(_U('get_vehicle'))
                if IsControlJustReleased(0, 38) then
                    Citizen.Wait(50)

                    TriggerEvent('esx_compolice:spawnVehicle')
                end
            end
        end

        if isOnDuty and GetDistanceBetweenCoords(coords, Config.OffDutyMarkerLocation.x, Config.OffDutyMarkerLocation.y, Config.OffDutyMarkerLocation.z, true) <= Config.DrawDistance then
            DrawMarker(Config.MarkerType, Config.OffDutyMarkerLocation.x, Config.OffDutyMarkerLocation.y, Config.OffDutyMarkerLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)

            if GetDistanceBetweenCoords(coords, Config.OffDutyMarkerLocation.x, Config.OffDutyMarkerLocation.y, Config.OffDutyMarkerLocation.z, true) <= 2.0 then
                ESX.ShowHelpNotification(_U('foot_off_duty'))
                if IsControlJustReleased(0, 38) then
                    Citizen.Wait(50)
                    
                    isOnDuty = false
                    TriggerServerEvent('esx_compolice:offDuty', isOnDuty)
                end
            end
        end
    end
end)

RegisterNetEvent('esx_compolice:spawnVehicle')
AddEventHandler('esx_compolice:spawnVehicle', function()
    local model = Config.VehicleModel

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        if model ~= nil then
            TriggerEvent("mythic_progressbar:client:progress", {
                name = "getting_vehicle",
                duration = 4500,
                label = _U('getting_vehicle'),
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "missheistdockssetup1clipboard@base",
                    anim = "base",
                },
                prop = {
                    model = "p_amb_clipboard_01",
                    bone = 18905,
                },
                propTwo = {
                    model = "prop_pencil_01",
                    bone = 58866,
                }
        
            }, function(status)
            end)

            Citizen.Wait(4550)

            ESX.Game.SpawnVehicle(model, {
                x = Config.SpawnLocation.x,
                y = Config.SpawnLocation.y,
                z = Config.SpawnLocation.z + 1											
                },Config.SpawnLocation.heading, function(vehicle)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
            ESX.ShowNotification(_U('now_on_duty'), false, true, 70)

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
            end)
            
            isOnDuty = true

            SetPedArmour(GetPlayerPed(-1), 100)
        else
            ESX.ShowNotification(_U('invalid_model'), false, true, 70)
        end
    else
        ESX.ShowNotification(_U('in_vehicle_error'), false, true, 70)
    end
end)

RegisterNetEvent('esx_compolice:localSpawnVeh')
AddEventHandler('esx_compolice:localSpawnVeh', function()
    local model = Config.VehicleModel
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(PlayerPedId())

    if not Config.UseMarker and not IsPedInAnyVehicle(ped, false) then
        if model ~= nil then
            TriggerEvent("mythic_progressbar:client:progress", {
                name = "getting_vehicle",
                duration = 4500,
                label = _U('getting_vehicle'),
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
        
            }, function(status)
            end)

            Citizen.Wait(4550)

            ESX.Game.SpawnVehicle(model, {
                x = coords.x,
                y = coords.y,
                z = coords.z + 1											
                },Config.SpawnLocation.heading, function(vehicle)

                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
            ESX.ShowNotification(_U('now_on_duty'), false, true, 70)

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
            end)
            
            isOnDuty = true

            SetPedArmour(GetPlayerPed(-1), 100)
        else 
            ESX.ShowNotification(_U('invalid_model'), false, true, 70)
        end
    else
        ESX.ShowNotification(_U('in_vehicle_error'), false, true, 70)
    end
end)


RegisterNetEvent('esx_compolice:removeVehicle')
AddEventHandler('esx_compolice:removeVehicle', function()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local coords = GetEntityCoords(PlayerPedId())

    if IsPedInAnyVehicle(ped, false) then
        TriggerEvent("mythic_progressbar:client:progress", {
            name = "storing_vehicle",
            duration = 3500,
            label = _U('storing_vehicle'),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
    
        }, function(status)
        end)

        Citizen.Wait(3500)

        ESX.Game.DeleteVehicle(vehicle)

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)

        ESX.ShowNotification(_U('now_off_duty'), false, true, 70)
        isOnDuty = false

        SetPedArmour(GetPlayerPed(-1), 0)
    else
        TriggerEvent("mythic_progressbar:client:progress", {
            name = "going_off_duty",
            duration = 4500,
            label = _U('going_off_duty'),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "missheistdockssetup1clipboard@base",
                anim = "base",
            },
            prop = {
                model = "p_amb_clipboard_01",
                bone = 18905,
            },
            propTwo = {
                model = "prop_pencil_01",
                bone = 58866,
            }
    
        }, function(status)
        end)

        Citizen.Wait(4550)

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)

        ESX.ShowNotification(_U('now_off_duty2'), false, true, 70)
        isOnDuty = false

        SetPedArmour(GetPlayerPed(-1), 0)
    end
end)


------Job Menu------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local isPressed = IsControlJustReleased(0, 167)

        if isPressed and isOnDuty and not isDead and not isHandcuffed and ESX.PlayerData.job and ESX.PlayerData.job.name == 'compolice' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
            OpenPoliceActionsMenu()
        elseif isPressed and not isOnDuty and ESX.PlayerData.job.name == 'compolice' or isPressed and not isOnDuty and ESX.PlayerData.job.name == 'offcompolice' then
            ESX.ShowNotification(_U('cannot_preform'), false, true, 70)
        elseif isPressed and ESX.PlayerData.job.name ~= 'compolice' or isPressed and ESX.PlayerData.job.name ~= 'offcompolice' then
            ESX.ShowNotification(_U('invalid_job'), false, true, 70)
        end
    end
end)



function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
		title    = 'Community Police',
		align    = 'right',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
            {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
            {label = _U('request_backup'), value = 'request_backup'},
			{label = "Scene Menu", value = 'scene_menu'},
	}}, function(data, menu)
		if data.current.value == 'scene_menu' then
			ExecuteCommand('scenemenu')
			menu.close()
		elseif data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('id_card'), value = 'identity_card'},
				{label = _U('search'), value = 'search'},
				{label = _U('handcuff'), value = 'handcuff'},
				{label = _U('drag'), value = 'drag'},
				{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
				{label = _U('unpaid_bills'), value = 'unpaid_bills'},
				{label = _U('gsr_test'), value = 'gsr_test'},
				{label = _U('revive_player'), value = 'revive'}
			}


			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'right',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						exports['esx_policejob']:OpenIdentityCardMenu(closestPlayer)
					elseif action == 'search' then
						exports['esx_policejob']:OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'license' then
						exports['esx_policejob']:ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						exports['esx_policejob']:OpenUnpaidBillsMenu(closestPlayer)
					elseif action == 'gsr_test' then
						TriggerServerEvent('esx_gsr:Check', GetPlayerServerId(closestPlayer))
					elseif action == 'unpaid_bills' then
						exports['esx_policejob']:OpenUnpaidBillsMenu(closestPlayer)
						
						--revive start
						elseif action == 'revive' then
						IsBusy = true
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								if IsPedDeadOrDying(closestPlayerPed, 1) then
									local playerPed = PlayerPedId()
									exports['mythic_notify']:SendAlert('inform', _U('revive_inprogress'), 5000)
									local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
									for i=1, 15, 1 do
										Citizen.Wait(900)
								
										ESX.Streaming.RequestAnimDict(lib, function()
											TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
										end)
									end

									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))

									-- Show revive award?
									if Config.ReviveReward > 0 then
										exports['mythic_notify']:SendAlert('inform', _U('revive_complete_award', GetPlayerName(closestPlayer), Config.ReviveReward), 5000)
									else
										exports['mythic_notify']:SendAlert('success', _U('revive_complete'), 5000)
									end
								else
									exports['mythic_notify']:SendAlert('error', _U('player_not_unconscious'), 5000)
								end
							else
								exports['mythic_notify']:SendAlert('error', _U('not_enough_medikit'), 5000)
							end

							IsBusy = false

						end, 'medikit')
					end
				else
					exports['mythic_notify']:SendAlert('error', _U('no_players_nearby'), 5000)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'), value = 'impound'})
			end

			table.insert(elements, {label = _U('search_database'), value = 'search_database'})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = _U('vehicle_interaction'),
				align    = 'right',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					exports['esx_policejob']:LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						exports['esx_policejob']:OpenVehicleInfosMenu(vehicleData)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							exports['mythic_notify']:SendAlert('inform', _U('vehicle_unlocked'), 5000)
						end
					elseif action == 'impound' then
						-- is the script busy?
						if currentTask.busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						currentTask.task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							exports['esx_policejob']:ImpoundVehicle(vehicle)
							Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
						end)

						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while currentTask.busy do
								Citizen.Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
									exports['mythic_notify']:SendAlert('error', _U('impound_canceled_moved'), 5000)
									ESX.ClearTimeout(currentTask.task)
									ClearPedTasks(playerPed)
									currentTask.busy = false
									break
								end
							end
						end)
					end
				else
					exports['mythic_notify']:SendAlert('error', _U('no_vehicles_nearby'), 5000)
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('traffic_interaction'),
				align    = 'right',
				elements = {
					{label = _U('cone'), model = 'prop_roadcone02a'},
					{label = _U('barrier'), model = 'prop_barrier_work05'},
					{label = _U('spikestrips'), model = 'p_ld_stinger_s'},
					{label = _U('box'), model = 'prop_boxpile_07d'},
					{label = _U('cash'), model = 'hei_prop_cash_crate_half_full'}
			}}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
				local objectCoords = (coords + forward * 1.0)

				ESX.Game.SpawnObject(data2.current.model, objectCoords, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
            end)
        elseif data.current.value == 'request_backup' then
            local playerPed = PlayerPedId()
	        local PedPosition = GetEntityCoords(playerPed)
            local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

            TriggerServerEvent('esx_addons_gcphone:startCall', 'police', _U('send_message'), PlayerCoords, {
                PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
                })
                ESX.ShowNotification(_U('message_sent'), false, true, 70)
        end
	end, function(data, menu)
		menu.close()
	end)
end
