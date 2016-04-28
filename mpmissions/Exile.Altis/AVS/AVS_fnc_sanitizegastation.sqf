/*
Usage:
	call AVS_fnc_sanitizegastation;
Return Value:
	None
*/
if (AVS_DisableStockRefuel) then
{
	diag_log "Disable Gas Station started";
	_centermap = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");

	_radiusmap = _centermap;
	_radiusmap sort false;
	_radiusmap = _radiusmap select 0;

	_gastation = nearestobjects [_centermap, AVS_RefuelObjects, _radiusmap];
	Gastation_locations = [];
	{Gastation_locations = Gastation_locations + [getpos _x]} foreach _gastation;

	{
		_gastationToEmpty = nearestObjects [_x, AVS_RefuelObjects, 10];
		{ _x setFuelCargo 0; } forEach _gastationToEmpty;
	} foreach Gastation_locations;
	diag_log "Disable Gas Station finished";
};