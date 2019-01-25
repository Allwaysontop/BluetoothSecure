//
//  ViewController.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/18/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Cocoa
import IOBluetooth
import CoreBluetooth

class ViewController: NSViewController {

    @IBOutlet weak var button: NSButton!
    
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let manager = CBCentralManager()
    private let statusBarMenu = NSMenu()
    
//    var peripheral: CBPeripheral!
    private let bt = BluetoothDevices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colorLayer = CAShapeLayer()
        colorLayer.masksToBounds = true
        colorLayer.backgroundColor = NSColor.green.cgColor
        button.layer?.addSublayer(colorLayer)
        manager.delegate = self
        
        if let button = statusBarItem.button {
            button.image = #imageLiteral(resourceName: "status bar icon")
            button.action = #selector(togglePopoverAction)
            constructMenu()
        }
    }

    override var representedObject: Any? {
        didSet {
            print("")
        }
    }
    
    // MARK: - Private
    private func constructMenu() {
        let startItem = NSMenuItem(title: "Start monitoring", action: #selector(startMonitoringAction), keyEquivalent: "S")
        startItem.target = self
        statusBarMenu.addItem(startItem)
        statusBarMenu.addItem(NSMenuItem.separator())
        let stopItem = NSMenuItem(title: "Stop monitoring", action: #selector(stopMonitoringAction), keyEquivalent: "T")
        stopItem.target = self
        statusBarMenu.addItem(stopItem)
        
        statusBarMenu.delegate = self

        statusBarItem.menu = statusBarMenu
    }
    
    class BluetoothDevices {
        
        func register() {
            IOBluetoothDevice.register(forConnectNotifications: self, selector: #selector(connected))
        }
        
        func pairedDevices() {
            print("Bluetooth devices:")
            guard let devices = IOBluetoothDevice.pairedDevices() else {
                print("No devices")
                return
            }
            
            for item in devices {
                if let device = item as? IOBluetoothDevice {
                    print("Name: \(device.name)")
                    print("Paired?: \(device.isPaired())")
                    print("Connected?: \(device.isConnected())")
                    print("Address String?: \(device.addressString)")
                }
            }
        }
        
        @objc func connected(_ sender: IOBluetoothUserNotification) {
            pairedDevices()
        }
    }
    
    private func startMonitoringBluetoohConnections() {
        bt.register()
//        bt.pairedDevices()
//        manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    private func stopMonitoringBluetoohConnections() {
        
    }

    // MARK: - Selectors
    
    @objc func startMonitoringAction() {
        startMonitoringBluetoohConnections()
    }
    
    @objc func stopMonitoringAction() {
        stopMonitoringBluetoohConnections()
    }
    
    @objc func togglePopoverAction(_ sender: Any?) {
        
    }
    
    // MARK: - Actions

    @IBAction func test(_ sender: Any) {
        NSApp.terminate(self)
    }
}

extension ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is On")
        case .poweredOff:
            print("Bluetooth is Off")
        case .resetting:
            break
        case .unauthorized:
            break
        case .unsupported:
            break
        case .unknown:
            break
        }
    }
    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//
//        central.stopScan()
//        self.peripheral = peripheral
//        central.connect(self.peripheral, options: nil)
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("")
//    }
    
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("centralManager didConnect \(peripheral.name)")
//    }
//
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print("centralManager didFailToConnect \(peripheral.name), error \(error?.localizedDescription)")
//    }
//
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print("centralManager didDisconnectPeripheral \(peripheral.name)")
//    }
}

extension ViewController: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menu opens")
    }
}

