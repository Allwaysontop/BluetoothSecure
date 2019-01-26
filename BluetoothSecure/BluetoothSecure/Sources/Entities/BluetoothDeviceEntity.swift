//
//  BluetoothDeviceEntity.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/26/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation
import IOBluetooth

struct BluetoothDeviceEntity {
    let macAddress: String
    let name: String?
    
    init(managedObject: BluetoothDevice) {
        self.macAddress = managedObject.macAddress
        self.name = managedObject.name
    }
    
    init(bluetoothDeviceIO: IOBluetoothDevice) {
        self.macAddress = bluetoothDeviceIO.addressString
        self.name = bluetoothDeviceIO.name
    }
}

extension BluetoothDeviceEntity: Equatable {
    
    public static func == (lhs: BluetoothDeviceEntity, rhs: BluetoothDeviceEntity) -> Bool {
        return lhs.macAddress == rhs.macAddress &&
        lhs.name == rhs.name
    }
}

extension BluetoothDeviceEntity: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(macAddress)
    }
}
