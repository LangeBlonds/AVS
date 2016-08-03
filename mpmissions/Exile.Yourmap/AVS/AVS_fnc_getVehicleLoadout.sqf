/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_getVehicleLoadout - Gets the current loadout of the vehicle.

Usage:
	_vehicle call AVS_fnc_getVehicleLoadout;

Return Value:
	Loadout of the vehicle in the format:
	[
		[_turretPath, [_magazineClassName, _totalAmmo], [_magazineClassName2, _totalAmmo]],
		[_turretPath2, [_magazineClassName3, _totalAmmo], [_magazineClassName4, _totalAmmo]],
	]

Notes:
	The return value will only specify a single magazine class name for each magazine class in a turret. For example, an armed offroad will return:
	[
		[[0], ["100Rnd_127x99_mag_Tracer_Yellow", 400]]
	];
*/
private ["_currentLoadout", "_magClass", "_turretPath", "_ammoCount", "_inserted", "_magInserted", "_magData"];
_OK = params
[
	["_vehicle", objNull, [objNull]]
];

if (!_OK) exitWith
{
	diag_log format ["AVS Error: Calling AVS_fnc_getVehicleLoadout with invalid parameters: %1",_this];
};

_currentLoadout = [];
{ // forEach magazinesAllTurrets _vehicle;
	// [[<className>,<turretPath>,<ammoCount>,<id>,<creator>],...]
	_magClass = _x select 0;
	_turretPath = _x select 1;
	_ammoCount = _x select 2;

	_inserted = false;
	{ // forEach _currentLoadout
		// Check if we have this _turretPath in _currentLoadout
		if ((_x select 0) isEqualTo _turretPath) then
		{
			// _turretPath found in _currentLoadout
			// Now check if we have this _magClass in this _turretPath yet.
			_magInserted = false;
			for "_i" from 1 to ((count _x) - 1) do
			{
				_magData = _x select _i;

				if ((_magData select 0) isEqualTo _magClass) then
				{
					// _magClass found, add the ammo to it.
					_magData set [1, ((_magData select 1) + _ammoCount)];
					_magInserted = true;
				};
			};
			if (!_magInserted) then
			{
				// _magClass not found, push it as a new element.
				_x pushBack [_magClass, _ammoCount];
			};
			_inserted = true;
		};
	} forEach _currentLoadout;

	if (!_inserted) then
	{
		// _turretPath not found in _currentLoadout, push it as a new element.
		_currentLoadout pushBack [_turretPath, [_magClass, _ammoCount]];
	};
} forEach magazinesAllTurrets _vehicle;

_currentLoadout