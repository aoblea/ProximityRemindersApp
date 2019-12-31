//
//  CoreDataStack.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/23/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  // MARK: Properties
  
  static let sharedInstance = CoreDataStack()
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Reminder")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error: \(error), \(error.userInfo)")
      }
      
      storeDescription.shouldInferMappingModelAutomatically = true
      storeDescription.shouldMigrateStoreAutomatically = true
    }
    
    return container
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let container = self.persistentContainer
    return container.viewContext
  }()
  
}

extension NSManagedObjectContext {
  
  func saveChanges() {
    if self.hasChanges {
      do {
        try save()
      } catch {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
  
}
