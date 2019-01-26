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
    
    func save(devices: [BluetoothDeviceEntity]) {
        databaseCore.persistentContainer.performBackgroundTask { (context) in
            context.mergePolicy = NSMergePolicy.overwrite
            _ = devices.map({ BluetoothDevice(model: $0, context: context) })
            
            do {
                try context.save()
            } catch {
                assertionFailure("Database error while saving: \(error.localizedDescription)")
            }
        }
    }
}
