/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_getRefuelCost - Gets the current cost to refuel this vehicle.
Usage:
	_vehicle call AVS_fnc_getRearmCost;
Return Value:
	Number value representing the poptab cost of the vehicle refuel.
*/

_OK = params
[
	["_vehicle", objNull, [objNull]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_getRefuelCost with invalid parameters: %1",_this];
};

_fuelEmpty = 1 - (fuel _vehicle);
_totalCapacity = (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "fuelCapacity") call BIS_fnc_GetCfgData;

_litersToRefuel = round(_totalCapacity * _fuelEmpty);

_totalCost = AVS_RefuelCost * _litersToRefuel;
_totalCost