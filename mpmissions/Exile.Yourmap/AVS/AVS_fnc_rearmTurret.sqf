/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_rearmTurret - Rearms the vehicle for this client.

Usage (from the server):
	[_vehicle] remoteExec ["AVS_fnc_rearmTurret", _player];

Return Value:
	None
*/

_OK = params
[
	["_vehicle", objNull, [objNull]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_rearmTurret with invalid parameters: %1",_this];
};

_vehicle setVehicleAmmoDef 1;