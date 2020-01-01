//
//  LocationManager.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/31/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
  
  static let locationManager = LocationManager()
  private let manager = CLLocationManager()

  func requestAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .denied, .notDetermined:
      manager.requestAlwaysAuthorization()
    case .authorizedAlways, .authorizedWhenInUse, .restricted:
      return
    default:
      return
    }
  }
}
