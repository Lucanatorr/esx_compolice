# esx_compolice

Commmunity Police script designed for ESX servers.

## Showcase Video

https://streamable.com/26nvjx

## How to use

1. Configure values in the config.lua file

2. Go to 'esx_policejob' and add this to the __resource.lua/fxmanifest at the bottom:
```lua
 exports {
	'OpenPoliceActionsMenu',
	'OpenIdentityCardMenu',
	'OpenBodySearchMenu',
	'ShowPlayerLicense',
	'OpenUnpaidBillsMenu',
	'LookupVehicle',
	'OpenVehicleInfosMenu',
	'ImpoundVehicle',
	'createBlip'
}
```

3. Navigate to 'esx_policejob/server/main.lua' **(this is very important)**
  	Anywhere you see:
  ```lua
  	if xPlayer.job.name == 'police'
  ```
  	Add the following: 
  ```lua
  	if xPlayer.job.name == 'police' or if xPlayer.job.name == 'compolice' then
  ```

4. Navigate to 'esx_policejob/client/main.lua' **(this is also very important)**
  	Anywhere you see:
  ```lua
  	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police'
  ```
  	Add the following: 
  ```lua
  	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'compolice' then
  ```
  

*Feel free to edit the resource but make sure to pass it through and give me credits*
*If you edit and want to release on the forums/github message me first*

Credit:
The police menu code and blips is from:
https://github.com/ESX-Org/esx_policejob

## Requirements
- es_extended (https://github.com/ESX-Org/es_extended)
- gcphone (https://github.com/N3MTV/gcphone) **(or any other phone script)**
- esx_policejob (https://github.com/ESX-Org/esx_policejob)
- mythic_progressbar (https://github.com/XxFri3ndlyxX/mythic_progressbar)

## Download & Installation

### Using [fvm](https://github.com/qlaffont/fvm-installer)
```
fvm install --save --folder=esx Lucanatorr/esx_compolice
```

### Using Git
```
cd resources
git clone https://github.com/Lucanatorr/esx_compolice [esx]/esx_compolice
```

### Manually
- Download https://github.com/Lucanatorr/esx_compolice/archive/master.zip
- Put it in the `[esx]` directory

## Installation
- Import `job.sql` in your database
- Add this in your `server.cfg`:

```
start esx_compolice
```


# Support
If you need support, want to suggest something, or want to re-release message me on Discord:

Lucanatorr#0001

Want to see more scripts like this? Ask for my patreon on Discord
# Legal
### License

Copyright (C) 2020 Lucanatorr

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
