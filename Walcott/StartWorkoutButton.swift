//
//  StartWorkoutButton.swift
//  Walcott
//
//  Created by David Barsky on 11/19/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import UIKit

@IBDesignable
class StartWorkoutButton: UIButton {
    override func layoutSubviews() {
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        self.tintColor = UIColor.blueColor()
        self.titleLabel?.textColor = UIColor.blueColor()
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.blueColor().CGColor
    }
}
