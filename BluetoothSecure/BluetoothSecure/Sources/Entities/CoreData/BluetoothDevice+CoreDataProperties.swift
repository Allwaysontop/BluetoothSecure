//
//  BluetoothDevice+CoreDataProperties.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/26/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//
//

import Foundation
import CoreData


extension BluetoothDevice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BluetoothDevice> {
        return NSFetchRequest<BluetoothDevice>(entityName: "BluetoothDevice")
    }

    @NSManaged public var id: Int16
    @NSManaged public var macAddress: String!
    @NSManaged public var name: String?

}
