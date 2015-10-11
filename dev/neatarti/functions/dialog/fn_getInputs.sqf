#include "script_component.hpp"

params ["_display"];

private ["_inputs", "_errorState"];
_inputs = [];
_errorState = false;

// standard inputs
_targetPosX = ctrlText (_display displayCtrl IDC_TXT_TPOSX);
_targetPosY = ctrlText (_display displayCtrl IDC_TXT_TPOSY);
_targetHeight = ctrlText (_display displayCtrl IDC_TXT_THEIGHT);
_magazine = lbCurSel (_display displayCtrl IDC_CMB_MAGAZINE);

systemChat _targetHeight;

if(!CAN_BE_PARSED(_targetPosX))   exitWith { systemChat "x"; SHOWERROR(_display, "Invalid format: TPOS"); _inputs };
if(!CAN_BE_PARSED(_targetPosY))   exitWith { systemChat "y"; SHOWERROR(_display, "Invalid format: TPOS"); _inputs };
if(!CAN_BE_PARSED(_targetHeight)) exitWith { systemChat "h"; SHOWERROR(_display, "Invalid format: THEIGHT"); _inputs };
if(_magazine == -1) exitWith { systemChat "m"; SHOWERROR(_display, "No magazine found."); _inputs };

_inputs pushBack [parseNumber _targetPosX, parseNumber _targetPosY];
_inputs pushBack parseNumber _targetHeight;
_inputs pushBack (GVAR(magazineConfigs) select _magazine);

switch(GVAR(attackType)) do {
    case "line": {
        _toPosX = ctrlText (_display displayCtrl IDC_TXT_TOPOSX);
        _toPosY = ctrlText (_display displayCtrl IDC_TXT_TOPOSY);
        _count = ctrlText (_display displayCtrl IDC_TXT_COUNT);

        if(!CAN_BE_PARSED(_toPosX)) exitWith { SHOWERROR(_display, "Invalid format: TOPOS"); _errorState = true; };
        if(!CAN_BE_PARSED(_toPosY)) exitWith { SHOWERROR(_display, "Invalid format: TOPOS"); _errorState = true; };
        if(!CAN_BE_PARSED(_count))  exitWith { SHOWERROR(_display, "Invalid format: COUNT"); _errorState = true; };

        _inputs pushBack [parseNumber _toPosX, parseNumber _toPosY];
        _inputs pushBack parseNumber _count;
    };
    case "area": {
        _radius = ctrlText (_display displayCtrl IDC_TXT_RADIUS);

        if(!CAN_BE_PARSED(_radius)) exitWith { SHOWERROR(_display, "Invalid format: RADIUS"); _errorState = true; };

        _inputs pushBack parseNumber _radius;
    };
};

if(_errorState) exitWith { _inputs };

systemChat str _inputs;
_inputs;