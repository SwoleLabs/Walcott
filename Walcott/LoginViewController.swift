//
//  LoginViewController.swift
//  Walcott
//
//  Created by David Barsky on 9/24/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let button = FBSDKLoginButton()
        button.center = self.view.center
        self.view.addSubview(button)
    }
}
