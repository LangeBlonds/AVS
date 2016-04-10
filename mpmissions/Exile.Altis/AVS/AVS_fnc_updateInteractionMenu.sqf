/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

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
	AVS_previousRefuelCost = 0;

	AVS_fillAction = 0;
	AVS_fillActionAdded = false;

	while {true} do
	{

		_vehicle = vehicle player;

		if (AVS_RefuelSystemActive && AVS_FillCanisterActive && {_vehicle isEqualTo player}) then 
		{
			diag_log "AVS fill, Etape 1: refuel et fill actif et joueur a pied";
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
					diag_log "AVS fill, Etape 2: ajout de l'action car proche d'une station et avec un jerrican ds les poches";
					_canisterEmptyCost = _vehicle call AVS_fnc_getFillCanCost;
					_fillTitle = format ["Fill canister empty: %1 poptabs", _canisterEmptyCost];
					AVS_fillAction = player addAction [_fillTitle, AVS_fnc_requestFillCanister, [_vehicle]];
					AVS_fillActionAdded = true;
				};
				diag_log "AVS fill, Etape 3: ne fait rien apres l'etape 2";
			}
			else
			{
				if (AVS_fillActionAdded) then
				{
					diag_log "AVS fill, Etape 4: retire l'action si loin de la station et/ou si plus de jerrican vide";
					player removeAction AVS_fillAction;
					AVS_fillActionAdded = false;
				};
			};
		}
		else
		{
			if (AVS_fillActionAdded) then
			{
				diag_log "AVS fill, Etape 5: retire l'action si joueur ds un vehicule";
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

			if (AVS_RefuelSystemActive && (_pos select 2 < 5.1)) then
			{
				_refuelPoints = 0;			
				{
					_refuelObjects = (_vehicle nearObjects [_x, AVS_RefuelDistance]);		// Same to rearm
					if (count _refuelObjects > 0) exitWith {_refuelPoints = 1};
				}
				forEach AVS_RefuelObjects;

				if (_refuelPoints > 0) then
				{
					_refuelCost = _vehicle call AVS_fnc_getRefuelCost;

					if (AVS_refuelActionAdded && {!(AVS_previousRefuelCost isEqualTo _refuelCost)}) then
					{
						player removeAction AVS_refuelAction;
					};

					if (_refuelCost > 0) then
					{
						if (!AVS_refuelActionAdded) then 
						{
							_refuelTitle = format ["Refuel: %1 poptabs", _refuelCost];
							AVS_refuelAction = player addAction [_refuelTitle, AVS_fnc_requestRefuel, [_vehicle]];
							AVS_previousRefuelCost = _refuelCost;
							AVS_refuelActionAdded = true;
						};
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
