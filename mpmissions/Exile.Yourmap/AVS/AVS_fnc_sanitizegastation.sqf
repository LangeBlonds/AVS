/*
Usage:
	call AVS_fnc_sanitizegastation;
Return Value:
	None
*/
if (AVS_DisableStockRefuel) then
{
	diag_log "Disable Gas Station started";

// Get gastation locations
_gastation = nearestobjects [AVS_WorldCenter, AVS_RefuelObjects, AVS_WorldRadius];
Gastation_locations = [];
{Gastation_locations = Gastation_locations + [getpos _x]} foreach _gastation;

// Sanitize gastation
{
	_gastationToEmpty = nearestObjects [_x, AVS_RefuelObjects, 10];
	{
		_x setFuelCargo 0;
	} forEach _gastationToEmpty;
} foreach Gastation_locations;

	diag_log "Disable Gas Station finished";
};