//
//  BluetoothDeviceEntity.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/26/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation

struct BluetoothDeviceEntity {
    let id: Int16
    let macAddress: String
    let name: String?
    
    init(managedObject: BluetoothDevice) {
        self.id = managedObject.id
        self.macAddress = managedObject.macAddress
        self.name = managedObject.name
    }
}

extension BluetoothDeviceEntity: Equatable {
    
    public static func == (lhs: BluetoothDeviceEntity, rhs: BluetoothDeviceEntity) -> Bool {
        return lhs.id == rhs.id &&
        lhs.macAddress == rhs.macAddress &&
        lhs.name == rhs.name
    }
}
