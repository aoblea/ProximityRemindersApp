//
//  SearchResultsViewController.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/25/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// used to populate location data to addremindervc
protocol SearchResultsDelegate: class {
  func passLocationData(_ controller: SearchResultsViewController, location: MKMapItem, isArriving: Bool)
}

/// Search places using keyword search results
class SearchResultsViewController: UIViewController {
  // MARK: - IBOutlets
  
  @IBOutlet weak var resultsTableView: UITableView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var directionControl: UISegmentedControl!
  
  // MARK: - Properties
  
  let searchResultsController = UISearchController(searchResultsController: nil)
  var searchResults: [MKMapItem] = []
  var filteredResults: [MKMapItem] = []
  var defaultRegion: MKCoordinateRegion?
  var selectedLocation: MKMapItem?
  
  var isArriving: Bool? {
    didSet {
      self.isArriving = true
    }
  }
  
  var reminder: Reminder? // for populating information if we are in editing mode
  weak var delegate: SearchResultsDelegate?
  
  // MARK: - Viewdidload
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupResultsTableView()
    setupMapView()
    setupSearchResultsController()
    setupControl()
  }
  
  func setupResultsTableView() {
    resultsTableView.dataSource = self
    resultsTableView.delegate = self
    resultsTableView.tableHeaderView = searchResultsController.searchBar
  }
  
  func setupMapView() {
    defaultRegion = mapView.region
    mapView.delegate = self
  }
  
  func setupSearchResultsController() {
    searchResultsController.searchResultsUpdater = self
    searchResultsController.hidesNavigationBarDuringPresentation = false
    searchResultsController.searchBar.delegate = self
    searchResultsController.searchBar.placeholder = "Search keyword"
    searchResultsController.obscuresBackgroundDuringPresentation = false
    definesPresentationContext = true
  }
  
  func setupControl() {
    directionControl.setTitle("Arriving", forSegmentAt: 0)
    directionControl.setTitle("Departing", forSegmentAt: 1)
    directionControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    directionControl.selectedSegmentTintColor = UIColor.Theme.turquoise
  }
  
  @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
    guard let selection = selectedLocation else { return presentAlert(title: "No selected location", message: "Please select a location") } // send a warning that a place hasn't been selected yet.
    
    if directionControl.selectedSegmentIndex == 0 {
      isArriving = true
    } else if directionControl.selectedSegmentIndex == 1 {
      isArriving = false
    }
    
    delegate?.passLocationData(self, location: selection, isArriving: self.isArriving!)
    
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - Search results/bar methods

extension SearchResultsViewController: UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
    
    if !searchText.isEmpty {
      let request = MKLocalSearch.Request()
      request.naturalLanguageQuery = searchText
      request.region = mapView.region
      
      let search = MKLocalSearch(request: request)
      search.start { (response, error) in
        guard let response = response else { return }

        // this removes the duplicates by emptying out the array
        self.searchResults = []
        
        self.searchResults.append(contentsOf: response.mapItems)
    
        self.filteredResults = self.searchResults.filter { (item) -> Bool in
          return item.name!.lowercased().contains(searchText.lowercased())
        }
        
        DispatchQueue.main.async {
          self.resultsTableView.reloadData()
        }
      }
    } else {
      guard let region = defaultRegion else { return }
      mapView.setRegion(region, animated: true)
      searchResults.removeAll()
      filteredResults.removeAll()
      DispatchQueue.main.async {
        self.resultsTableView.reloadData()
      }
    }
  }
  
}

// MARK: - Table view data source and delegate methods

extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    filteredResults.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationViewCell
    
    cell.configure(using: filteredResults[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let coordinate = filteredResults[indexPath.row].placemark.coordinate
    selectedLocation = filteredResults[indexPath.row] // sets selectedLocation for saving
    
    let radius: CLLocationDistance = 200
    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
    mapView.setRegion(region, animated: true)
    
    mapView.removeAnnotations(self.mapView.annotations) // refreshes annotations
    let location = MKPointAnnotation()
    location.title = filteredResults[indexPath.row].name
    location.coordinate = coordinate
    mapView.addAnnotation(location)
    
    // Create a circle overlay used to show area for geofencing
    let circleRadius: CLLocationDistance = 50
    let circle = MKCircle(center: coordinate, radius: circleRadius)
    mapView.addOverlay(circle)
  }
}

// MARK: - MKMapView delegate methods

extension SearchResultsViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    // renders a filled colored circle overlay
    let circleRenderer = MKCircleRenderer(overlay: overlay)
    circleRenderer.strokeColor = UIColor.blue
    circleRenderer.fillColor = UIColor.cyan
    circleRenderer.alpha = 0.5
    circleRenderer.lineWidth = 1.0
    return circleRenderer
  }
  
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
