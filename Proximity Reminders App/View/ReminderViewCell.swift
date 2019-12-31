//
//  ReminderViewCell.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/26/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class ReminderViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  func configure(using reminder: Reminder) {
    titleLabel.text = reminder.title
    addressLabel.text = reminder.address
  }
  
}
