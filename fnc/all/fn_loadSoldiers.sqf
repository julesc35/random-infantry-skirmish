private _factions = _this select 0;
private _ignore_bans = false;
if (count(_this) > 1) then {
	_ignore_bans = _this select 1;
};
private _soldiers = [];
private _weapons = [];

private _classes = configFile >> "CfgVehicles";
private _i = 0;

_factions = _factions apply { toLower(_x) };

//Load men and vehicles for each faction
for [{_i = 0},{_i < count(_classes)},{_i = _i + 1}] do {
	private _c = _classes select _i;
	if (isClass(_c)) then {
		private _scope = getNumber(_c >> "scope");
		private _man = getNumber(_c >> "isMan");
		private _faction = toLower(getText(_c >> "faction"));

		if (_scope == 2 && _man == 1 && _faction in _factions) then {
			private _weaponized = false;
			private _wp = getArray(_c >> "weapons");
			{
				private _usable = [configFile >> "cfgWeapons" >> _x, false] call RSTF_fnc_isUsableWeapon;
				if (_x != "Throw" && _x != "Put" && _usable) then {
					_weaponized = true;
					if (!(_x in _weapons) && (_ignore_bans || !(_x in RSTF_WEAPONS_BANNED))) then {
						_weapons set [count(_weapons), _x];
					};
				};
			} foreach _wp;

			if (_weaponized) then {
				if (_ignore_bans || !(configName(_c) in RSTF_SOLDIERS_BANNED)) then {
					_soldiers set [count(_soldiers), configName(_c)];
				};
			};
		};
	};
};

[_soldiers, _weapons];