/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala
Modified by Vandest

All rights reserved.

Function:
	AVS_fnc_updateInteractionMenu - Updates the interaction menu to allow the player to rearm a vehicle.

Usage (from the server):
	[] spawn AVS_fnc_updateInteractionMenu

Return Value:
	None
*/
if (hasInterface) then
{
	AVS_rearmAction = 0;
	AVS_rearmActionAdded = false;
	AVS_previousRearmCost = 0;

	AVS_refuelAction = 0;
	AVS_refuelActionAdded = false;
	AVS_Refueling = false;
	AVS_CanRefuel = false;

	AVS_fillAction = 0;
	AVS_fillActionAdded = false;

	while {true} do
	{

		_vehicle = vehicle player;

		if (AVS_RefuelSystemActive && AVS_FillCanisterActive && {_vehicle isEqualTo player}) then 
		{
			_vehicle = player;
			_fillPoints = 0;

			{
				_fillObjects = (_vehicle nearObjects [_x, 3]);
				if (count _fillObjects > 0) exitWith {_fillPoints = 1};
			}
			forEach AVS_RefuelObjects;

			if (_fillPoints > 0 && (magazines player find "Exile_Item_FuelCanisterEmpty" >= 0)) then 
			{
				if (!AVS_fillActionAdded) then 
				{
					_canisterEmptyCost = _vehicle call AVS_fnc_getFillCanCost;
					_fillTitle = format ["<t size='1' shadow='1'><t color='#00F600'>Fill canister empty: %1 poptabs</t>", _canisterEmptyCost];
					AVS_fillAction = player addAction [_fillTitle, AVS_fnc_requestFillCanister, [_vehicle]];
					AVS_fillActionAdded = true;
				};
			}
			else
			{
				if (AVS_fillActionAdded) then
				{
					player removeAction AVS_fillAction;
					AVS_fillActionAdded = false;
				};
			};
		}
		else
		{
			if (AVS_fillActionAdded) then
			{
				player removeAction AVS_fillAction;
				AVS_fillActionAdded = false;
			};
		};

		try
		{

			if (!alive player || {_vehicle isEqualTo player}) then
			{
				throw 0;
			};

			if (!local _vehicle) then
			{
				throw 0;
			};

			_vel = velocity _vehicle;

			if (_vel select 0 > 0.01 || _vel select 1 > 0.01 || _vel select 2 > 0.1) then
			{
				throw 0;
			};

			_pos = getPosATL _vehicle;


			// Rearm:

			if (AVS_RearmSystemActive && (_pos select 2 < 0.1)) then
			{
				_rearmPoints = 0;
				{
					_rearmObjects = (_vehicle nearObjects [_x, AVS_RearmDistance]);		// Change for an issue when we ream on type of RearmObject and after we rearm on another same type of RearmObject with the "nearestObjects" command, I don't understand why but this is another way.
					if (count _rearmObjects > 0) exitWith {_rearmPoints = 1};
				}
				forEach AVS_RearmObjects;


				if (_rearmPoints > 0) then
				{
					_rearmCost = _vehicle call AVS_fnc_getRearmCost;

					if (AVS_rearmActionAdded && {!(AVS_previousRearmCost isEqualTo _rearmCost)}) then
					{
						player removeAction AVS_rearmAction;
						AVS_rearmActionAdded = false;
					};

					if (_rearmCost > 0) then
					{
						if (!AVS_rearmActionAdded) then 
						{
							_rearmTitle = format ["Rearm: %1 poptabs", _rearmCost];
							AVS_rearmAction = player addAction [_rearmTitle, AVS_fnc_requestRearm, [_vehicle]];
							AVS_previousRearmCost = _rearmCost;
							AVS_rearmActionAdded = true;
						};
					}
					else
					{
						if (AVS_rearmActionAdded) then
						{
							player removeAction AVS_rearmAction;
							AVS_rearmActionAdded = false;
						};
					};
				};
			}
			else
			{
				if (AVS_rearmActionAdded) then
				{
					player removeAction AVS_rearmAction;
					AVS_rearmActionAdded = false;
				};
			};


			// Refuel:
			if (_pos select 2 > 4) then 	// AVS_RefuelDistance for choppers
			{
				AVS_RefuelDist = 15;
				AVS_AirVehicle = true;
			} 
			else 							// AVS_RefuelDistance for ground vehicles
			{
				AVS_RefuelDist = AVS_RefuelDistance;
				AVS_AirVehicle = false;
			};

			if (AVS_RefuelSystemActive && (_pos select 2 < 7.5)) then
			{
				_refuelPoints = 0;

				{
					_refuelObjects = (_vehicle nearObjects [_x, AVS_RefuelDist]);		// Same to rearm
					if (count _refuelObjects > 0) exitWith {_refuelPoints = 1};
				}
				forEach AVS_RefuelObjects;

				if (_refuelPoints > 0) then
				{
					if (!AVS_refuelActionAdded) then 
					{
						if (!AVS_Refueling) then 
						{
							AVS_CanRefuel = true;

							private ["_title", "_description"];
							_title = "<t size='2' shadow='1'><t color='#00F600'>Start Refueling</t>";
							_description = format ["<t size='1' shadow='1'><t color='#FFFFFF'>Fuel price: %1 Poptabs/L</t>", AVS_FuelCost];
							_refuelTitle = [_title, _description] joinString "<br />";
							AVS_refuelAction = player addAction [_refuelTitle, AVS_fnc_requestRefuel, [_vehicle]];
							AVS_refuelActionAdded = true;
						}
						else
						{
							if (AVS_refuelActionAdded) then
							{
								player removeAction AVS_refuelAction;
								AVS_refuelActionAdded = false;
							};
						};
					};
				}
				else
				{
					AVS_CanRefuel = false;
					if (AVS_refuelActionAdded) then
					{
						player removeAction AVS_refuelAction;
						AVS_refuelActionAdded = false;
					};
				};
			}
			else
			{
				AVS_CanRefuel = false;
				if (AVS_refuelActionAdded) then
				{
					player removeAction AVS_refuelAction;
					AVS_refuelActionAdded = false;
				};
			};
		}
		catch
		{
			if (_exception isEqualTo 0) then
			{
				if (AVS_rearmActionAdded) then
				{
					player removeAction AVS_rearmAction;
					AVS_rearmActionAdded = false;
				};

				AVS_CanRefuel = false;
				if (AVS_refuelActionAdded) then
				{
					player removeAction AVS_refuelAction;
					AVS_refuelActionAdded = false;
				};
			};
		};
		sleep 2;
	};
};
