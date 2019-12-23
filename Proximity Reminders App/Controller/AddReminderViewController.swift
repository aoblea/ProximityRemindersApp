//
//  AddReminderViewController.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/23/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit
import MapKit

class AddReminderViewController: UITableViewController {

  // MARK: - IBOutlets
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var subTextField: UITextField!
  @IBOutlet weak var setLocationButton: UIButton!
  @IBOutlet weak var alertLabel: UILabel!
  @IBOutlet weak var optionControl: UISegmentedControl!
  @IBOutlet weak var mapView: MKMapView!
  
  @IBOutlet weak var saveBarButton: UIBarButtonItem!
  
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

}
