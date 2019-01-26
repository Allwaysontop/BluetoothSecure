//
//  AppDelegate.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/18/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var windowController: NSWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        windowController = storyboard.instantiateController(withIdentifier: "StartWindow") as? NSWindowController
        // If you need to show window
//        windowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

