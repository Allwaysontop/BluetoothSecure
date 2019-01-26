//
//  BluetoothModel.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/25/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation
import IOBluetooth
import CoreBluetooth

protocol BluetoothModelDelegate {
    func bluetoothNotifier(macAddress: String)
}

class BluetoothModel {
    
    let delegate: BluetoothModelDelegate
    private var isMonitoring: Bool = false
    private var notification: IOBluetoothUserNotification?
    private let databaseService: DatabaseServiceType
    
    // MARK: - Life cycle
    
    init(delegate: BluetoothModelDelegate, databaseService: DatabaseServiceType) {
        self.delegate = delegate
        self.databaseService = databaseService
    }
    
    // MARK: - Registration for notifications
    
    func register() {
        IOBluetoothDevice.register(forConnectNotifications: self, selector: #selector(connected))
    }
    
    func unRegister() {
        notification?.unregister()
    }
    
    // MARK: - Main features
    
    func fetchCachedDevices() -> [IOBluetoothDevice]? {
        print("Bluetooth devices:")
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            print("No devices")
            return nil
        }
        
        var bluetoothDevices: [IOBluetoothDevice]?

        for item in devices {
            if let device = item as? IOBluetoothDevice {
                bluetoothDevices?.append(device)
                print("Name: \(device.name)")
                print("Paired?: \(device.isPaired())")
                print("Connected?: \(device.isConnected())")
                print("Address String?: \(device.addressString)")
            }
        }
        
        return bluetoothDevices
    }
    
    func addToTrusted(devices: [BluetoothDeviceEntity]) {
        databaseService.save(devices: devices)
    }
    
    func quickAddPairedToTrusted() {
        guard let bluetoothDevicesIOPaired = fetchCachedDevices()?.filter({ $0.isPaired() }) else {
            return
        }
        let paired = bluetoothDevicesIOPaired.map({ BluetoothDeviceEntity.init(bluetoothDeviceIO: $0) })
        addToTrusted(devices: paired)
    }
    
    // MARK: - Monitoring
    
    func startMonitoring() {
        isMonitoring = true
    }
    
    func stopMonitoring() {
        isMonitoring = false
    }
    
    // MARK: - Selectors
    
    @objc func connected(_ sender: IOBluetoothUserNotification) {
        self.notification = sender
        
        if isMonitoring {
            checkWithSavedDevices()
        }
    }
    
    // MARK: - Private
    
    private func checkWithSavedDevices() {
        
    }
}
