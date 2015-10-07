//
//  ViewController.swift
//  Walcott
//
//  Created by David Barsky on 9/21/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authorizeHealthKit(sender: UIButton) {
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable() {
                return HKHealthStore()
            } else {
                return nil
            }
            }()
        
        let dateOfBirthCharacteristic = HKCharacteristicType.characteristicTypeForIdentifier(
            HKCharacteristicTypeIdentifierDateOfBirth)
        
        let biologicalSexCharacteristic = HKCharacteristicType.characteristicTypeForIdentifier(
            HKCharacteristicTypeIdentifierBiologicalSex)
        
        let bloodTypeCharacteristic = HKCharacteristicType.characteristicTypeForIdentifier(
            HKCharacteristicTypeIdentifierBloodType)
        
        let dataTypesToRead = NSSet(objects:
            dateOfBirthCharacteristic,
            biologicalSexCharacteristic,
            bloodTypeCharacteristic)
        
        healthStore?.requestAuthorizationToShareTypes(nil,
            readTypes: dataTypesToRead,
            completion: { (success, error) -> Void in
                if success {
                    println("success")
                } else {
                    println(error.description)
                }
        })
        
    }
}
