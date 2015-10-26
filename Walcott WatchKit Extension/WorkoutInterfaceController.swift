//
//  WorkoutInterfaceController.swift
//  Walcott
//
//  Created by Rosalind Ellis on 10/22/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import WatchKit
import HealthKit


class WorkoutInterfaceController: WKInterfaceController {
    
    let healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession
    
    init(workoutSession: HKWorkoutSession) {
        self.workoutSession = workoutSession
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    

    @IBAction func endWorkoutButtonWasPressed() {
        healthStore.endWorkoutSession(self.workoutSession)
    }

}