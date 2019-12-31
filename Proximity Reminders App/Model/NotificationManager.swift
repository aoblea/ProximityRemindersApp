//
//  NotificationManager.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/27/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UserNotifications
import CoreLocation

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
  // MARK: - Properties
  
  static let notificationManager = NotificationManager()
  private let center = UNUserNotificationCenter.current()
  
  // TODO: - present an alert to the user saying that notification won't work unless authorization has changed.
  private func requestAuthorization() {
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    center.requestAuthorization(options: options) { (didAllow, error) in
      if didAllow == false {
        print("User denied notifications.")
      }
    }
  }
  
  func checkAuthorization() {
    center.getNotificationSettings { (notificationSettings) in
      switch notificationSettings.authorizationStatus {
      case .authorized:
        return
      case .denied, .notDetermined, .provisional:
        self.requestAuthorization()
      @unknown default:
        return
      }
    }
  }
  
  func scheduleNotification(using reminder: Reminder) {
    let content = UNMutableNotificationContent()
    content.title = reminder.title
    content.body = reminder.subtitle
    content.sound = UNNotificationSound.default
    content.badge = 1
    
    let coordinate = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
    let radius: CLLocationDistance = 50
    let id = reminder.title
    let region = CLCircularRegion(center: coordinate, radius: radius, identifier: id)
    
    if reminder.isArriving == true {
      region.notifyOnEntry = true
      region.notifyOnExit = false
    } else {
      region.notifyOnEntry = false
      region.notifyOnExit = true
    }
    
    let trigger = UNLocationNotificationTrigger(region: region, repeats: reminder.isRepeating)
    
    let identifier = reminder.title
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    center.add(request) { (error) in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      }
    }
  }
  
  func removeNotification(using reminder: Reminder) {
    center.removePendingNotificationRequests(withIdentifiers: [reminder.objectID.description])
  }
  
}
