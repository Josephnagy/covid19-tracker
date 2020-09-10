//
//  Artwork.swift
//  Nash
//
//  Created by Jacob Andrew Derry on 4/4/20.
//  Copyright © 2020 nash. All rights reserved.
//

import Foundation
import MapKit

struct Results: Codable{
    let results: [Covid]
    
    init(results: [Covid]) {
        self.results = results
    }
}

struct Covid: Codable {
    let uid: Int?
    let fips: Int?
    let combined_key: String?
    let country: String?
    let state: String?
    let county: String?
    let latitude: Double
    let longitude: Double
    let confirmed_cases: Int?
    let confirmed_deaths: Int?
    let daily_change_cases: Int?
    let daily_change_deaths: Int?
    let weekly_change_cases: Int?
    let weekly_change_deaths: Int?
    let state_abbr: String?
    let population: Double?

  init(
    uid:Int,
    fips:Int,
    combined_key: String,
    country:String,
    state:String,
    county:String,
    latitude:Double,
    longitude:Double,
    confirmed_cases:Int,
    confirmed_deaths:Int,
    daily_change_cases:Int,
    daily_change_deaths:Int,
    weekly_change_cases:Int,
    weekly_change_deaths:Int,
    state_abbr:String,
    population:Double
  ) {
    self.uid = uid
    self.fips = fips
    self.combined_key = combined_key
    self.country = country
    self.state = state
    self.county = county
    self.latitude = latitude
    self.longitude = longitude
    self.confirmed_cases = confirmed_cases
    self.confirmed_deaths = confirmed_deaths
    self.daily_change_cases = daily_change_cases
    self.daily_change_deaths = daily_change_deaths
    self.weekly_change_cases = weekly_change_cases
    self.weekly_change_deaths = weekly_change_deaths
    self.state_abbr = state_abbr
    self.population = population
  }
}

class Pin: NSObject, MKAnnotation{
    let coordinate: CLLocationCoordinate2D
    let title:String?
    let subtitle:String?
    let color:UIColor?
    
    init(
        coordinate:CLLocationCoordinate2D,
        title:String?,
        subtitle:String?,
        color:UIColor?
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.color = color
    }
}
