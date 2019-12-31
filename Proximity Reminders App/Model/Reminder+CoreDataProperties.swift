//
//  Reminder+CoreDataProperties.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/25/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//
//

import Foundation
import CoreData

public class Reminder: NSManagedObject {

}

extension Reminder {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
    let request = NSFetchRequest<Reminder>(entityName: "Reminder")
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
    request.sortDescriptors = [sortDescriptor]
    
    return request
  }

  @NSManaged public var address: String
  @NSManaged public var creationDate: Date
  @NSManaged public var isRepeating: Bool
  @NSManaged public var subtitle: String
  @NSManaged public var title: String
  @NSManaged public var latitude: Double
  @NSManaged public var longitude: Double
  @NSManaged public var isArriving: Bool

}
