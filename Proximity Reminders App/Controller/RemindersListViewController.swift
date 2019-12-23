//
//  RemindersListViewController.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/23/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class RemindersListViewController: UITableViewController {

  @IBOutlet weak var addBarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.Theme.charcoal
    navigationController?.navigationBar.barTintColor = UIColor.Theme.slateBlue
    navigationController?.navigationBar.tintColor = UIColor.Theme.turquoise
    title = "Reminders"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

}
