//
//  InterfaceController.swift
//  Walcott WatchKit Extension
//
//  Created by David Barsky on 9/21/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class StartWorkoutController: WKInterfaceController {
    
    let healthStore = HKHealthStore()
    
    // MARK:- Lifecycle
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let typesToShare = Set([HKObjectType.workoutType()])
        
        let typesToRead = Set([
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            ])
        
        self.healthStore.requestAuthorizationToShareTypes(typesToShare, readTypes: typesToRead) { success, error in
            //..do something maybe?
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
