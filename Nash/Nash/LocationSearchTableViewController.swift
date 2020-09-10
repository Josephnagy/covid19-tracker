//
//  LocationSearchTableViewController.swift
//  Nash
//
//  Created by Joseph Nagy on 4/13/20.
//  Copyright © 2020 nash. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    
    //search bar variables
    //var matchingItems : [MKMapItem] = []
    var mapView : MKMapView? = nil
    var handleMapSearchDelegate : HandleMapSearch? = nil
    var allPins: [Pin] = [] 
    
    // MARK: New Search Bar Variables
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPins: [Pin] = []
    var isSearchBarEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    var isFiltering: Bool = false
//    {
//      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
//      return searchController.isActive && (!isSearchBarEmpty) //|| searchBarScopeIsFiltering)
//    }
    
    // Dummy array of pins
    var testPins: [Pin] = [Pin(coordinate: CLLocationCoordinate2D(latitude: 37.8199, longitude: 122.4783), title: "Golden Gate Bridge", subtitle: "Bridge", color: UIColor.red),
    Pin(coordinate: CLLocationCoordinate2D(latitude: 36.0007, longitude: -78.9367), title: "Duke University", subtitle: "Duke", color: UIColor.blue),
    Pin(coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: 74.0060), title: "NYC", subtitle: "City", color: UIColor.green)]
    
    func filterContentForSearchText(_ searchText: String) {
        filteredPins = allPins.filter{$0.title!.lowercased().contains(searchText.lowercased())}
        
        //print("Filtered pins (search \(searchText)) = \(filteredPins.count)")
        
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LENGTH OF ALL PINS: \(allPins.count)")
        for p in allPins {
            print("country: \(p.title)")
        }
        
        // Format searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Territories"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension LocationSearchTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    self.isFiltering = true
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

extension LocationSearchTableViewController {
  override func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    if isFiltering {
      return filteredPins.count
    }
      return allPins.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    var pin: Pin
    if isFiltering {
      pin = filteredPins[indexPath.row]
    } else {
      pin = allPins[indexPath.row]
    }
    cell.textLabel?.text = pin.title
    let pinSubtitle = pin.subtitle!.components(separatedBy: "\n")
    cell.detailTextLabel?.text = pinSubtitle[0] + ", " + pinSubtitle[1]
    return cell
  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = filteredPins[indexPath.row]
        handleMapSearchDelegate?.dropPinZoomIn(pin: selectedItem)
        
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }


// MARK: ALL OLD SEARCH BAR CODE IS BELOW HERE

/*
 // MARK: Helper Functions
 func parseAddress(selectedItem: MKPlacemark) -> String {
     let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
     
     let comma = (selectedItem.subThoroughfare != nil || selectedItem.subThoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ?
     ", ": ""
     
     let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " ": ""
     
     let addressLine = String(
         format: "%@%@%@%@%@%@%@",
         // street number
         selectedItem.subThoroughfare ?? "",
         firstSpace,
         // street name
         selectedItem.thoroughfare ?? "",
         comma,
         // city
         selectedItem.locality ?? "",
         secondSpace,
         // state
         selectedItem.administrativeArea ?? ""
         )
     return addressLine
 }
 
 extension LocationSearchTableViewController: UISearchResultsUpdating {
     func updateSearchResults(for searchController: UISearchController) {
         guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {return}
         
         let request = MKLocalSearch.Request()
         
         request.naturalLanguageQuery = searchBarText
         request.region = mapView.region
         
         let search = MKLocalSearch(request: request)
         
         search.start { (response, error) in
             guard let response = response else {return}
             
             self.matchingItems = response.mapItems
             self.tableView.reloadData()
         }
         
     }
 }

 extension LocationSearchTableViewController
 {
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return matchingItems.count
        }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
         let selectedItem = matchingItems[indexPath.row].placemark
         cell?.textLabel?.text = selectedItem.name
         cell?.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
         
         return cell!
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedItem = matchingItems[indexPath.row].placemark
         handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
         
         dismiss(animated: true, completion: nil)
     }
 }
 

 */
