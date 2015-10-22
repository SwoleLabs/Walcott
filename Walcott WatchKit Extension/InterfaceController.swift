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

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {
    
    let healthStore = HKHealthStore()
    let workoutSession = HKWorkoutSession(activityType: .TraditionalStrengthTraining, locationType: .Indoor)
    
    // MARK:- Lifecycle
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        workoutSession.delegate = self
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            print("HealthKit is not availible.")
            return
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK:- Workout Code
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        switch toState {
        case.Running:
            print("Workout Running")
        case .Ended:
            print("Workout Ended")
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        print(error)
    }
    
    // MARK: IB Actions
    @IBAction func startWorkoutButtonWasPressed() {
        healthStore.startWorkoutSession(self.workoutSession)
    }
    
    @IBAction func endWorkoutButtonWasPressed() {
        healthStore.endWorkoutSession(self.workoutSession)
    }
}
