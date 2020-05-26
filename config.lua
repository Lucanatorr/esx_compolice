Config = {} -- Don't touch plz
Config.Locale = 'en' -- locale language, translate your own and place it in 'esx_compolice/locales'

Config.UsePlayerBlips = true -- set to 'true' if you want shared blips between compolice and police
Config.UseMapBlip = true -- Adds a blip on the map for everyone to see
Config.BlipType = {
    Blip = { -- all values can be found here: https://docs.fivem.net/docs/game-references/
		Sprite  = 60,
		Display = 4,
		Scale   = 1.2,
		Color  = 0
	}
}

Config.LoadoutItems = { -- the inventory items you want to give
	{ item = "medikit", count = 5},
}

Config.LoadoutWeapons = { -- The weapons you want to give, component names can be found here: @es_extended/config.weapons
	{ weapon = "WEAPON_STUNGUN", ammo = 1, component = nil},
	--{ weapon = "WEAPON_COMBATPISTOL", ammo = 200, component = 'flashlight'},
	{ weapon = "WEAPON_FLASHLIGHT", ammo = 1, component = nil},
	{ weapon = "WEAPON_NIGHTSTICK", ammo = 1, component = nil},
	{ weapon = "WEAPON_PUMPSHOTGUN", ammo = 200, component = nil},
	{ weapon = "WEAPON_FIREEXTINGUISHER", ammo = 1000, component = nil},
	
}

Config.UseCommand = false -- Register a command instead of a marker?
Config.OnDutyCommand = 'onduty' -- Change command for onDuty
Config.OffDutyCommand = 'offduty' -- Change command for offDuty 

Config.UseMarker = true -- if not using UseCommand, set to true

Config.DrawDistance = 15 -- coords until you see the main marker.
Config.DrawDistance2 = 50 -- coords until you see the vehicle removal marker (if markers unabled)
Config.MarkerType = 27   -- Change to -1 to disable marker.
Config.MarkerColor = { r = 16, g = 113, b = 204 } -- color of the marker used

Config.OnDutyMarkerLocation = { x = -560.81, y = -133.9, z = 37.16 } -- location of the on-duty marker display. Default is PD Headquarters downtown
Config.OffDutyMarkerLocation = { x = -565.94, y = -134.5, z = 37.08 } -- location of the off-duty marker display. Default is PD Headquarters downtown

Config.VehicleModel = 'cp1' -- the model to spawn into. Make sure the model you put is 100% working otherwise you wont be able to go onduty

Config.SpawnLocation = { x = -576.0, y = -149.52, z = 37.92, heading = 205.59 } -- vehicle spawn location if using marker
Config.RemoveMarker = { x = -570.72, y = -143.84, z = 37.2 } -- vehicle removal marker
Config.RetrievalMarker = { x = -556.77, y = -130.67, z = 37.15 } -- vehicle retrieval marker
