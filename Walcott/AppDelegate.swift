//
//  AppDelegate.swift
//  Walcott
//
//  Created by David Barsky on 9/21/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import HealthKit
import Parse
import Keys

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let healthStore = HKHealthStore()
    
    func applicationShouldRequestHealthAuthorization(application: UIApplication) {
        let keys = WalcottKeys()
        Parse.setApplicationId(keys.parseID(), clientKey: keys.parseKey())
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        if (FBSDKAccessToken.currentAccessToken()?.userID == nil) {
            self.window!.rootViewController = UIStoryboard(name: "Setup", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
        } else {
            self.window!.rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

