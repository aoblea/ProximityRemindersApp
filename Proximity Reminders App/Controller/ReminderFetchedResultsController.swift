//
//  ReminderFetchedResultsController.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/25/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit
import CoreData

class ReminderFetchedResultsController: NSFetchedResultsController<Reminder>, NSFetchedResultsControllerDelegate {

  private let tableView: UITableView
  
  init(fetchRequest: NSFetchRequest<Reminder>, managedObjectContext context: NSManagedObjectContext, sectionNameKeyPath: String? = nil, cacheName name: String? = nil, tableView: UITableView) {
    self.tableView = tableView
    super.init(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    self.delegate = self
    
    tryFetch()
  }
  
  func tryFetch() {
    do {
      try performFetch()
    } catch {
      print("Unresolved error: \(error.localizedDescription)")
    }
  }
  
  // MARK: - Fetched results controller delegate
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      guard let newIndexPath =  newIndexPath else { return }
      tableView.insertRows(at: [newIndexPath], with: .automatic)
    case .delete:
      guard let indexPath = indexPath else { return }
      tableView.deleteRows(at: [indexPath], with: .automatic)
    case .update, .move:
      guard let indexPath = indexPath else { return }
      tableView.reloadRows(at: [indexPath], with: .automatic)
    default:
      return
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }

}
