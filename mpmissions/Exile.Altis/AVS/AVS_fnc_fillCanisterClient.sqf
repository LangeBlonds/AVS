/*
Function:
	AVS_fnc_fillCanisterClient - Refuels the vehicle for this client.

Usage (from the server):
	[_vehicle] remoteExec ["AVS_fnc_fillCanisterClient", _vehicle];

Return Value:
	None
*/

_OK = params
[
	["_vehicle", objNull, [objNull]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_fillCanisterClient with invalid parameters: %1",_this];
};

_vehicle removeItem "Exile_Item_FuelCanisterEmpty";
_vehicle addItem "Exile_Item_FuelCanisterFull";