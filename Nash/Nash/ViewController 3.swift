//
//  ViewController.swift
//  Nash
//
//  Created by Jacob Andrew Derry on 4/4/20.
//  Copyright © 2020 nash. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var currentLongitude: Double!
    var currentLatitude: Double!
    
    struct Covid: Codable {
        var combined_key: String! //name of place
        var confirmed_cases: Int!
        var country: String!
        var county: String! //think there is going to be problem with null values
        var daily_change_cases: Int!
        var daily_change_deaths: Int!
        var weekly_change_cases: Int!
        var weekly_change_deaths: Int!
        var confirmed_deaths: Int!
        var fips: Int! //what is this?
        var latitude: Float!
        var longitude: Float!
        var population: Int!
        var state: String!
        var uid: Int!
        var state_abbr: String!
    }
    
    final let url = URL(string:"https://nash-273721.df.r.appspot.com/map")
    var covidWorldWide: [Covid] = []

    //var allElms: [Place] = []
    let myLocation = APILocation()
    var alert_msg: String = "Error: Try Again"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.startUpdatingLocation()
        OperationQueue.main.addOperation ({
            self.setCurrentLocation()
        })
        self.downloadJSON()

        //daily_alert = bodyofReturnNotification()
        //print(daily_alert)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dailyUpdate(_ sender: Any) {
        let alert = UIAlertController(title: "Daily Coronavirus Update", message: alert_msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in }))
            self.present(alert, animated: true, completion: nil)
    }
    
    func setCurrentLocation(){
        let currLoc = self.locationManager.location
        if (currLoc == nil) {
         print("No location available")
         return
        }
        print(currLoc)
        //get city state country from lat and long
        self.myLocation.fetchCityStateAndCountry(from: (currLoc ?? nil)!) {
            city, state, country, error in
                guard let city = city, let state = state, let country = country, error == nil
                    else { return }
                //print(city, state, country)
                self.myLocation.icounty = city
                self.myLocation.istate = state
                self.myLocation.icountry = country
        }
    }
    
    func downloadJSON(){
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{
                if data == nil {
                    print("Connect to Internet")
                } else{
                    let decoder = JSONDecoder()
                    let results = try decoder.decode([Covid].self, from: data!)
                    self.covidWorldWide = results
                }
            } catch{
                print(error)
            }
            OperationQueue.main.addOperation ({
                 self.setAlertData()
            })
        }.resume()
    }
    
    func setAlertData(){
        var alertPlace: Covid
        
        print(String(self.myLocation.icounty ?? "No County") +
            ", " + String(self.myLocation.istate  ?? "No State/Province") +
            ", " + String(self.myLocation.icountry ?? "No Country")
        )
         
        for place in self.covidWorldWide{
            if (self.myLocation.icountry == "United States") {
                if (place.county != nil && place.county == self.myLocation.icounty &&
                        place.state_abbr != nil && place.state_abbr == self.myLocation.istate
                        && place.country == "US" ) {
                    print("IDENTIFIED: County in US")
                    alertPlace = place

                    alert_msg =  "Current Location:\n" + String(alertPlace.combined_key) + "\n\nTotal Population: " + String(alertPlace.population)
                    alert_msg += "\nConfirmed Cases: " + String(alertPlace.confirmed_cases) +
                                "\nConfirmed Deaths: " + String(alertPlace.confirmed_deaths)
                    alert_msg += "\n\nDaily Change in Cases: " + String(alertPlace.daily_change_cases) +
                                 "\nDaily Change in Deaths: " + String(alertPlace.daily_change_deaths)
                    alert_msg += "\n\nWeekly Change in Cases: " + String(alertPlace.weekly_change_cases) +
                                 "\nWeekly Change in Deaths: " + String(alertPlace.weekly_change_deaths)
                }
            } else if (place.country != nil && place.country == self.myLocation.icountry) {
                if (place.state != nil && place.state_abbr == self.myLocation.istate){
                    print("IDENTIFIED: Province outside US")
                    alertPlace = place

                    alert_msg =  "Current Location:\n" + String(alertPlace.state_abbr) + ", " + String(alertPlace.country)
                    alert_msg += "\nConfirmed Cases: " + String(alertPlace.confirmed_cases) +
                                "\nConfirmed Deaths: " + String(alertPlace.confirmed_deaths)
                    alert_msg += "\n\nDaily Change in Cases: " + String(alertPlace.daily_change_cases) +
                                "\nDaily Change in Deaths: " + String(alertPlace.daily_change_deaths) +
                                "\n\nWeekly Change in Cases: " + String(alertPlace.weekly_change_cases) +
                                "\nWeekly Change in Deaths: " + String(alertPlace.weekly_change_deaths)
                } else if (place.state == nil) {
                    print("IDENTIFIED: Country")
                    alertPlace = place
                    alert_msg =  "Current Location:\n" + String(alertPlace.country) + "\n\nTotal Population: " + String(alertPlace.population)
                    alert_msg += "\nConfirmed Cases: " + String(alertPlace.confirmed_cases) +
                                 "\nConfirmed Deaths: " + String(alertPlace.confirmed_deaths)
                    alert_msg += "\n\nDaily Change in Cases: " + String(alertPlace.daily_change_cases) +
                                 "\nDaily Change in Deaths: " + String(alertPlace.daily_change_deaths)
                    alert_msg += "\n\nWeekly Change in Cases: " + String(alertPlace.weekly_change_cases) +
                                 "\nWeekly Change in Deaths: " + String(alertPlace.weekly_change_deaths)
                }
           
            }
        }
        print("Done searching")
    }
}
