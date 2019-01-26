//
//  BluetoothDevice+CoreDataClass.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/26/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BluetoothDevice)
public class BluetoothDevice: NSManagedObject {
    
    convenience init?(model: BluetoothDeviceEntity, context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "BluetoothDevice", in: context) else {
            return nil
        }
        
        self.init(entity: entity, insertInto: context)
        
        self.id = model.id
        self.macAddress = model.macAddress
        self.name = model.name
    }
}
