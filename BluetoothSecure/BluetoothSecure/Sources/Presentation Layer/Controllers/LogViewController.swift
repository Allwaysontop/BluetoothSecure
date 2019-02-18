//
//  LogViewController.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 2/18/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Cocoa

class FlippedView: NSView {
  override var isFlipped: Bool { return true }
}

class LogViewController: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createLogView()
  }
  
  func createLogView() {
    guard let results = Logger().readFromFile(Constants.Logger.fileName), !results.isEmpty else {
      return
    }
    var previousTextFieldFrame = CGRect(x: 10, y: 20, width: self.view.bounds.width - 20 * 2, height: 20)
    let documentView = FlippedView(frame: previousTextFieldFrame)
    let scrollView = NSScrollView(frame: self.view.bounds)
    scrollView.documentView = documentView
    self.view.addSubview(scrollView)
    
    for item in results {
      let textField = NSTextField(string: item)
      textField.frame = CGRect(origin: CGPoint(x: previousTextFieldFrame.origin.x,
                                               y: previousTextFieldFrame.origin.y + 20),
                               size: previousTextFieldFrame.size)
      previousTextFieldFrame = textField.frame
      textField.isEditable = false
      textField.drawsBackground = false
      textField.isSelectable = false
      documentView.frame.size = CGSize(width: documentView.frame.width, height: documentView.frame.height + 20)
      documentView.addSubview(textField)
    }
    scrollView.documentView?.scroll(.zero)
  }
}
