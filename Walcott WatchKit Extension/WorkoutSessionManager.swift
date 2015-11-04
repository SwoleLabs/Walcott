//
//  WorkoutSessionManager.swift
//  Walcott
//
//  Created by Rosalind Ellis on 11/3/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import WatchKit
import HealthKit

class WorkoutSessionContext {
    let healthStore: HKHealthStore
    var activityType: HKWorkoutActivityType
    var locationType: HKWorkoutSessionLocationType
    
    
    init(healthStore: HKHealthStore, activityType: HKWorkoutActivityType = .TraditionalStrengthTraining, locationType: HKWorkoutSessionLocationType = .Indoor) {
        self.healthStore = healthStore
        self.activityType = activityType
        self.locationType = locationType
    }
    
}

class WorkoutSessionManager: NSObject, HKWorkoutSessionDelegate {
    
    let healthStore: HKHealthStore
    let workoutSession: HKWorkoutSession
    
    var workoutStartDate = NSDate?()
    var workoutEndDate = NSDate?()
    
    var queries: [HKQuery] = []
    
    var energyUnit = HKUnit.calorieUnit()
    
    var activeEnergySamples: [HKQuantitySample] = []
    var heartRateSamples: [HKQuantitySample] = []
    
    let activeEnergyType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
    let heartRateType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
    
    var currentHeartRateQuantity: HKQuantity?
    var currentActiveEnergyQuantity: HKQuantity?
    

    weak var delegate: WorkoutSessionManagerDelegate?
    
    init(context: WorkoutSessionContext) {
        self.healthStore = context.healthStore
        self.workoutSession = HKWorkoutSession(activityType: context.activityType, locationType: context.locationType)
        self.currentActiveEnergyQuantity = HKQuantity(unit: self.energyUnit, doubleValue: 0.0)
        
        super.init()
        
        //self.workoutSession.delegate = self
        
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
//    func createStreamingActiveEnergyQuery(workoutStartDate: NSDate) -> HKQuery {
//        let predicate = self.predicateForWorkoutSamples(workoutStartDate)
//        
//        let sampleHandler = { (samples: [HKQuantitySample]) -> Void in
//            self.currentActiveEnergyQuantity = self.currentActiveEnergyQuantity.addQuantitiesFromSample(samples, unit: self.energyUnit)
//            self.delegate?.workoutSessionManager(self, didUpdateActiveEnergyQuantity: self.currentActiveEnergyQuantity)
//        }
//        
//        return
//        
//     }

}

class WorkoutSessionManagerDelegate {
    
}
