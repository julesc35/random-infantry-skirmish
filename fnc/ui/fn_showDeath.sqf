_side = _this select 0;
_killer = _this select 1;
_body = _this select 2;


if (isNull(RSTF_CAM)) then {
	RSTF_CAM = "camera" camCreate getPos(_body);
};

RSTF_CAM camSetPos getPos(_body);
RSTF_CAM camSetTarget _body;
RSTF_CAM cameraEffect ["internal", "back"];
RSTF_CAM camCommit 0;
RSTF_CAM camSetRelPos [10, 0, 50];
RSTF_CAM camCommit 2;

_dialogName = "RSTF_RscDeathDialog";
_ok = createDialog _dialogName;
if (!_ok) exitWith {
	systemChat "Fatal error. Couldn't create death dialog.";
	_side call RSTF_fnc_spawnPlayer;
};

RSTF_DEATH_SIDE = _side;
RSTF_DEATH_KILLER = _killer;
RSTF_DEATH_BODY = _body;

_display = _dialogName call RSTF_fnc_getDisplay;
_display displayAddEventHandler ["unload", {
	systemChat str(_this select 1);
	if (_this select 1 != 1) then {
		RSTF_DEATH_SIDE spawn RSTF_fnc_spawnPlayer
	};
}];

_ctrl = [_dialogName, "spawn"] call RSTF_fnc_getCtrl;
_ctrl ctrlAddEventHandler ["ButtonClick", {
	closeDialog 0;
}];

_ctrl = [_dialogName, "equip"] call RSTF_fnc_getCtrl;
_ctrl ctrlShow RSTF_CUSTOM_EQUIPMENT;
_ctrl ctrlAddEventHandler ["ButtonClick", {
	closeDialog 1;
	[true, [RSTF_DEATH_SIDE, RSTF_DEATH_KILLER, RSTF_DEATH_BODY]] spawn RSTF_fnc_showEquip;
	true;
}];

if (isNull(_killer)) then {
	_ctrl = [_dialogName, "weaponName"] call RSTF_fnc_getCtrl;
	_ctrl ctrlShow false;
	_ctrl = [_dialogName, "weaponImage"] call RSTF_fnc_getCtrl;
	_ctrl ctrlShow false;
	_ctrl = [_dialogName, "distance"] call RSTF_fnc_getCtrl;
	_ctrl ctrlShow false;
} else {
	_distance = _killer distance _body;
	_weapon = currentWeapon(_killer);
	_name = getText(configFile >> "cfgWeapons" >> _weapon >> "displayName");
	_image = getText(configFile >> "cfgWeapons" >> _weapon >> "picture");
	
	_ctrl = [_dialogName, "weaponName"] call RSTF_fnc_getCtrl;
	_ctrl ctrlSetText "By " + _name;
	_ctrl = [_dialogName, "weaponImage"] call RSTF_fnc_getCtrl;
	_ctrl ctrlSetText _image;
	_ctrl = [_dialogName, "distance"] call RSTF_fnc_getCtrl;
	_ctrl ctrlSetText "From distance of " + str(round(_distance)) + " m";
};