//
//  AddReminderViewController.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/23/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

/// Create a new / edit a reminder
class AddReminderViewController: UITableViewController {
  // MARK: - IBOutlets
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var subTextField: UITextField!
  @IBOutlet weak var setLocationButton: UIButton!
  @IBOutlet weak var alertLabel: UILabel!
  @IBOutlet weak var optionControl: UISegmentedControl!
  @IBOutlet weak var mapView: MKMapView!
  
  // MARK: - Properties
  
  var context: NSManagedObjectContext! // passed context from reminderslist segue
  var reminder: Reminder? // for editing a selected row from reminder list
  var isRepeating: Bool? {
    didSet {
      self.isRepeating = true
    }
  }
  
  // will be filled in by search results vc and be used in saving process
  var address: String?
  var latitude: Double?
  var longitude: Double?
  var isArriving: Bool?
  
  private let locationManager = CLLocationManager()
  private let notificationManager = NotificationManager()
  
  // MARK: - Viewwillappear
  
  override func viewWillAppear(_ animated: Bool) {
    // Request core location
    if CLLocationManager.authorizationStatus() == .notDetermined {
      // request always in order for notifications to work at the background
      locationManager.requestAlwaysAuthorization()
    }
  }
  
  // MARK: - Viewdidload
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    setupUI()
    setupRepetitionControl()
    
    if let reminder = reminder {
      titleTextField.text = reminder.title
      subTextField.text = reminder.subtitle
      setLocationButton.setTitle(reminder.address, for: .normal)
      optionControl.selectedSegmentIndex = reminder.isRepeating ? 0 : 1
      self.address = reminder.address
      self.isArriving = reminder.isArriving
      self.isRepeating = reminder.isRepeating
      self.latitude = reminder.latitude
      self.longitude = reminder.longitude
    
      // TODO: load up mapview here
    }
  }
  
  func setupUI() {
    view.backgroundColor = UIColor.Theme.charcoal
    setLocationButton.setTitleColor(UIColor.Theme.turquoise, for: .normal)
  }
  
  func setupRepetitionControl() {
    optionControl.setTitle("Recurring", forSegmentAt: 0)
    optionControl.setTitle("Once Only", forSegmentAt: 1)
    optionControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    optionControl.selectedSegmentTintColor = UIColor.Theme.turquoise
  }

  @IBAction func saveReminder(_ sender: UIBarButtonItem) {
    print("save pressed")
    
    guard let title = titleTextField.text, let subtitle = subTextField.text else { return presentAlert(title: "Title/subtitle is missing.", message: "Please fill in required fields.") } // return error if anything is nil
    
    if self.optionControl.selectedSegmentIndex == 0 {
      isRepeating = true
    } else {
      isRepeating = false
    }
    
    if reminder != nil {
      // save existing reminder
      guard let address = self.address, let isArriving = self.isArriving, let latitude = self.latitude, let longitude = self.longitude else { return presentAlert(title: "Address/isArriving/Coordinates missing", message: "One of the fields are empty!") } // check if nil before saving
      
      if let updatedReminder = self.reminder {
        updatedReminder.title = title
        updatedReminder.subtitle = subtitle
        updatedReminder.isRepeating = isRepeating!
        updatedReminder.creationDate = Date()
        updatedReminder.address = address
        updatedReminder.isArriving = isArriving
        updatedReminder.latitude = latitude
        updatedReminder.longitude = longitude
        
        notificationManager.removeNotification(using: self.reminder!) // deletes old notification settings
        notificationManager.scheduleNotification(using: updatedReminder) // create a new notification
        context.saveChanges()
        navigationController?.popToRootViewController(animated: true)
      }
     
    } else {
      // save a new reminder
      guard let address = self.address, let isArriving = self.isArriving, let latitude = self.latitude, let longitude = self.longitude else { return presentAlert(title: "Address/isArriving/coordinates are missing", message: "Please fill in required fields.") } // check if nil before saving
      
      let newReminder = NSEntityDescription.insertNewObject(forEntityName: "Reminder", into: context) as! Reminder
      newReminder.title = title
      newReminder.subtitle = subtitle
      newReminder.isRepeating = isRepeating!
      newReminder.creationDate = Date()
      newReminder.address = address
      newReminder.isArriving = isArriving
      newReminder.latitude = latitude
      newReminder.longitude = longitude
      
      notificationManager.scheduleNotification(using: newReminder)
      
      context.saveChanges()
      navigationController?.popToRootViewController(animated: true)
    }
        
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "setLocation" {
      guard let destination = segue.destination as? SearchResultsViewController else { return presentAlert(title: "Segue Error", message: "SearchResultsVC error.") }
      destination.reminder = self.reminder
      destination.delegate = self
      // fill in destination information if we are editing an existing reminder
    }
  }
  
}

/*
 This is a static table view that has 3 rows.
 First row has textfields for title and subtitle.
 Second row is the option segment controller.
 Third row is the map.
 */
// MARK: - Table view data source methods
extension AddReminderViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
}

// Passes location data, updates button title, etc.
extension AddReminderViewController: SearchResultsDelegate {
  func passLocationData(_ controller: SearchResultsViewController, location: MKMapItem, isArriving: Bool) {
    self.latitude = location.placemark.coordinate.latitude
    self.longitude = location.placemark.coordinate.longitude
    self.address = location.placemark.title!
    self.isArriving = isArriving
    
    self.setLocationButton.setTitle(location.placemark.title, for: .normal) // change button title to location's address
    
    // setup mapview here using the details that were passed on by searchresultscontroller
    let radius: CLLocationDistance = 200
    let region = MKCoordinateRegion(center: location.placemark.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
    self.mapView.setRegion(region, animated: true)
    
    mapView.removeAnnotations(self.mapView.annotations) // refreshes annotations
    let annotation = MKPointAnnotation()
    annotation.title = location.placemark.name
    annotation.coordinate = location.placemark.coordinate
    mapView.addAnnotation(annotation)
    
    // Create a circle overlay used to show area for geofencing
    let circleRadius: CLLocationDistance = 50
    let circle = MKCircle(center: location.placemark.coordinate, radius: circleRadius)
    mapView.addOverlay(circle)
  }
  
}

// MARK: - Mkmapviewdelegate methods
extension AddReminderViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    // renders a filled colored circle overlay
    let circleRenderer = MKCircleRenderer(overlay: overlay)
    circleRenderer.strokeColor = UIColor.blue
    circleRenderer.fillColor = UIColor.cyan
    circleRenderer.alpha = 0.5
    circleRenderer.lineWidth = 1.0
    return circleRenderer
  }
  
  // create a pin to show center point
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }
    
    let id = "Annotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
      annotationView?.canShowCallout = true
    } else {
      annotationView?.annotation = annotation
    }
    
    return annotationView
  }
}
