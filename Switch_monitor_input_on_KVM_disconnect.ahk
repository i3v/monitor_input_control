#Requires AutoHotkey v2.0
#Include Monitor_class.ahk  ; https://github.com/tigerlily-dev/Monitor-Configuration-Class
Persistent
; This script should not be executed directly.
; Instead, it should be included to a script that defines ALL_EXPECTED_DISPLAYS and WATCHED_USB_DEVICE_ID constants.

/*
	Known available inputs:
		* Dell U2412M: 1, 3, 15
		* Dell U4320Q: 27, 15, 19, 17, 18

	Tested values (AHK):
		* Dell U4320Q:
			* 27 -> 6939 = 0x1B1B (USB-C)
			* 15 (DisplayPort1)
			* 19 -> 4883 = 0x1313 (DisplayPort2)
		* Dell U2112M:
			* 15 (DisplayPort)
			* 3 (DVI-D)
*/


SINK_OnObjectReady(Obj, *)
{
	TI := Obj.TargetInstance
	Time := FormatTime(A_Now, "HH:mm:ss")
	; Log down all devices being disconnected.
	OutputDebug(Format('| Dev.disconnect. | {1: 8} | DeviceID="{2:}",  Descr="{3:}",  Manufact="{4:}",  Name="{5:}",  PNPClass="{6:}"`r`n',  Time, TI.DeviceID, TI.Description, TI.Manufacturer, TI.Name, TI.PNPClass))

	if TI.DeviceID = WATCHED_USB_DEVICE_ID   ; the device to watch for
	{
		OutputDebug("The USB KVM switch just disconnected. Switching monitor inputs. `r`n")
		connect_monitors_to_another_pc()
	}
}

connect_monitors_to_another_pc()
{   ; First checks if all monitors are connected to this PC as expected.
	; Next, ask them to connect to another PC.

	m := Monitor()
	mi := m.GetInfo()

	all_connected_as_expected := True
	error_str := ""
	for mii in mi
	{
		display := mii["Name"]
		try	{
			brightness := m.GetVCPFeatureAndReply(0x10, display)
			input := m.GetVCPFeatureAndReply(0x60, display)
			OutputDebug("Monitor_name=" display " brightness=" brightness["Current"] " input=" input["Current"] "`r`n" )
		}
		catch Error as err {
				all_connected_as_expected := false
				error_str := error_str 'Monitor "' display '" DCS/CI "get" command failed: "' err.Message '"`r`n'
		}
		else {
			all_connected_as_expected := all_connected_as_expected and ALL_EXPECTED_DISPLAYS.Has(display) and ALL_EXPECTED_DISPLAYS[display]["Current"] == input["Current"]
		}
	}

	if all_connected_as_expected
	{
		OutputDebug("Monitors are connected as expected, switching them to another inputs")
		for display, inputs in ALL_EXPECTED_DISPLAYS
			m.SetVCPFeature(0x60, inputs["Target"], display)
	}
	else
	{
		OutputDebug("Monitors are NOT connected as expected")
		MsgBox('Monitors are NOT connected  as expected. Errors list:' error_str)
	}
}


; Set up an OS notification for a USB device removal, to trigger monitor's input change.
; https://www.autohotkey.com/boards/viewtopic.php?f=83&t=105171
WMI := ComObjGet("winmgmts:")
ComObjConnect(Sink := ComObject("WbemScripting.SWbemSink"), "SINK_")
Command := "WITHIN 1 WHERE TargetInstance ISA 'Win32_PnPEntity'"
WMI.ExecNotificationQueryAsync(Sink, "SELECT * FROM __InstanceDeletionEvent " . Command)
OutputDebug("USB event monitor started`r`n")
