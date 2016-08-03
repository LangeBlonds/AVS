/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_getConfigLoadout - Gets the loadout of the vehicle type from CfgVehicles.
Usage:
	_vehicleType call AVS_fnc_getConfigLoadout;
Return Value:
	Loadout of the vehicle in the format:
	[
		[_turretPath, _turretWeapons, _turretMagazines]
	]
*/

_OK = params
[
	["_vehicleType", "", [""]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_getConfigLoadout with invalid parameters: %1",_this];
};

// Grab the driver loadout manually.
_driverWeapons = (configFile >> "CfgVehicles" >> _vehicleType >> "weapons") call BIS_fnc_GetCfgData;
_driverMagazines = (configFile >> "CfgVehicles" >> _vehicleType >> "magazines") call BIS_fnc_GetCfgData;

_vehicleLoadout = [];
if (count _driverWeapons > 0 || {count _driverMagazines > 0}) then
{
	_vehicleLoadout pushBack [[-1], _driverWeapons, _driverMagazines];
};

// Loop around the turrets to get all turret weapons.
_vehicleTurrets = configFile >> "CfgVehicles" >> _vehicleType >> "Turrets";
for "_i" from 0 to (count _vehicleTurrets - 1) do
{
	_turretPath = _vehicleTurrets select _i;
	_turretWeapons = (_turretPath >> "weapons") call BIS_fnc_GetCfgData;
	_turretMagazines = (_turretPath >> "magazines") call BIS_fnc_GetCfgData;

	if (count _turretWeapons > 0 || {count _turretMagazines > 0}) then
	{
		_vehicleLoadout pushBack [[_i], _turretWeapons, _turretMagazines];
	};
};
_vehicleLoadout