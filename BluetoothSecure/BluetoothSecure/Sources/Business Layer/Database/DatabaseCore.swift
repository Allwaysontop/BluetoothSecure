//
//  DatabaseCore.swift
//  BluetoothSecure
//
//  Created by Kramarchuk Kyrylo on 1/26/19.
//  Copyright © 2019 Kramarchuk Kyrylo. All rights reserved.
//

import Foundation
import CoreData

/// Core class that works with basic CoreData needs
/// - load persistent store
/// - save context
class DatabaseCore {
    
    /// Get persistent container and loads stores (BluetoothSecure)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BluetoothSecure")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print("persistentContainer error: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    /// Save current CoreData state if it has changes
    func saveContext() {
        let viewContext = persistentContainer.viewContext
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                fatalError("Unexpected error while saving context: \(error.localizedDescription)")
            }
        }
    }
}
