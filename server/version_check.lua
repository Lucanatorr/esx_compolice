local resourceName = GetCurrentResourceName()

PerformHttpRequest('https://raw.githubusercontent.com/Lucanatorr/esx_compolice/master/version', function(Error, NewestVersion, Header)
	curVersion = GetResourceMetadata( GetCurrentResourceName(), "version" )

	if curVersion ~= NewestVersion and tonumber(curVersion) < tonumber(NewestVersion) then
		print('\n##############')
		print('## ^4' .. GetCurrentResourceName() .. '^7')
		print('##')
		print('## Current Version: ^1' .. curVersion .. '^7')
		print('## Latest recommended version: ^2' .. NewestVersion .. '^7')
		print('## ^4'..resourceName.."^7 is ^1out of date^7, update it on github!")
		print('##############')
	else
		print('\n##############')
		print('## ^4' .. GetCurrentResourceName() .. '^7')
		print('##')
		print('## Current Version: ^2' .. curVersion .. '^7')
		print('## Latest recommended version: ^2' .. NewestVersion .. '^7')
		print('## ^4'..resourceName.."^7 is up to date, have fun!")
		print('##############')
	end
end)