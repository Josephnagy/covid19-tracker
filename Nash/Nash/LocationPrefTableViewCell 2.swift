//
//  LocationPrefTableViewCell.swift
//  Nash
//
//  Created by Sam Snedeker on 4/17/20.
//  Copyright © 2020 nash. All rights reserved.
//

import UIKit

class LocationPrefTableViewCell: UITableViewCell {

    @IBOutlet weak var locationPrefSwitchVar: UISwitch!
    
    @IBAction func locationPrefSwitch(_ sender: Any) {
        //UserDefaults.standard.set((sender as AnyObject).isOn, forKey: "Switch")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
