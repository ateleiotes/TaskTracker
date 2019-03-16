//
//  CoreDataStack.swift
//  TaskTracker
//
//  Created by Margo on 2019-03-14.
//  Copyright © 2019 Gbc. All rights reserved.
//
import Foundation
import CoreData

class CoreDataStack {
    
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "TaskTracker")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
        }
        return container
    }
    
    // Managed context responsibility - save/delete collection of objects
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}

