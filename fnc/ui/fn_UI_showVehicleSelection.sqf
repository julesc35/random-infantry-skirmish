/*
	Function:
	RSTF_fnc_UI_showVehicleSelection

	Description:
	Shows vehicle selection ui dialog.

	Author:
	Jan Zípek
*/

disableSerialization;

#define DISPLAYNAME "RSTF_RscVehicleDialog"

private _ok = createDialog DISPLAYNAME;
if (!_ok) exitWith {
	systemChat "Fatal error. Couldn't create vehicle dialog.";
};

private _display = DISPLAYNAME call RSTF_fnc_getDisplay;

private _ctrlList = [DISPLAYNAME, "VehicleSelect"] call RSTF_fnc_getCtrl;
private _ctrlBuy = [DISPLAYNAME, "ButtonBuy"] call RSTF_fnc_getCtrl;

private _vehicles = RSTF_BUYABLE_VEHICLES;
private _index = [player] call RSTF_MODE_KOTH_getMoneyIndex;
private _money = RSTF_MODE_KOTH_MONEY select _index;

lnbClear _ctrlList;
{
	private _category = _x select 0;
	private _vehicle = _x select 1;
	private _config = configFile >> "cfgVehicles" >> _vehicle;
	private _displayName = getText(_config >> "displayName");
	private _picture = getText(_config >> "picture");
	private _cost = [_vehicle] call RSTF_fnc_vehicleCost;

	_ctrlList lnbAddRow [_displayName, format["%1$", _cost]];
	_ctrlList lnbSetPicture [[_foreachIndex, 0], _picture];

	if (_money < _cost) then {
		_ctrlList lnbSetColor [[_foreachIndex, 0], [0.5, 0.5, 0.5, 1]];
		_ctrlList lnbSetColor [[_foreachIndex, 1], [1, 0.5, 0.5, 1]];
	};

} foreach _vehicles;

_ctrlBuy ctrlAddEventHandler ["ButtonClick", {
	private _display = DISPLAYNAME call RSTF_fnc_getDisplay;
	private _ctrlList = [DISPLAYNAME, "VehicleSelect"] call RSTF_fnc_getCtrl;
	private _selected = lnbCurSelRow _ctrlList;

	private _vehicles = RSTF_BUYABLE_VEHICLES;
	private _index = [player] call RSTF_MODE_KOTH_getMoneyIndex;
	private _money = RSTF_MODE_KOTH_MONEY select _index;

	if (_selected >= 0 && _selected < count(_vehicles)) then {
		private _vehicle = (_vehicles select _selected) select 1;
		private _cost = [_vehicle] call RSTF_fnc_vehicleCost;

		if (_money >= _cost) then {
			closeDialog 0;

			// Ask server to spawn our vehicle
			[player, _vehicle] remoteExec ["RSTF_fnc_requestVehicle", 2];
		} else {
			["You don't have money for that.", "You're poor"] spawn BIS_fnc_guiMessage;
		};
	}
}];

player switchMove RSTF_REMOTE_WORK_MOVE;
