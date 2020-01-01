//
//  RemindersListViewController.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/23/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit
import CoreData

/// Display a list of reminders
class RemindersListViewController: UITableViewController {
  // MARK: - Properties
  
  private let context = CoreDataStack.sharedInstance.managedObjectContext
  lazy var datasource: RemindersListDataSource = {
    return RemindersListDataSource(fetchRequest: Reminder.fetchRequest(), managedObjectContext: self.context, tableView: self.tableView)
  }()
  lazy var delegate: RemindersListDelegate = {
    return RemindersListDelegate()
  }()
  
  // MARK: - Viewdidload
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupUI()
  }
  
  func setupTableView() {
    self.tableView.dataSource = datasource
    self.tableView.delegate = delegate
  }
  
  func setupUI() {
    view.backgroundColor = UIColor.Theme.charcoal
    navigationController?.navigationBar.barTintColor = UIColor.Theme.charcoal
    navigationController?.navigationBar.tintColor = UIColor.Theme.turquoise
    
    title = "Reminders"
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Theme.turquoise]
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Theme.turquoise]
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "createReminder" {
      guard let addReminderVC = segue.destination as? AddReminderViewController else {
        return presentAlert(title: "Segue Error: \(segue.destination)", message: "Destination is nil")
      }
      addReminderVC.context = self.context
    } else if segue.identifier == "editReminder" {
      guard let addReminderVC = segue.destination as? AddReminderViewController, let indexPath = tableView.indexPathForSelectedRow else {
        return presentAlert(title: "Segue Error: \(segue.destination)", message: "Destination is nil")
      }
      addReminderVC.reminder = datasource.selectedReminder(from: indexPath)
      addReminderVC.context = self.context
    }
  }
  
}
