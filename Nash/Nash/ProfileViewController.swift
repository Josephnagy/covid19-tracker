//
//  ProfileViewController.swift
//  Nash
//
//  Created by Sam Snedeker on 4/17/20.
//  Copyright © 2020 nash. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func profileToLocation(_ sender: Any) {
        performSegue(withIdentifier: "profileToLocationPref" , sender: self)
    }
    @IBAction func backToMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
