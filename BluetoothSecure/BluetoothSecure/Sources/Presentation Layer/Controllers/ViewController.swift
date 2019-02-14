//
//  ViewController.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/18/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  // MARK: - Property
  private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  private let statusBarMenu = NSMenu()
  private var bluetoothModel: BluetoothModelType!
  private let databaseService = DatabaseServiceImpl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let colorLayer = CAShapeLayer()
    colorLayer.masksToBounds = true
    colorLayer.backgroundColor = NSColor.green.cgColor
    
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
    // Delete trusted
    let deleteTrustedItem = NSMenuItem(title: "Delete trusted", action: #selector(deleteTrustedAction), keyEquivalent: "")
    deleteTrustedItem.target = self
    statusBarMenu.addItem(deleteTrustedItem)
    // Separator
    statusBarMenu.addItem(NSMenuItem.separator())
    // Quit
    let quitItem = NSMenuItem(title: "Quit", action: #selector(quitAction), keyEquivalent: "Q")
    quitItem.target = self
    statusBarMenu.addItem(quitItem)
    statusBarItem.menu = statusBarMenu
  }
  
  private func startMonitoringBluetoohConnections() {
    bluetoothModel.startMonitoring()
  }
  
  private func stopMonitoringBluetoohConnections() {
    bluetoothModel.stopMonitoring()
  }
  
  enum AlertType {
    case info(message: String)
    case paired(devices: [BluetoothDeviceEntity])
    case trusted(devices: [BluetoothDeviceEntity])
    case notTrusted(devices: [BluetoothDeviceEntity])
  }
  
  // MARK: - Alerts
  
  /// List of paired devices alert
  ///
  /// - Parameter devices: trusted devices from list
  private func createAlert(with type: AlertType) {
    let alert = NSAlert()
    var messageText = ""
    
    switch type {
    case .info(let message):
      alert.alertStyle = .informational
      alert.messageText = message
      alert.runModal()
    case .paired(let devices):
      alert.alertStyle = .warning
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
      alert.alertStyle = .informational
      alert.messageText = "Trusted devices"
      devices.forEach { device in
        let name = device.name ?? device.macAddress
        messageText = messageText + "\n\(name)"
      }
      alert.informativeText = messageText
      alert.runModal()
    case .notTrusted(let devices):
      alert.alertStyle = .critical
      alert.messageText = "ATTENTION! Not trusted devices"
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
    let trustedDevices = bluetoothModel.showTrustedDevices()
    if trustedDevices.isEmpty {
      createAlert(with: .info(message: "There are no trusted devices"))
    } else {
      createAlert(with: .trusted(devices: trustedDevices))
    }
  }
  
  @objc func deleteTrustedAction() {
    bluetoothModel.deleteAllTrustedDevices()
  }
  
  @objc func okAction() {
    bluetoothModel.quickAddPairedToTrusted()
  }
  
  @objc func quitAction(_ sender: Any?) {
    NSApp.terminate(self)
  }
}

// MARK: - BluetoothModelDelegate

extension ViewController: BluetoothModelDelegate {
  
  func bluetoothNotifierEmpty(_ model: BluetoothModelImpl) {
    createAlert(with: .info(message: "Some device connected but not defined"))
  }
  
  func bluetoothNotifier(_ model: BluetoothModelImpl, devices: [BluetoothDeviceEntity]) {
    createAlert(with: .notTrusted(devices: devices))
  }
}

