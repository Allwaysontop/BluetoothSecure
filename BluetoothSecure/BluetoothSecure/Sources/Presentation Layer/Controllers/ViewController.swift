//
//  ViewController.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/18/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var button: NSButton!
    
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let statusBarMenu = NSMenu()
    private var bluetoothModel: BluetoothModel!
    private let databaseService = DatabaseServiceImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colorLayer = CAShapeLayer()
        colorLayer.masksToBounds = true
        colorLayer.backgroundColor = NSColor.green.cgColor
        button.layer?.addSublayer(colorLayer)
        
        bluetoothModel = BluetoothModel(delegate: self, databaseService: databaseService)
        
        if let button = statusBarItem.button {
            button.image = #imageLiteral(resourceName: "status bar icon")
            button.action = #selector(togglePopoverAction)
            constructMenu()
        }
    }

    override var representedObject: Any? {
        didSet {
            
        }
    }
    
    // MARK: - Private
    private func constructMenu() {
        // Start
        let startItem = NSMenuItem(title: "Start monitoring", action: #selector(startMonitoringAction), keyEquivalent: "S")
        startItem.target = self
        statusBarMenu.addItem(startItem)
        // Stop
        let stopItem = NSMenuItem(title: "Stop monitoring", action: #selector(stopMonitoringAction), keyEquivalent: "T")
        stopItem.target = self
        statusBarMenu.addItem(stopItem)
        // Add quick to trusted
        let quickAddToTrustedItem = NSMenuItem(title: "Add quick to trusted", action: #selector(quickAddToTrustedAction), keyEquivalent: "A")
        quickAddToTrustedItem.target = self
        statusBarMenu.addItem(quickAddToTrustedItem)
        // Separator
        statusBarMenu.addItem(NSMenuItem.separator())
        // Quit
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitAction), keyEquivalent: "Q")
        quitItem.target = self
        statusBarMenu.addItem(quitItem)
        
        statusBarMenu.delegate = self

        statusBarItem.menu = statusBarMenu
    }
    
    private func startMonitoringBluetoohConnections() {
        bluetoothModel.register()
        bluetoothModel.startMonitoring()
    }
    
    private func stopMonitoringBluetoohConnections() {
        bluetoothModel.unRegister()
        bluetoothModel.stopMonitoring()
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
    
    @objc func quitAction(_ sender: Any?) {
        NSApp.terminate(self)
    }
    
    // MARK: - Actions

    @IBAction func test(_ sender: Any) {
        
    }
}

// MARK: - BluetoothModelDelegate

extension ViewController: BluetoothModelDelegate {
    
    func bluetoothNotifier(devices: [BluetoothDeviceEntity]) {
        
    }
    
    func bluetoothNotifierEmpty() {
        
    }
}

extension ViewController: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menu opens")
    }
}

