private ["_iiii"];

private _side = param [0];
private _position = param [1];

// Direction to mission center
private _direction = _position getDir RSTF_POINT;

private _transportClasses = (RSTF_VEHICLES select _side) select RSTF_VEHICLE_TRANSPORT;
private _transports = [];

private _transportsCount = 2 + random(2);

/*
diag_log text(format["Transports for %1:", _side]);
{
	_displayName = getText(configFile >> "cfgvehicles" >> _x >> "displayName");
	diag_log text(format["%1 (%2)", _displayName, _x]);
} foreach _transportClasses;
*/

if (count(_transportClasses) > 0) then {
	for "_iiii" from 1 to _transportsCount do {
		_cls = (selectRandom _transportClasses);
		_pos = [];
		
		// Try to search for suitable position
		_tries = 0;
		while { _tries < 5 } do {
			_pos = [[[_position, 100]]] call BIS_fnc_randomPos;
			_pos = _pos findEmptyPosition [10, 50, _cls];
			_tries = _tries + 1;
			if (count(_pos) > 0) exitWith { 0 };
		};

		if (count(_pos) > 0) then {
			_vehicle = _cls createVehicle _pos;
			_vehicle setVehicleLock "LOCKEDPLAYER";
			_vehicle setDir (_direction - 10 + random(20));
			_transports pushBack _vehicle;
		};
	};
};

RSTF_SPAWN_VEHICLES set [_side, _transports];