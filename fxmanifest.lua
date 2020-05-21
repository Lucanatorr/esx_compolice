fx_version 'adamant'

game 'gta5'

name 'ESX Community Police'
description 'Community Police resource for ESX-based servers'
author 'Lucanatorr'
version '1.0.0'

dependencies {
	'es_extended',
	'esx_policejob',
}

server_scripts {
	'server/version_check.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/client.lua',
}
