//
//  BluetoothModelType.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/27/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation
import IOBluetooth

protocol BluetoothModelType {
    func startMonitoring()
    func stopMonitoring()
    func fetchPairedDevices() -> [IOBluetoothDevice]?
    func showTrustedDevices() -> [BluetoothDeviceEntity]
    func achievePairedDevices() -> [BluetoothDeviceEntity]?
    func addToTrusted(devices: [BluetoothDeviceEntity])
    func quickAddPairedToTrusted()
    func deleteAllTrustedDevices()
}
