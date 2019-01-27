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
    private var bluetoothModel: BluetoothModelType!
    private let databaseService = DatabaseServiceImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colorLayer = CAShapeLayer()
        colorLayer.masksToBounds = true
        colorLayer.backgroundColor = NSColor.green.cgColor
        button.layer?.addSublayer(colorLayer)
        
        bluetoothModel = BluetoothModelImpl(delegate: self, databaseService: databaseService)
        
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
        // Show trusted
        let showTrustedItem = NSMenuItem(title: "Show trusted", action: #selector(showTrustedAction), keyEquivalent: "")
        showTrustedItem.target = self
        statusBarMenu.addItem(showTrustedItem)
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
    
    enum AlertType {
        case info(message: String)
        case paired(devices: [BluetoothDeviceEntity])
        case trusted(devices: [BluetoothDeviceEntity])
    }
    
    // MARK: - Alerts
    
    /// List of paired devices alert
    ///
    /// - Parameter devices: trusted devices from list
    private func createAlert(with type: AlertType) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        var messageText = ""
        
        switch type {
        case .info(let message):
            alert.messageText = message
            alert.runModal()
        case .paired(let devices):
            alert.messageText = "Add this devices?"
            alert.addButton(withTitle: "Ok")
            alert.addButton(withTitle: "Cancel")
            devices.forEach { device in
                let name = device.name ?? device.macAddress
                messageText = messageText + "\n\(name)"
            }
            alert.informativeText = messageText
            let responseTag: NSApplication.ModalResponse = alert.runModal()
            switch responseTag {
            case .alertFirstButtonReturn: perform(#selector(okAction))
            default: break
            }
        case .trusted(let devices):
            alert.messageText = "Trusted devices"
            alert.addButton(withTitle: "Ok")
            devices.forEach { device in
                let name = device.name ?? device.macAddress
                messageText = messageText + "\n\(name)"
            }
            alert.informativeText = messageText
            alert.runModal()
        }
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
    
    @objc func quickAddToTrustedAction(_ sender: Any?) {
        guard let pairedDevices = bluetoothModel.achievePairedDevices() else {
            createAlert(with: .info(message: "There are no paired devices"))
            return
        }
        createAlert(with: .paired(devices: pairedDevices))
    }
    
    @objc func showTrustedAction() {
        createAlert(with: .trusted(devices: bluetoothModel.showTrustedDevices()))
    }
    
    @objc func okAction() {
        bluetoothModel.quickAddPairedToTrusted()
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

