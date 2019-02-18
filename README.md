# BluetoothSecure

Main idea - secure income bluetooth connection for you mac. Maybe you don't know, but some devices (Samsung for example) could connect to the mac without any permission and pairing process O_O

What is done:
1. Fetch connected/paired devices
2. Store trusted (already paired) devices to the database (CoreData) with 'quick option'.
3. Status bar menu
4. Monitoring income connection
5. Show alert if some device connected but not in trusted list.
6. Show trusted
7. Delete trusted

What I want to create but stuck:
1. Sound to the NSAlert
2. DISCONNECT distrustful device (there is only one way to disconnect peripheral devices. Need to scan peripheral, get device, connect to it and then only disconnect). Weird thing, I know. At first - there could not be those device, because of 'non discoverable' mode from hackers device. At second - scanPeripheral method returns unique ID unlike IOBluetoothDevice.pairedDevices() that returns mac address and name of the device.
