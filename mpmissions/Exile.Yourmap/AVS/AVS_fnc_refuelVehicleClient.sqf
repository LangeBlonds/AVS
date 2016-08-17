/*
Developed by Vandest

Function:
	AVS_fnc_refuelVehicleClient - Refuels the vehicle for this client.

Usage (from the server):
	[_vehicle] remoteExec ["AVS_fnc_refuelVehicleClient", _vehicle];

Return Value:
	None
*/
private["_startVehicleFuel","_totalCapacity","_startVehicleFuelLiters","_endVehicleFuelLiters","_oneFuelLiter","_fuelPerSecond","_overClientAccount","_fuelInVehicle","_refuelSpeed","_refuelCost"];

_OK = params
[
	["_vehicle", objNull, [objNull]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_refuelVehicleClient with invalid parameters: %1",_this];
};


//*********************************************Assigning values*********************************************


_startVehicleFuel = fuel _vehicle;		// Fuel there is in the vehicle before refueling (value between 0 and 1)

_totalCapacity = (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "fuelCapacity") call BIS_fnc_GetCfgData;	// Tank capacity (in liters)

_startVehicleFuelLiters = round(_totalCapacity * _startVehicleFuel);	// Fuel there is in the vehicle before refueling (in liters)

_oneFuelLiter = 1 / _totalCapacity;		// Value that represents 1 liter in the tank for Arma.

// Refueling Speed:
if (AVS_AirVehicle) then 
{
	_refuelSpeed = AVS_RefuelSpeedAirVehicle;	// Refueling speed for chopper (liters/second)
}
else
{
	_refuelSpeed = AVS_RefuelSpeed;				// Refueling speed for ground vehicles (liters / second)
};

_fuelPerSecond = _oneFuelLiter * _refuelSpeed;	// Fuel to add in the vehicle, per second. (Refueling speed for Arma)
//---------------------------------------------

_overClientAccount = false;		// Client does not have enough money (default: false)

_fuelInVehicle = 0;				// Fuel to put in the vehicle (default: 0)

_startRefuelMoney = player getVariable ["ExileMoney", 0];		// Money the client has on him

AVS_Refueling = true;			// Refueling is on going (true). (To remove the "Start Refueling")

// Debug:
if (AVS_Debug) then 
{
	diag_log format ["AVS - _startRefuelMoney = %1", _startRefuelMoney];
};

//******************************************************************************************************************

// Checking the client has enough money on him to start the first loop:

_refuelCost = [_vehicle, _refuelSpeed] call AVS_fnc_getRefuelCost;
_popTabToRefuel = _startRefuelMoney - _refuelCost;

if (_popTabToRefuel < 0) then
{
	_overClientAccount = true;		// Not enough money
	AVS_CanRefuel = false;			// Can not refuel
};
//---------------------------------------------------------------------------------

//*********************************************Refueling*******************************************************

while {!(fuel _vehicle isEqualTo 1) && AVS_CanRefuel} do 	// If the tank is not full and the vehicle can be refueled

{
	_vehicleFuel = fuel _vehicle;						// Fuel there is in the vehicle (between 0 and 1)

	_fuelInVehicle = _fuelPerSecond + _vehicleFuel;		// Fuel there is in the vehicle + fuel added (between 0 and 1)

	if (AVS_Debug) then 
	{
		diag_log format ["AVS - _fuelPerSecond + _vehicleFuel = %1", _fuelInVehicle];
	};

	// If the value of the amount of fuel is greater than 1:
	if (_fuelInVehicle > 1) exitWith 
	{
		// If this is the case then get out of the loop:
		_fuelInVehicle = 1;
		_vehicle setFuel _fuelInVehicle;

		if (AVS_Debug) then 
		{
			diag_log "AVS - Vehicle is full";
			diag_log format ["AVS - _fuelInVehicle = %1", _fuelInVehicle];
		};
	};

	_endVehicleFuelLiters = round(_totalCapacity * _fuelInVehicle);						// Fuel in the tank in liters

	_fuelAddedInliters = _endVehicleFuelLiters - _startVehicleFuelLiters;				// Fuel added in liter

	_prevFuelAddedInliters = _fuelAddedInliters + _refuelSpeed;							// Estimate of fuel added during the next refueling cycle

	_prevRefuelCost = [_vehicle, _prevFuelAddedInliters] call AVS_fnc_getRefuelCost;	// Price estimate for the next refueling cycle

	if (AVS_Debug) then 
	{
		diag_log format ["AVS - _prevRefuelCost = %1", _prevRefuelCost];
	};
	

	// If the price of the next refueling cycle is greater than the money the client has on him:
	if ((_startRefuelMoney - _prevRefuelCost) < 0) exitWith 
	{
		// To make maximum use of the money available:
		_restRefuelMoney = _startRefuelMoney - ([_vehicle, _fuelAddedInliters] call AVS_fnc_getRefuelCost);
		if (_restRefuelMoney > AVS_FuelCost) then 
		{
			sleep 1;
			_clientLitersCanRefuel = _restRefuelMoney / AVS_FuelCost;
			_clientCanRefuel = _clientLitersCanRefuel / _totalCapacity;
			_fuelInVehicle = _clientCanRefuel + _vehicleFuel;
		};

		// Exit of the loop by adding this fuel cycle
		_overClientAccount = true;
		_vehicle setFuel _fuelInVehicle;

		if (AVS_Debug) then 
		{
			diag_log "Client don't have enough money to refuel more";
			diag_log format ["_fuelInVehicle = %1", _fuelInVehicle];
		};

		AVS_CanRefuel = false;			// Can not refuel anymore
	};
	//---------------------------------------------------------------------------------------------------

	_vehicle setFuel _fuelInVehicle;

	["Refueling",0,0,0.5,0.5] spawn bis_fnc_dynamictext;
	sleep 1;
};


_endVehicleFuelLiters = round(_totalCapacity * _fuelInVehicle);
_fuelAddedInliters = _endVehicleFuelLiters - _startVehicleFuelLiters;

[ExileClientSessionId, _vehicle, _fuelAddedInliters, _overClientAccount] remoteExecCall ["AVS_fnc_refuelPayment", 2];
if (AVS_Debug) then 
{
	diag_log format ["FinalfuelInVehicle = %1", fuel _vehicle];
};

AVS_Refueling = false;
