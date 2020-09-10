//
//  APILocation.swift
//  Nash
//
//  Created by Sam Snedeker on 4/13/20.
//  Copyright © 2020 nash. All rights reserved.
//

import UIKit
import CoreLocation

class APILocation: NSObject {
    
    var icombinedkey: String?
    var ilocation: String?
    var iconfirmedcases: Int = 0
    var icountry: String?
    var icounty: String?
    var ichangeInCases: Int = 0
    var ichangeInDeaths: Float = 0.0
    var ideaths: Float = 0.0
    var ilatitude: Float = 0.0
    var ilongitude: Float = 0.0
    var ipopulation: Float = 0.0
    var istate: String?
    var iuid: Float = 0.0
    //static var totalCases: Int
    
    func fetchCityStateAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ state: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.subAdministrativeArea,
                       placemarks?.first?.administrativeArea,
                       placemarks?.first?.country,
                       error)
        }
    }
        

}
