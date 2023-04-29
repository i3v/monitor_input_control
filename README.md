# Monitor input control
An example [ahk](AutoHotkey v2) script that switches monitor input to another PC 
using [DCC/CI](https://ru.wikipedia.org/wiki/Display_Data_Channel), 
when the USB-only KVM switch switches from this PC.

### The story
I've got two PCs on my table and three Dell monitors (2x Dell U2412M and 1x Dell U4320Q). They are connected as follows:

 * monitor1.USBC ← PC1
 * monitor1.DisplayPort ← PC2
 * monitor2.DisplayPort ← PC1
 * monitor2.DVI ← PC2
 * monitor3.DisplayPort ← PC1 
 * monitor3.DVI ← PC2

I've got a cheap "Unnlink KVM Switch USB 3.0 Model 0945" USB KVM, 
that allows to connect my mouse and keyboard to either PC1 or PC2 with a single click. 
However, it is unable to switch monitor inputs and (to my knowledge) got no API/software to monitor its state.

I hate manually switching monitor inputs with their hardware buttons (partly because they are awful). 
All 3 Dell monitors provide decent DCC/CI, allowing to control every monitor parameter without those buttons. 
However, Dell never bothered to release any software to actually utilize the DCC/CI capabilities of the Dell U2412M.
The "Dell Display Manager 1.0" 
[does not support](https://www.dell.com/community/Monitors/U2412M-is-not-compatible-with-the-DDM/m-p/4319159/highlight/true#M94155)
U2412M (newer monitors are supported and thus [DDM 2.0 command line](https://gist.github.com/nebriv/cb934a3b702346c5988f2aba5ee39f0d) could be used instead of direct DCC/CI).


### How it works
When the USB switch connects to another PC, the corresponding "Generic USB Hub"  disappears from the device tree in the  Device Manager.
The AutoHotkey [allows](https://www.autohotkey.com/boards/viewtopic.php?f=83&t=105171) to subscribe to that OS event.  

The DCC/CI commands are sent using the [Monitor-Configuration-Class](https://github.com/tigerlily-dev/Monitor-Configuration-Class). 

Only the currently active monitor is able to use the DCC/CI commands, thus the same script should be started on both PCs.  
The script would ask monitor to switch to another input when the specified USB device would be disconnected.




### How-to
1. In Windows Device Manager, use "View -> Devices by connection" to see which specific USB devices disappears when USB switch disconnects. Copy "Device instance path" property value from the "Details" tab. Use it as the `WATCHED_USB_DEVICE_ID` value in [Switch_monitor_input_on_KVM_disconnect_PC1.ahk](Switch_monitor_input_on_KVM_disconnect_PC1.ahk).  
2. Use [ClickMonitor 7.2](https://github.com/chrismah/ClickMonitorDDC7.2) "VCP codes" feature to view your monitor IDs, expected currently selected input ID and the available input IDs. Modify the [Switch_monitor_input_on_KVM_disconnect_PC1.ahk](Switch_monitor_input_on_KVM_disconnect_PC1.ahk) accordingly.
   * Another option is to use [softMCCS version 2.5.0.1093](https://web.archive.org/web/20220412004645/https://www.entechtaiwan.com/lib/softmccs.shtm).
3. Same for another PC and [Switch_monitor_input_on_KVM_disconnect_PC2.ahk](Switch_monitor_input_on_KVM_disconnect_PC2.ahk)

