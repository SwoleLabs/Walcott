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
        
//        guard HKHealthStore.isHealthDataAvailable() == true else {
//            print("HealthKit is not availible.")
//            return
//        }
        
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: Workout Stuff
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        switch toState {
        case.Running:
            self.workoutDidStart(date)
            print("Workout Running")
        case .Ended:
            self.workoutDidEnd(date)
            print("Workout Ended")
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        print(error)
    }
    
    
    func workoutDidStart(date: NSDate) {
        //self.workoutStartDate = date
        
        
    }
    
    func workoutDidEnd(date: NSDate) {
        
    }
    
    // MARK: Data Queries
    func createStreamingActiveEnergyQuery(workoutStartDate: NSDate) -> HKQuery {
//        let predicate = self.predicateForWorkoutSamples(workoutStartDate)
//        
//        let sampleHandler = { (samples: [HKQuantitySample]) -> Void in
//            self.currentActiveEnergyQuantity = self.currentActiveEnergyQuantity.addQuantitiesFromSample(samples, unit: self.energyUnit)
//            self.delegate?.workoutSessionManager(self, didUpdateActiveEnergyQuantity: self.currentActiveEnergyQuantity)
//        }
        
    }
    

    @IBAction func endWorkoutButtonWasPressed() {
        timer.stop()
        healthStore.endWorkoutSession(self.workoutSession)
    }

}
