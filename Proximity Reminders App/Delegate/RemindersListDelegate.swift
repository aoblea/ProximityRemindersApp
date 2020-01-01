//
//  RemindersListDelegate.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/30/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class RemindersListDelegate: NSObject, UITableViewDelegate {
  // MARK: - Tableview delegate methods

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
    
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
}
