/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_getRefuelCost - Gets the current cost to refuel this vehicle.
Usage:
	[_vehicle, _fuelAdding] call AVS_fnc_getRefuelCost;
Return Value:
	Number value representing the poptab cost of the vehicle refuel.
*/

_OK = params
[
	["_vehicle", objNull, [objNull]],
	["_fuelAddedInliters", 0, [0]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_getRefuelCost with invalid parameters: %1",_this];
};

//_totalFuelLiters = AVS_RefuelSpeed * _fuelAddedInliters;

_totalCost = AVS_FuelCost * _fuelAddedInliters;
_totalCost