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
  func bluetoothNotifier(_ model: BluetoothModelImpl, devices: [BluetoothDeviceEntity])
  func bluetoothNotifierEmpty(_ model: BluetoothModelImpl)
}

class BluetoothModelImpl: BluetoothModelType {
  
  weak var delegate: BluetoothModelDelegate?
  private var notification: IOBluetoothUserNotification?
  private let databaseService: DatabaseServiceType
  
  // MARK: - Life cycle
  
  init(delegate: BluetoothModelDelegate, databaseService: DatabaseServiceType) {
    self.delegate = delegate
    self.databaseService = databaseService
  }
  
  // MARK: - Main features
  
  func fetchPairedDevices() -> [IOBluetoothDevice]? {
    print("Bluetooth devices:")
    guard let devices = IOBluetoothDevice.pairedDevices() else {
      print("No devices")
      return nil
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
    register()
  }
  
  func stopMonitoring() {
    unRegister()
  }
  
  // MARK: - Selectors
  
  @objc func connected(_ sender: IOBluetoothUserNotification) {
    self.notification = sender
    checkWithTrustedDevices()
  }
  
  // MARK: - Private
  
  private func register() {
    IOBluetoothDevice.register(forConnectNotifications: self, selector: #selector(connected))
  }
  
  private func unRegister() {
    notification?.unregister()
  }
  
  private func checkWithTrustedDevices() {
    let trustedDevices = databaseService.fetchAll()
    
    let bluetoothDevicesIO = fetchPairedDevices()
    if bluetoothDevicesIO.isEmpty {
      delegate?.bluetoothNotifierEmpty(self)
      return
    }
    let pairedDevices = bluetoothDevicesIO.map({ BluetoothDeviceEntity.init(bluetoothDeviceIO: $0) })
    
    let notTrustedDevices = Array(Set<BluetoothDeviceEntity>(pairedDevices).subtracting(Set(trustedDevices)))
    
    if !notTrustedDevices.isEmpty {
      delegate?.bluetoothNotifier(self, devices: notTrustedDevices)
    } else {
      delegate?.bluetoothNotifierEmpty(self)
    }
  }
}
