//
//  BluetoothModel.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/25/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation

protocol BluetoothModelDelegate {
    func bluetoothNotifier(macAddress: String)
}

class BluetoothModel {
    
    let delegate: BluetoothModelDelegate
    
    init(delegate: BluetoothModelDelegate) {
        self.delegate = delegate
    }
}
