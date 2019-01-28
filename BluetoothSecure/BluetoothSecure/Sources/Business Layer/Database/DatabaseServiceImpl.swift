//
//  DatabaseServiceImpl.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/26/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation
import CoreData

class DatabaseServiceImpl: DatabaseServiceType {
    
    private lazy var databaseCore = DatabaseCore()
    
    func fetchAll() -> [BluetoothDeviceEntity] {
        let request: NSFetchRequest<BluetoothDevice> = BluetoothDevice.fetchRequest()
        var result: [BluetoothDeviceEntity] = []
        
        do {
            let pureResult = try databaseCore.persistentContainer.viewContext.fetch(request)
            result = pureResult.map(BluetoothDeviceEntity.init)
        } catch {
            assertionFailure("Database error while fetch: \(error.localizedDescription)")
        }
        
        return result
    }
    
    func achieveDevice(by macAddress: String) -> BluetoothDeviceEntity? {
        let request: NSFetchRequest<BluetoothDevice> = BluetoothDevice.fetchRequest()
        let predicate = NSPredicate(format: "macAddress == %@", macAddress)
        request.predicate = predicate
        
        var device: BluetoothDeviceEntity?
        
        do {
            guard let deviceManaged = try databaseCore.persistentContainer.viewContext.fetch(request).first else {
                return device
            }
            device = BluetoothDeviceEntity(managedObject: deviceManaged)
        } catch {
            assertionFailure("Database error while achieve by macAddress \(macAddress): \(error.localizedDescription)")
        }
        return device
    }
    
    /// Save devices to database on background, applying merge
    ///
    /// - Parameter devices: devices to store
    func save(devices: [BluetoothDeviceEntity]) {
        let fetchRequest: NSFetchRequest<BluetoothDevice> = BluetoothDevice.fetchRequest()
        databaseCore.persistentContainer.performBackgroundTask { (context) in
            context.mergePolicy = NSMergePolicy.overwrite
            do {
                let savedDevices = try context.fetch(fetchRequest)
                let savedConvertedDevices = savedDevices.map(BluetoothDeviceEntity.init)
                
                var difference: [BluetoothDeviceEntity] = []
                // If savedConvertedDevices are not empty - apply subtracting
                if !savedConvertedDevices.isEmpty {
                    // Returns devices that is not contain in saved, write it to difference and then to database
                    difference = Array(Set<BluetoothDeviceEntity>(devices).subtracting(Set(savedConvertedDevices)))
                } else {
                    // If savedConvertedDevices are empty, subtracting will always return 0 that is not correct,
                    // so just write it to difference
                    difference = devices
                }
                
                _ = difference.map({ BluetoothDevice(model: $0, context: context) })
                try context.save()
            } catch {
                assertionFailure("Database error while saving: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAll() {
        let request: NSFetchRequest = BluetoothDevice.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try databaseCore.persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            assertionFailure("Database error while deleting: \(error.localizedDescription)")
        }
    }
}
