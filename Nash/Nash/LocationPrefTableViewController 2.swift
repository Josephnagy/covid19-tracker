//
//  LocationPrefTableViewController.swift
//  Nash
//
//  Created by Sam Snedeker on 4/17/20.
//  Copyright © 2020 nash. All rights reserved.
//

import UIKit

class LocationPrefTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    //  @IBOutlet weak var footerView: UIView!
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
    
    func getAllData() {
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "https://nash-273721.df.r.appspot.com/map")!
        
        let task = mySession.dataTask(with: url) {data, response, error in
            
            guard error == nil else {
                print ("error: \(error!)")
                let alertController = UIAlertController(title: "Error", message: "Request failed. Check internet connection.", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(dismissAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
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
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                for Elm in self.allElms{
                    print(Elm.combined_key)
                    //print(Elm.Team_name)
                }
                
                print("done!!!")
                
            } catch {
                print("JSON Decode error")
            }
        }
        
        task.resume()
        
    }
    
    //let tableData = ["One","Two","Three","Twenty-One"]
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()

    @IBAction func locationToProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllData()
        
      //  tableView.tableFooterView = footerView
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            
            
            return controller
        })()
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateDailyNotificationSettings()
        
    }
    
    func updateDailyNotificationSettings () {
        for cell in tableView.visibleCells as! [LocationPrefTableViewCell] {
            if cell.locationPrefSwitchVar.isOn {
                print(cell)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return allElms.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationPrefTableViewCell
        
       // cell.locationPrefSwitchVar.setOn(UserDefaults.standard.bool(forKey: "Switch"), animated: true)
        
        
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            
            return cell
        } else {
            cell.textLabel?.text = allElms[indexPath.row].combined_key
            //print(allElms[indexPath.row])
            return cell
        }

        // Configure the cell...

        //return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchTerm = searchController.searchBar.text!
        
//        if searchTerm != "" {
//            print(searchTerm)
//            let array = allElms.filter {
//                res in return res.combined_key.contains(searchTerm)
//            }
//            filteredTableData = array as! [String]
//
//        }
        
        
        //let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        //let array = (allElms as NSArray).filtered(using: searchPredicate)
        

        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
