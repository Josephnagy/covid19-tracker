//
//  ShadowedImageView.swift
//  Nash
//
//  Created by Jacob Andrew Derry on 4/4/20.
//  Copyright © 2020 nash. All rights reserved.
//

import UIKit

class ShadowedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()

        self.imageView?.layer.shadowColor = UIColor.lightGray.cgColor
        self.imageView?.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.imageView?.layer.shadowOpacity = 0.9
        self.imageView?.layer.shadowRadius = 2.0
        self.imageView?.clipsToBounds = false
    }
}
