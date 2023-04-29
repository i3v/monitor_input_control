#Requires AutoHotkey v2.0

; PC-specific constants:
; From Windows Device Manager, "Details" tab, "Device instance path" property
WATCHED_USB_DEVICE_ID := "USB\VID_05E3&PID_0610\7&22E9D8FA&0&2"

ALL_EXPECTED_DISPLAYS := Map("\\.\DISPLAY5", Map("Current",6939,"Target",19),  ; U4320Q (center)
							 "\\.\DISPLAY6", Map("Current",15,"Target",3),     ; U2412M (right)
							 "\\.\DISPLAY7", Map("Current",15,"Target",3))     ; U2412M (left)

; start the monitor:
#Include Switch_monitor_input_on_KVM_disconnect.ahk
