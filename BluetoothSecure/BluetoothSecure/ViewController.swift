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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colorLayer = CAShapeLayer()
        colorLayer.masksToBounds = true
        colorLayer.backgroundColor = NSColor.green.cgColor
        button.layer?.addSublayer(colorLayer)
        
        
        if let button = statusBarItem.button {
            button.image = #imageLiteral(resourceName: "status bar icon")
            constructMenu()
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - Private
    private func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Start monitoring", action: #selector(startMonitoringAction), keyEquivalent: "S"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Stop monitoring", action: #selector(stopMonitoringAction), keyEquivalent: "T"))

        statusBarItem.menu = menu
    }
    
    private func startMonitoringBluetoohConnections() {
        
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
    
    // MARK: - Actions

    @IBAction func test(_ sender: Any) {
        NSApp.terminate(self)
    }
}

