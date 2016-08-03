/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_getRearmCost - Gets the current cost to rearm this vehicle.
Usage:
	_vehicle call AVS_fnc_getRearmCost;
Return Value:
	Number value representing the poptab cost of the vehicle rearm.
*/

_OK = params
[
	["_vehicle", objNull, [objNull]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_getRearmCost with invalid parameters: %1",_this];
};

_totalCost = 0;

// Get our current loadout.
_currentLoadout = call AVS_fnc_getVehicleLoadout;
// Get the full config loadout
_configLoadout = (typeOf _vehicle) call AVS_fnc_getConfigLoadout;

// Determine what we're missing from the config loadout.
{ // forEach _currentLoadout (Loop through the turrets)
	_turretPath = _x select 0;
	_configTurretMags = [];
	{
		// Find the mags associated with this _turretPath
		if (_x select 0 isEqualTo _turretPath) exitWith
		{
			_configTurretMags = _x select 2;
		};
	} forEach _configLoadout;

	// Loop through the mags we have to see how much we're missing.
	// Note: We don't loop through the config mags, because it may include sanitized ammo.
	for "_i" from 1 to ((count _x) - 1) do
	{
		//_magData = [_magClass, _totalAmmo];
		_magData = _x select _i;
		_magClass = _magData select 0;
		_ammoCount = _magData select 1;

		// Calculate how many magazines worth of ammo we have.
		_ammoPerMag = (configFile >> "CfgMagazines" >> _magClass >> "count") call BIS_fnc_GetCfgData;
		_numMags = _ammoCount / _ammoPerMag;

		// Calculate how many magazines worth of ammo we're missing.
		_maxMags = { if (toLower _x isEqualTo toLower _magClass) then {true}; } count _configTurretMags;
		_magsMissing = _maxMags - _numMags;

		// Lookup the cost of each magazine. (Or use the default value)
		_magCost = AVS_RearmCostDefault;
		{
			if (_magClass isEqualTo (_x select 0)) then
			{
				_magCost = _x select 1;
			};
		} forEach AVS_RearmCosts;

		// Calculate how much it'll cost to top off the magazines of this type.
		_magTypeCost = ceil (_magsMissing * _magCost);

		// Add that to the total.
		_totalCost = _totalCost + _magTypeCost;
	};
} forEach _currentLoadout;

_totalCost