//
//  RemindersListDataSource.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/25/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit
import CoreData

class RemindersListDataSource: NSObject, UITableViewDataSource {
  // MARK: - Properties
  
  private let tableView: UITableView
  private var context: NSManagedObjectContext!
  private let request: NSFetchRequest<Reminder>
  private let notificationManager = NotificationManager()
  
  lazy var fetchedResultsController: ReminderFetchedResultsController = {
    return ReminderFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, tableView: self.tableView)
  }()
  
  // MARK: - Init method
  
  init(fetchRequest: NSFetchRequest<Reminder>, managedObjectContext: NSManagedObjectContext, tableView: UITableView) {
    self.request = fetchRequest
    self.context = managedObjectContext
    self.tableView = tableView
  }
  
  // MARK: - Table view data source methods

  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = fetchedResultsController.sections?[section] else { return 0 }
    return section.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let reminder = fetchedResultsController.object(at: indexPath)
    context.delete(reminder)
    notificationManager.removeNotification(using: reminder)
    context.saveChanges()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderViewCell
    
    let reminder = fetchedResultsController.object(at: indexPath)
    cell.configure(using: reminder)
    
    return cell
  }
  
  // MARK: - Helper method
  
  func selectedReminder(from indexPath: IndexPath) -> Reminder {
    return fetchedResultsController.object(at: indexPath)
  }
  
}
