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
        var latitude: Float?
        var longitude: Float?
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

  
    func setUpDailyNotification() {
                
            //setting content of notification
            let content2 = UNMutableNotificationContent()
            content2.title = "Track Covid-19!"
            content2.body = "Stay up to date. Stay home. Stay safe!"
            
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
        //self.setCurrentLocation()
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
            print("Current Location Updated After Location Manager Auth Status Changed")
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
