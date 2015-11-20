//
//  Workout.swift
//  Walcott
//
//  Created by David Barsky on 10/16/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import Foundation
import RealmSwift

class Workout: Object {
    dynamic var exerciseDate = NSDate(timeIntervalSince1970: 1)
    let sets = List<Set>()
}