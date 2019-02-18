//
//  LogViewController.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 2/18/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Cocoa

class LogViewController: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func createLogView() {
    let scrollView = NSScrollView(frame: self.view.bounds)
    self.view.addSubview(scrollView)
    
    
  }
}
