//
//  WorkoutInterfaceController.swift
//  Walcott
//
//  Created by Rosalind Ellis on 10/22/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import WatchKit
import HealthKit


class WorkoutInterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {
    
    let healthStore = HKHealthStore()
    var workoutSession = HKWorkoutSession(activityType: .TraditionalStrengthTraining, locationType: .Indoor)
    
    @IBOutlet var heartRate: WKInterfaceLabel!
    @IBOutlet var timer: WKInterfaceTimer!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        workoutSession.delegate = self
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        timer.start();
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            print("HealthKit is not availible.")
            return
        }
        
    }
    
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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    

    @IBAction func endWorkoutButtonWasPressed() {
        timer.stop()
        healthStore.endWorkoutSession(self.workoutSession)
    }

}
