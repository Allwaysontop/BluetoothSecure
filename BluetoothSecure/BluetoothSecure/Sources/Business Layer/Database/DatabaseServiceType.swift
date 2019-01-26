//
//  DatabaseServiceType.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/26/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation

protocol DatabaseServiceType {
    func fetchAll() -> [BluetoothDeviceEntity]
    func achieveDevice(by macAddress: String) -> BluetoothDeviceEntity?
    func save(devices: [BluetoothDeviceEntity])
}
