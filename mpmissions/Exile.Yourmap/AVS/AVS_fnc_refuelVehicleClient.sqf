/*
Developed by Vandest

Function:
	AVS_fnc_refuelVehicleClient - Refuels the vehicle for this client.

Usage (from the server):
	[_vehicle] remoteExec ["AVS_fnc_refuelVehicleClient", _vehicle];

Return Value:
	None
*/
private["_startVehicleFuel","_totalCapacity","_startVehicleFuelLiters","_endVehicleFuelLiters","_oneFuelLiter","_fuelPerSecond","_overClientAccount","_fuelInVehicle","_refuelSpeed"];

_OK = params
[
	["_vehicle", objNull, [objNull]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_refuelVehicleClient with invalid parameters: %1",_this];
};

_startVehicleFuel = fuel _vehicle;
_totalCapacity = (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "fuelCapacity") call BIS_fnc_GetCfgData;
_startVehicleFuelLiters = round(_totalCapacity * _startVehicleFuel);
_oneFuelLiter = 1 / _totalCapacity;
if (AVS_AirVehicle) then 
{
	_refuelSpeed = AVS_RefuelSpeedAirVehicle;
}
else
{
	_refuelSpeed = AVS_RefuelSpeed;
};

_fuelPerSecond = _oneFuelLiter * _refuelSpeed;
_overClientAccount = false;
_fuelInVehicle = 0;
//diag_log format ["ExileClientSessionId = %1", ExileClientSessionId];
//_owner = ExileClientSessionId call ExileServer_system_session_getPlayerObject;
//diag_log format ["_owner = %1", _owner];
_startRefuelMoney = player getVariable ["ExileMoney", 0];
//_startRefuelMoney = ExileClientPlayerMoney;
if (AVS_Debug) then 
{
	diag_log format ["_startRefuelMoney = %1", _startRefuelMoney];
};

AVS_Refueling = true;

while {!(fuel _vehicle isEqualTo 1) && AVS_CanRefuel} do 
{
	_vehicleFuel = fuel _vehicle;
	_fuelInVehicle = _fuelPerSecond + _vehicleFuel;
	if (AVS_Debug) then 
	{
		diag_log format ["_fuelPerSecond + _vehicleFuel = %1", _fuelInVehicle];
	};

	if (_fuelInVehicle > 1) exitWith 
	{
		_fuelInVehicle = 1;
		_vehicle setFuel _fuelInVehicle;
		if (AVS_Debug) then 
		{
			diag_log format ["_fuelInVehicle = %1", _fuelInVehicle];
		};
	};

	_endVehicleFuelLiters = round(_totalCapacity * _fuelInVehicle);
	_fuelAddedInliters = _endVehicleFuelLiters - _startVehicleFuelLiters;
	_prevFuelAddedInliters = _fuelAddedInliters + _refuelSpeed;
	_prevRefuelCost = [_vehicle, _prevFuelAddedInliters] call AVS_fnc_getRefuelCost;
	if (AVS_Debug) then 
	{
		diag_log format ["_prevRefuelCost = %1", _prevRefuelCost];
	};
	//_totalRefuelCost = _totalRefuelCost + _refuelCost;
	//diag_log format ["_totalRefuelCost = %1", _totalRefuelCost];

	if ((_startRefuelMoney - _prevRefuelCost) < 0) exitWith 
	{
		if (_startRefuelMoney < 0) then 
		{
			_overClientAccount = true;
		}
		else
		{
			_overClientAccount = true;
			_clientLitersCanRefuel = _startRefuelMoney / AVS_FuelCost;
			_clientCanRefuel = _clientLitersCanRefuel / _totalCapacity;
			_fuelInVehicle = _clientCanRefuel + _vehicleFuel;
			_vehicle setFuel _fuelInVehicle;
			if (AVS_Debug) then 
			{
				diag_log format ["_fuelInVehicle = %1", _fuelInVehicle];
			};
		};
	};

	_vehicle setFuel _fuelInVehicle;

	["Refueling",0,0,0.5,0.5] spawn bis_fnc_dynamictext;
	sleep 1;
};

AVS_Refueling = false;

_endVehicleFuelLiters = round(_totalCapacity * _fuelInVehicle);
_fuelAddedInliters = _endVehicleFuelLiters - _startVehicleFuelLiters;

[ExileClientSessionId, _vehicle, _fuelAddedInliters, _overClientAccount] remoteExecCall ["AVS_fnc_refuelPayment", 2];
if (AVS_Debug) then 
{
	diag_log format ["FinalfuelInVehicle = %1", fuel _vehicle];
};
