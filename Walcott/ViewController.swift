//
//  ViewController.swift
//  Walcott
//
//  Created by David Barsky on 9/21/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- HealthKit Permissions
    @IBAction func authorizeHealthKit(sender: UIButton) {
        // readable
        let height = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
        let weight = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        let birthday = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!
        let sex = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!
        let readableDataTypes = Set(value: [height, weight, birthday, sex])
        
        // shareable
        let activeBurnType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
        let restingBurnType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBasalEnergyBurned)!
        
        let shareableDataTypes = Set(value: [activeBurnType, restingBurnType])

        healthStore.requestAuthorizationToShareTypes(shareableDataTypes, readTypes: readableDataTypes) { (success, error) -> Void in
            if success {
                print("Success!")
            } else {
                print("Failure!")
            }
        }
    }
}
