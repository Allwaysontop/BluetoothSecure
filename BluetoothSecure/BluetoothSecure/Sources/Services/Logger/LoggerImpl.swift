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
  
  func writeToFile(_ fileName: String, devices: [IOBluetoothDevice]) {
    var resultString = ""
    
    for device in devices {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
      let date = formatter.string(from: Date())
      resultString.append("Date: \(date)")
      
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
      writeToFile(fileName, valueString: resultString)
    }
  }
  
  func deleteLog(_ fileName: String) -> Bool {
    guard let fileUrl = getFilePath(by: fileName) else {
      return false
    }
    
    do {
      try FileManager.default.removeItem(at: fileUrl)
      return true
    } catch {
      print(error.localizedDescription)
      return false
    }
  }
  
  func readFromFile(_ fileName: String) -> [String]? {
    guard let fileUrl = getFilePath(by: fileName) else {
      return nil
    }
    
    do {
      let result = try String(contentsOf: fileUrl)
      let results = result.components(separatedBy: CharacterSet.newlines)
      return results
    } catch {
        return nil
    }
  }
  
  // MARK: - Privage
  
  private func writeToFile(_ fileName: String, valueString: String) {
    guard let fileUrl = getFilePath(by: fileName) else {
      return
    }
    
    // write to it
    do {
      try valueString.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func getFilePath(by name: String) -> URL? {
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
    
    // add a filename
    guard let fileUrl = documentsUrl.appendingPathComponent("\(name).txt") else {
      return nil
    }
    return fileUrl
  }
}
