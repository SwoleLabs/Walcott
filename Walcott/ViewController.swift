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
    func writeableDataTypes() -> Set<HKSampleType> {
        let activeBurnType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
        let restingBurnType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBasalEnergyBurned)!
        
        let writeableDataTypes = Set(value: [activeBurnType, restingBurnType])
        return writeableDataTypes
    }
    
    func readableDateTypes() -> Set? {
        let height = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
        let weight = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        let birthday = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!
        let sex = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!
        
        let readableDataTypes = Set(value: [height, weight, birthday, sex])
        
        return readableDataTypes
    }
    
    @IBAction func authorizeHealthKit(sender: UIButton) {
        let writeableDataTypes: Set<HKSampleType> = self.writeableDataTypes()
        let readableDataTypes? = self.writeableDataTypes()
        
        healthStore.requestAuthorizationToShareTypes(<#T##typesToShare: Set<HKSampleType>?##Set<HKSampleType>?#>, readTypes: <#T##Set<HKObjectType>?#>, completion: <#T##(Bool, NSError?) -> Void#>)
    }
}
