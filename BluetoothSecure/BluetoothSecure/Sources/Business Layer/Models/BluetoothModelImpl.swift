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

protocol BluetoothModelDelegate: class {
  func bluetoothNotifier(devices: [BluetoothDeviceEntity])
  func bluetoothNotifierEmpty()
}

class BluetoothModelImpl: BluetoothModelType {
  
  weak var delegate: BluetoothModelDelegate?
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
  
  func fetchPairedDevices() -> [IOBluetoothDevice] {
    print("Bluetooth devices:")
    guard let devices = IOBluetoothDevice.pairedDevices() else {
      print("No devices")
      return []
    }
    
    var bluetoothDevices: [IOBluetoothDevice] = []
    
    for item in devices {
      if let device = item as? IOBluetoothDevice {
        bluetoothDevices.append(device)
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
    guard let paired = achievePairedDevices() else {
      return
    }
    addToTrusted(devices: paired)
  }
  
  func achievePairedDevices() -> [BluetoothDeviceEntity]? {
    let bluetoothDevicesIOPaired = fetchPairedDevices().filter({ $0.isPaired() })
    let paired = bluetoothDevicesIOPaired.map({ BluetoothDeviceEntity.init(bluetoothDeviceIO: $0) })
    return paired
  }
  
  func showTrustedDevices() -> [BluetoothDeviceEntity] {
    return databaseService.fetchAll()
  }
  
  func deleteAllTrustedDevices() {
    databaseService.deleteAll()
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
      checkWithTrustedDevices()
    }
  }
  
  // MARK: - Private
  
  private func checkWithTrustedDevices() {
    let trustedDevices = databaseService.fetchAll()
    
    let bluetoothDevicesIO = fetchPairedDevices()
    if bluetoothDevicesIO.isEmpty {
      delegate?.bluetoothNotifierEmpty()
      return
    }
    let cachedDevices = bluetoothDevicesIO.map({ BluetoothDeviceEntity.init(bluetoothDeviceIO: $0) })
    
    let notTrusted = Array(Set<BluetoothDeviceEntity>(cachedDevices).subtracting(Set(trustedDevices)))
    
    if !notTrusted.isEmpty {
      delegate?.bluetoothNotifier(devices: notTrusted)
    }
  }
}
