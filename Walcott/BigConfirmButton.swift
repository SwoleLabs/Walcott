//
//  BigConfirmButton.swift
//  Walcott
//
//  Created by David Barsky on 12/1/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import UIKit

@IBDesignable
class BigConfirmButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.backgroundColor = UIColor(red:0,  green:0.871,  blue:0.380, alpha:1).CGColor
        self.titleLabel?.textColor = UIColor.whiteColor()
    }
}
