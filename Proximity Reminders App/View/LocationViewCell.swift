//
//  LocationViewCell.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/26/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit
import MapKit

class LocationViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  func configure(using mapItem: MKMapItem) {
    nameLabel.text = mapItem.name
    addressLabel.text = mapItem.placemark.title
  }
  
}
