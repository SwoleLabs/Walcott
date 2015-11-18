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
    
    var healthStore = HKHealthStore()
    var workoutSession = HKWorkoutSession(activityType: .TraditionalStrengthTraining, locationType: .Indoor)
    
    @IBOutlet var heartRate: WKInterfaceLabel!
    @IBOutlet var timer: WKInterfaceTimer!
    
    @IBOutlet var calLabel: WKInterfaceLabel!
    
    var stillGoing = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //workoutSession.delegate = self
        startWorkout()
        displayStats()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        timer.start();
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // MARK: Workout Variables
    
    var workoutStartDate = NSDate?()
    var workoutEndDate = NSDate?()
    
    var queries: [HKQuery] = []
    
    var energyUnit = HKUnit.calorieUnit()
    
    var activeEnergySamples: [HKQuantitySample] = []
    var heartRateSamples: [HKQuantitySample] = []
    
    let activeEnergyType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
    
    let heartRateType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
    
    var currentHeartRateQuantity: HKQuantity?
    var currentActiveEnergyQuantity: HKQuantity?
    
    let heartRateUnit = HKUnit(fromString: "count/min")
    var heartRateQuery: HKQuery?
    
    func displayStats() {
        
        
        guard self.heartRateQuery == nil else { return }
        
        if self.heartRateQuery == nil {
            // start
            self.heartRateQuery = self.createStreamingHeartRateQuery()
            self.healthStore.executeQuery(self.heartRateQuery!)
            stillGoing = true
        }
        else {
            // stop
            self.healthStore.stopQuery(self.heartRateQuery!)
            self.heartRateQuery = nil
            stillGoing = false
        }
    }
    
    // MARK: HKWorkoutSessionDelegate Protocol
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        print(error)
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        switch toState {
        case.Running:
            self.workoutDidStart(date)
        case .Ended:
            self.workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    // MARK: Workout Stuff
    func startWorkout() {
        self.healthStore.startWorkoutSession(self.workoutSession)
    }
    
    
    func workoutDidStart(date: NSDate) {
        //self.workoutStartDate = date
        
        
    }
    
    func workoutDidEnd(date: NSDate) {
        self.workoutEndDate = date
        
        //stop data queries
        for query in queries {
            self.healthStore.stopQuery(query)
        }
        
        self.queries.removeAll()
        
        //self.delegate?.workoutSessionManager(self, didStopWorkoutWithDate: date)
        
        self.saveWorkout()
        
    }
    
    func saveWorkout() {
        //only save a workout if there are valid start and end dates
        guard let startDate = self.workoutStartDate, endDate = self.workoutEndDate else { return }
        
        //create a workout sample
        let workout = HKWorkout(activityType: self.workoutSession.activityType,
            startDate: startDate,
            endDate: endDate,
            duration: endDate.timeIntervalSinceDate(startDate),
            totalEnergyBurned: self.currentActiveEnergyQuantity,
            totalDistance: nil,
            metadata: nil)
        
        var allSamples: [HKQuantitySample] = []
        allSamples += self.activeEnergySamples
        allSamples += self.heartRateSamples
        
        //save workout
        self.healthStore.saveObject(workout) { success, error in
            
            //associate the accumulated samples with the workout
            if success && allSamples.count > 0 {
                self.healthStore.addSamples(allSamples, toWorkout: workout, completion: { success, error in
                    //..
                })
            }
        }
    }
    
    // MARK: Data Queries
    func createStreamingActiveEnergyQuery(workoutStartDate: NSDate) -> HKQuery {
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate(), endDate: nil, options: .None)
        
        let query = HKAnchoredObjectQuery(type: activeEnergyType!, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples,label: "calLabel")
        }
        query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples, label: "calLabel")
        }
        return query
        
    }
    
    private func createStreamingHeartRateQuery() -> HKQuery {
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate(), endDate: nil, options: .None)
        
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples, label: "heartRate")
        }
        query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples, label: "heartRate")
        }
        
        return query
    }
    
    private func addSamples(samples: [HKSample]?, label: String) {
        guard let samples = samples as? [HKQuantitySample] else { return }
        guard let quantity = samples.last?.quantity else { return }
        if (label == "heartRate") {
            heartRate.setText("\(quantity.doubleValueForUnit(heartRateUnit))")
        } else {
            calLabel.setText("\(quantity.doubleValueForUnit(energyUnit))")
        }
    }

    
    @IBAction func endWorkoutButtonWasPressed() {
        timer.stop()
        saveWorkout()
        healthStore.endWorkoutSession(self.workoutSession)
    }

}
