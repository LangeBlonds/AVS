/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_init - Initializes AVS mission file code.

Usage:
	call AVS_fnc_init;

Return Value:
	None
*/

if (isNil "AVS_Version") exitWith
{
	diag_log "AVS - Mission code initialization cancelled. Server code not detected.";
};

AVS_fnc_getConfigLoadout = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getConfigLoadout.sqf");

if (AVS_RearmSystemActive || AVS_RefuelSystemActive) then
{
	if (AVS_RearmSystemActive) then {
		diag_log "AVS Rearm System active.";
		AVS_fnc_getRearmCost = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getRearmCost.sqf");
		AVS_fnc_getVehicleLoadout = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getVehicleLoadout.sqf");
		AVS_fnc_rearmTurret = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_rearmTurret.sqf");
		AVS_fnc_requestRearm = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_requestRearm.sqf");
	};
	if (AVS_RefuelSystemActive) then {
		diag_log "AVS Refuel System active.";
		AVS_fnc_sanitizegastation = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_sanitizegastation.sqf");
		AVS_fnc_getRefuelCost = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getRefuelCost.sqf");
		AVS_fnc_refuelVehicleClient = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_refuelVehicleClient.sqf");
		AVS_fnc_requestRefuel = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_requestRefuel.sqf");
		if (AVS_FillCanisterActive) then {
			diag_log "AVS Fill Canister active.";
			AVS_fnc_fillCanisterClient = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_fillCanisterClient.sqf");
			AVS_fnc_getFillCanCost = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getFillCanCost.sqf");
			AVS_fnc_requestFillCanister = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_requestFillCanister.sqf");
		};
	};
	//AVS_fnc_setPlayerMoney = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_setPlayerMoney.sqf");
	AVS_fnc_updateInteractionMenu = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_updateInteractionMenu.sqf");

	//diag_log format ["!hasInterfaction: %1; isServer: %2", !hasInterface, isServer];
	if (!hasInterface || isServer) then
	{
		diag_log "AVS - Mission code initialized.";
	}
	else
	{
		// Client-side only stuff.
		AVS_fnc_getConfigLoadout = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getConfigLoadout.sqf");	// Server already processed this file.
		[] spawn AVS_fnc_sanitizegastation;
		[] spawn AVS_fnc_updateInteractionMenu;
		diag_log format ["AVS - Client code version %1 initialized.", AVS_Version];
	};
};