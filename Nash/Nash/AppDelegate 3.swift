//
//  AppDelegate.swift
//  Nash
//
//  Created by Jacob Andrew Derry on 4/4/20.
//  Copyright © 2020 nash. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    //global variables
    static let geoCoder = CLGeocoder()
    let locationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    
    //MARK: api struct
    struct Place: Codable {
        var combined_key: String! //name of place
        var confirmed_cases: Int!
        var country: String!
        var county: String! //think there is going to be problem with null values
        var daily_change_cases: Int!
        var daily_change_deaths: Float!
        var confirmed_deaths: Float?
        var fips: Float! //what is this?
        var latitude: Float!
        var longitude: Float!
        var population: Float!
        var state: String!
        var state_abbr: String!
        var uid: Float!
    }

    var allElms: [Place] = []
    let myLocation = APILocation()
        

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //MARK: set up location tracking
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringVisits()
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        
        //handle location errors if access is denied
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           if let error = error as? CLError, error.code == .denied {
              // Location updates are not authorized.
        
              manager.stopUpdatingLocation()
              return
           }
           // Notify the user of any errors.
        }
        
        
        //MARK: set up notifications
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        //request authorization for notifications
        center.requestAuthorization(options:options) { (granted, error) in if granted {
            print ("Notification permission allowed")
//            self.setUpNotification()
            self.setUpDailyNotification()
            }
        }
        
        let notificationAction = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
        
        let myCategory = UNNotificationCategory(identifier: "myUniqueCategory", actions: [notificationAction], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([myCategory])
        
        return true
    }
    
    // func setUpNotification() {
    //      //setting content of notification
    //     let content = UNMutableNotificationContent()
    //     content.title = "Cases in this area..."
    //     content.body = bodyofReturnNotification()
    //     //hardcoded and need to replace with api call to request current location
        
    //     content.sound = UNNotificationSound.default
    //     content.categoryIdentifier = "myUniqueCategory"
        
    //     //trigger notification when it matches dateCompotents
    //     let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
    //     // add action to Notification
    //     let notificationAction = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
    //     let myCategory = UNNotificationCategory(identifier: "myUniqueIdentifier", actions: [notificationAction], intentIdentifiers: [], options: [])
        
    //     let notificationCenter = UNUserNotificationCenter.current()
    //             notificationCenter.setNotificationCategories([myCategory])
        
    //     // Add the request to the main Notification center.
    //     let request = UNNotificationRequest(identifier: "returnIdentifer",
    //                           content: content, trigger: trigger)

            
    //     notificationCenter.add(request) { (error) in
    //         if error != nil {
    //             // Handle any errors.
    //         } else {
    //             print("Notification created")
    //         }
    //     }
    // }

    func bodyofReturnNotification() -> String{
   
//        getAllData()
        sleep(1)
        var ret = "Total local cases: " + String(myLocation.iconfirmedcases)
        ret += "\nTotal local deaths: " + String(myLocation.ideaths)
        ret += "\nDaily change in local cases: " + String(myLocation.ichangeInCases)
        ret += "\nDaily change in local deaths: " + String(myLocation.ichangeInDeaths)
        //ret += "\nPercent change in local cases: " + String(Int((Float(myLocation.locationChangeInCases)/Float(myLocation.locationConfirmedCases)) * 100.0)) + "%"
        print(ret)
        return ret
        
    }
    
    // func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
    //     let content = notification.request.content
        
    //     // Process notification content
    //     print("Received Notification with \(content.title) -  \(content.body)")

    //     // Display notification as regular alert and play sound
    //     completionHandler([.alert, .sound])
    // } //end func userNotificationCenter - CHANGED FOR DAILY UPDATE
    
    // func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    //     let actionIdentifier = response.actionIdentifier
    //     //print("func 2")
    //     switch actionIdentifier {
    //     case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
    //         // Do something
    //         completionHandler()
    //     case UNNotificationDefaultActionIdentifier: // App was opened from notification
    //         // Do something
    //         completionHandler()
    //     case "remindLater": do {
    //             let newDate = Date(timeInterval: 60, since: Date())
    //             print("Rescheduling notification until \(newDate)")
    //             // TODO: reschedule the notification
            
    //         }
    //         completionHandler()
    //     default:
    //         completionHandler()
    //     }
    // }//end func userNotificationCenter

// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

//     //CODE FOR STRUCT_____________________________________________
    
//     struct Place: Codable {
//         var combined_key: String //name of place
//         var confirmed_cases: Int
//         var country: String
//         //var county: String //think there is going to be problem with null values
//         var daily_change_cases: Int
//         var daily_change_deaths: Int
//         var deaths: Int
// //        var fips: Float //what is this?
//         var latitude: Float
//         var longitude: Float
//         var population: Int
//         var state: String
//         var uid: Int
//     }//create struct to put the data in
    
//     var allCases: [Place] = []
    
//     struct myLocation {
//         static let location: String = "Puerto Rico, US"
//         static var locationConfirmedCases: Int = 0
//         static var locationCountry: String = ""
//         static var locationChangeInCases: Int = 0
//         static var locationChangeInDeaths: Int = 0
//         static var locationDeaths: Int = 0
//         static var locationLatitude: Float = 0.0
//         static var locationLongitude: Float = 0.0
//         static var locationPopulation: Int = 0
//         static var locationState: String = ""
//         static var locationUid: Int = 0
//         static var totalCases: Int = 1779842
        
//     }
    
//     //END CODE FOR STRUCT_____________________________________________
    
    // func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //         // not using Google Analytics tool
    //         //FirebaseApp.configure()
    //         // MARK: UserNotifications Center Setup
    //         let center = UNUserNotificationCenter.current()
    //         center.delegate = self
    //         let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    //         // request user authorization for notifications
    //         center.requestAuthorization(options: options) { (granted, error) in
    //             if granted {
    //                 //application.registerForRemoteNotifications()
    //                 print("Permission Granted")
    //                 self.setUpNotification()
    //             }
    //         }
        
    //         //give remind me later option
    //          let notificationAction = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
        
    //          let myCategory = UNNotificationCategory(identifier: "myUniqueCategory", actions: [notificationAction], intentIdentifiers: [], options: [])

    //          UNUserNotificationCenter.current().setNotificationCategories([myCategory])

            
    //         return true
    //     } //end func didFinishLaunchingWithOptions - CHANGED THIS FOR DAILY NOTIFICATION

        
//        func setUpNotification() {
//
//                //setting content of notification
//                let content = UNMutableNotificationContent()
//                content.title = "Coronavirus Update - "
//                content.body = bodyofReturnNotification()
//
//                //specify date/time for trigger - everyday 8am
//                var dateComponents = DateComponents()
//                dateComponents.calendar = Calendar.current
//                //dateComponents.weekday = 6  // sunday is 1
//                dateComponents.hour = 9  //  hours
//                dateComponents.minute = 00 // minutes
//
//                //trigger notification when it matches dateCompotents
////                let trigger = UNCalendarNotificationTrigger(
////                         dateMatching: dateComponents, repeats: true)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//
//
//            // add action to Notification
//            let notificationAction = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
//            let myCategory = UNNotificationCategory(identifier: "myUniqueCategory", actions: [notificationAction], intentIdentifiers: [], options: [])
//
//            let notificationCenter = UNUserNotificationCenter.current()
//            notificationCenter.setNotificationCategories([myCategory])
//
//            // cutomise the content categoryIdentifier
//            content.categoryIdentifier = "myUniqueCategory"
//
//            // add sound to Notification
//            content.sound = UNNotificationSound.default
//
//            // Create the request
//            let request = UNNotificationRequest(identifier: "myUniqueIdentifierString1234",
//                        content: content, trigger: trigger)
//
//            // Add the request to the main Notification center.
//
//            notificationCenter.add(request) { (error) in
//               if error != nil {
//                  // Handle any errors.
//               } else {
//                    print("Notification created")
//                }
//            }
//
//        } // end of func setUpNotification - CHANGED FOR DAILY UPDATE
    
//    func setUpDailyNotification() {
//
//                    //setting content of notification
//                    let content2 = UNMutableNotificationContent()
//                    content2.title = "Good Morning"
//                    content2.body = "Check your daily coronavirus update here!"
//
//                    //specify date/time for trigger - everyday 8am
//                    var dateComponents2 = DateComponents()
//                    dateComponents2.calendar = Calendar.current
//                    //dateComponents.weekday = 6  // sunday is 1
//                    dateComponents2.hour =   8//  hours
//                    dateComponents2.minute = 0 // minutes
//
//                    //trigger notification when it matches dateCompotents
//                    let trigger2 = UNCalendarNotificationTrigger(
//                             dateMatching: dateComponents2, repeats: true)
////                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//
//                // add action to Notification
//                let notificationAction2 = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
//                let myCategory2 = UNNotificationCategory(identifier: "myUniqueCategory2", actions: [notificationAction2], intentIdentifiers: [], options: [])
//
//                let notificationCenter2 = UNUserNotificationCenter.current()
//                notificationCenter2.setNotificationCategories([myCategory2])
//
//                // cutomise the content categoryIdentifier
//                content2.categoryIdentifier = "myUniqueCategory2"
//
//                // add sound to Notification
//                content2.sound = UNNotificationSound.default
//
//                // Create the request
//                let request2 = UNNotificationRequest(identifier: "myUniqueIdentifierString12345",
//                            content: content2, trigger: trigger2)
//
//                // Add the request to the main Notification center.
//
//                notificationCenter2.add(request2) { (error) in
//                   if error != nil {
//                      // Handle any errors.
//                   } else {
//                        print("Daily Notification created")
//                    }
//                }
//
//            } // end of func setUpNotification - CHANGED FOR DAILY UPDATE
//
//    // func bodyofDailyNotification() -> String {
//    //     getAllData()
//    //     let casesString = String(myLocation.locationConfirmedCases)
//    //     let deathsString = String(myLocation.locationDeaths)
//    //     let changeDeathsString = String(myLocation.locationChangeInDeaths)
//    //     let changeCasesString = String(myLocation.locationChangeInCases)
//    //     let totalCasesString = String(myLocation.totalCases)
//
//    //     var ret = "Total global cases: " + totalCasesString
//    //     ret += "\nTotal local cases: " + casesString
//    //     ret += "\nTotal local deaths: " + deathsString
//    //     ret += "\nDaily change in local cases: " + changeCasesString
//    //     ret += "\nDaily change in local deaths: " + changeDeathsString
//    //     ret += "\nPercent change in local cases: " + String(Int((Float(myLocation.locationChangeInCases)/Float(myLocation.locationConfirmedCases)) * 100.0)) + "%"
//    //     print(ret)
//    //     return ret
//
//    // }
//
//        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//            let content = notification.request.content
//
//            // Process notification content
//            print("Received Notification with \(content.title) -  \(content.body)")
//
//            // Display notification as regular alert and play sound
//            completionHandler([.alert, .sound])
//        } //end func userNotificationCenter - CHANGED FOR DAILY UPDATE
//
//        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//            let actionIdentifier = response.actionIdentifier
//            //print("func 2")
//            switch actionIdentifier {
//            case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
//                // Do something
//                completionHandler()
//            case UNNotificationDefaultActionIdentifier: // App was opened from notification
//                // Do something
//                completionHandler()
//            case "remindLater": do {
//                    let newDate = Date(timeInterval: 60, since: Date())
//                    print("Rescheduling notification until \(newDate)")
//                    // TODO: reschedule the notification
//
//                }
//                completionHandler()
//            default:
//                completionHandler()
//            }
//        }//end func userNotificationCenter #2 - CHANGED FOR DAILY UPDATE
    func setUpDailyNotification() {
                        
                        //setting content of notification
                        let content2 = UNMutableNotificationContent()
                        content2.title = "Good Morning"
                        content2.body = "Check your daily coronavirus update here!"
                        
                        //specify date/time for trigger - everyday 8am
                        var dateComponents2 = DateComponents()
                        dateComponents2.calendar = Calendar.current
                        //dateComponents.weekday = 6  // sunday is 1
                        dateComponents2.hour =   8//  hours
                        dateComponents2.minute = 0 // minutes
                    
                        //trigger notification when it matches dateCompotents
                        let trigger2 = UNCalendarNotificationTrigger(
                                 dateMatching: dateComponents2, repeats: true)
//                    let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
           

                    // add action to Notification
                    let notificationAction2 = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
                    let myCategory2 = UNNotificationCategory(identifier: "myUniqueCategory2", actions: [notificationAction2], intentIdentifiers: [], options: [])
            
                    let notificationCenter2 = UNUserNotificationCenter.current()
                    notificationCenter2.setNotificationCategories([myCategory2])

                    // cutomise the content categoryIdentifier
                    content2.categoryIdentifier = "myUniqueCategory2"

                    // add sound to Notification
                    content2.sound = UNNotificationSound.default

                    // Create the request
                    let request2 = UNNotificationRequest(identifier: "myUniqueIdentifierString12345",
                                content: content2, trigger: trigger2)
                    
                    // Add the request to the main Notification center.
                    
                    notificationCenter2.add(request2) { (error) in
                       if error != nil {
                          // Handle any errors.
                       } else {
                            print("Daily Notification created")
                        }
                    }
                        
                } // end of func setUpNotification - CHANGED FOR DAILY UPDATE
        
        // func bodyofDailyNotification() -> String {
        //     getAllData()
        //     let casesString = String(myLocation.locationConfirmedCases)
        //     let deathsString = String(myLocation.locationDeaths)
        //     let changeDeathsString = String(myLocation.locationChangeInDeaths)
        //     let changeCasesString = String(myLocation.locationChangeInCases)
        //     let totalCasesString = String(myLocation.totalCases)
            
        //     var ret = "Total global cases: " + totalCasesString
        //     ret += "\nTotal local cases: " + casesString
        //     ret += "\nTotal local deaths: " + deathsString
        //     ret += "\nDaily change in local cases: " + changeCasesString
        //     ret += "\nDaily change in local deaths: " + changeDeathsString
        //     ret += "\nPercent change in local cases: " + String(Int((Float(myLocation.locationChangeInCases)/Float(myLocation.locationConfirmedCases)) * 100.0)) + "%"
        //     print(ret)
        //     return ret
            
        // }
            
            func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                let content = notification.request.content
                
                // Process notification content
                print("Received Notification with \(content.title) -  \(content.body)")

                // Display notification as regular alert and play sound
                completionHandler([.alert, .sound])
            } //end func userNotificationCenter - CHANGED FOR DAILY UPDATE
            
            func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                let actionIdentifier = response.actionIdentifier
                //print("func 2")
                switch actionIdentifier {
                case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
                    // Do something
                    completionHandler()
                case UNNotificationDefaultActionIdentifier: // App was opened from notification
                    // Do something
                    completionHandler()
                case "remindLater": do {
                        let newDate = Date(timeInterval: 60, since: Date())
                        print("Rescheduling notification until \(newDate)")
                        // TODO: reschedule the notification
                    
                    }
                    completionHandler()
                default:
                    completionHandler()
                }
            }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Nash")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: API Call
    
    func getAllData() {
        
        //totalCases = 0
        print("starting getAllData")
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "https://nash-273721.df.r.appspot.com/map")!
        
        let task = mySession.dataTask(with: url) {data, response, error in
            
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            guard let jsonData = data else {
                print("No data")
                return
            }
            
            print("Got the data from network")
            
            let decoder = JSONDecoder()

            do {
                self.allElms = try decoder.decode([Place].self, from: jsonData)
               // get current location
                let currLoc = self.locationManager.location
                print(currLoc)
                //get city state country from lat and long
                self.myLocation.fetchCityStateAndCountry(from: (currLoc ?? nil)!) { city, state, country, error in
                                    guard let city = city, let state = state, let country = country, error == nil else { return }
                            print("Current location: " + city + ", " + state + ", ", country)
                    self.myLocation.icounty = city
                    self.myLocation.icountry = country
                    self.myLocation.istate = state
                    print("Global location variables being declared: ")
                    print("IVAR: " + String((self.myLocation.icounty ?? "")!))
                    print("IVAR: " + String((self.myLocation.istate ?? "")!))
                    print("IVAR: " + String((self.myLocation.icountry ?? "")!))

                    }
                    sleep(1)
                
                    print("IVARl: " + String((self.myLocation.icounty ?? "")!))
                    print("IVARl: " + String((self.myLocation.istate ?? "")!))
                    print("IVARl: " + String((self.myLocation.icountry ?? "")!))

                    //begin for loop
                    for Place in self.allElms{
                        print("loop")
                        //print(Place.county)
                        //print(self.myLocation.icounty)
                        if (Place.county == self.myLocation.icounty && Place.state_abbr == self.myLocation.istate) {
                            //print("loop")
                            print("true")
                            self.myLocation.icombinedkey = Place.combined_key
                            self.myLocation.iconfirmedcases = Place.confirmed_cases
                            self.myLocation.ideaths = Place.confirmed_deaths ?? 0
                            self.myLocation.ichangeInDeaths = Place.daily_change_deaths
                            self.myLocation.ichangeInCases = Place.daily_change_cases
                        }
                    }
                print("done!!!")
            } catch {
                print("JSON Decode error")
            }
        }
        
        task.resume()
        sleep(2)
        
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    //check to see if user has allowed location permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("visit")
       let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)

        
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
                let description =  "\(place)"
                self.newVisitReceived(visit, description: description, place: place )
            }
        }
        
    }
    
    func newVisitReceived(_ visit: CLVisit, description: String, place: CLPlacemark) {
        let location = Location(visit: visit, descriptionString: description)
        let locality = place.locality
    
        let content = UNMutableNotificationContent()
        content.title = "Cases in " + locality!
        content.body = "Get data from API"
        content.sound = .default

        // 2
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: location.dateString, content: content, trigger: trigger)

         //3
        center.add(request) { error in if error != nil {
            print ("something went wrong")
            }
            
        }
       
   }
}

//API CONNECTION CODE_________________________________________

//     func getAllData() {
//             //print("starting getAllData")
//             let mySession = URLSession(configuration: URLSessionConfiguration.default)
            
//             let url = URL(string: "https://nash-273721.df.r.appspot.com/map")!
            
//             let task = mySession.dataTask(with: url) {data, response, error in
                
//                 guard error == nil else {
//                     print ("error: \(error!)")
//                     return
//                 }
                
//                 guard let jsonData = data else {
//                     print("No data")
//                     return
//                 }
                
//                 print("Got the data from network")
                
//                 let decoder = JSONDecoder()

//                 do {
//                     self.allCases = try decoder.decode([Place].self, from: jsonData)
                     
// //                    for Place in self.allCases{
// //                        print(Place.confirmed_cases)
// //                        print(Place.country)
// //                    } //prints everything
// //                    let dispatchGroup = DispatchGroup()
// //                    let dispatchQueue = DispatchQueue(label: "taskQueue")
// //                    let dispatchSemaphore = DispatchSemaphore(value: 0)
                    
//                         for index in 0..<self.allCases.count {
//                             myLocation.totalCases += self.allCases[index].confirmed_cases//problem with this
//                             if self.allCases[index].combined_key == myLocation.location {
//                                 myLocation.locationConfirmedCases = self.allCases[index].confirmed_cases
//                                 myLocation.locationCountry = self.allCases[index].country
//                                 myLocation.locationChangeInCases = self.allCases[index].daily_change_cases
//                                 myLocation.locationChangeInDeaths = self.allCases[index].daily_change_deaths
//                                 myLocation.locationDeaths = self.allCases[index].deaths
//                                 myLocation.locationLatitude = self.allCases[index].latitude
//                                 myLocation.locationLongitude = self.allCases[index].longitude
//                                 myLocation.locationPopulation = self.allCases[index].population
//                                 myLocation.locationState = self.allCases[index].state
//                                 myLocation.locationUid = self.allCases[index].uid
//                             }
//                         } //end of for loop
// //                    for place in self.allCases{
// //                        if place.combined_key == myLocation.location {
// //                            print(place.combined_key)
// //                        }
// //                    }

//                     //print("finished printing")
//                 }
                    
//                 catch {
//                     print("JSON Decode error")
//                 }
//             }
//             task.resume()
//             sleep(1)
//             //print("get all data completed")
//         }
    
// }

    
//END API CONNECTION CODE_____________________________________
    



