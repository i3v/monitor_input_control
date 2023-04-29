#Requires AutoHotkey v2.0

; PC-specific constants:
; From Windows Device Manager, "Details" tab, "Device instance path" property
WATCHED_USB_DEVICE_ID := "USB\VID_05E3&PID_0610\5&18550D90&0&2"

ALL_EXPECTED_DISPLAYS := Map("\\.\DISPLAY3", Map("Current",4883,"Target",27),  ; U4320Q (center)
							 "\\.\DISPLAY1", Map("Current",3,"Target",15),     ; U2412M (left)
							 "\\.\DISPLAY2", Map("Current",3,"Target",15))     ; U2412M (right)

; start the monitor:
#Include Switch_monitor_input_on_KVM_disconnect.ahk
