//
//  LoggerImpl.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 2/16/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation
import IOBluetooth

class Logger {
  
  func writeToFile(devices: [IOBluetoothDevice]) {
    var resultString = ""
    
    for device in devices {
      let date = "Date: \(Date().timeIntervalSince1970)"
      resultString.append(date)
      
      if let name = device.name {
        resultString.append("\nName: \(name)")
      }
      if let macAddress = device.addressString {
        resultString.append("\nMac address: \(macAddress)")
      }
      let parametersString: String = "\nPaired: \(device.isPaired())\nConnected: \(device.isConnected())\n\n\n"
      resultString.append(parametersString)
    }
    
    if !resultString.isEmpty {
      writeToFile(string: resultString)
    }
  }
  
  private func writeToFile(string: String) {
    // get URL to the the documents directory in the sandbox
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
    
    // add a filename
    guard let fileUrl = documentsUrl.appendingPathComponent("Connection_log.txt") else {
      return
    }
    
    // write to it
    do {
      try string.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      print(error.localizedDescription)
    }
  }
}
