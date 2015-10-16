//
//  Exercise.swift
//  Walcott
//
//  Created by David Barsky on 10/16/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import Foundation
import RealmSwift

/// `Exercise` manages the what type of exercise was completed (through `ExerciseType`), and how many sets.
class Exercise: Object {
    private dynamic var rawExerciseName = String()
    var exerciseName: ExerciseType {
        get {
            return ExerciseType(rawValue: self.rawExerciseName)!
        }
        set {
            // `rawValue` is an implicit parameter when initialing ExerciseType.
            self.rawExerciseName = newValue.rawValue
        }
    }
    
    dynamic var setGoal = 0
    let sets = List<Set>() // number of completed sets is the size of a given `sets` list.
}

/// `ExerciseType` maps the different types of exercises that can be recorded.
enum ExerciseType: String {
    case Squat = "Squat"
    case BenchPress = "Bench Press"
    case OverheadPress = "Overhead Press"
    case Deadlift = "Deadlift"
    case BarbellRow = "Barbell Row"
}

/// `Set` manages how many
class Set: Object {
    dynamic var completedNumberOfRepitions = 0
    dynamic var numberOfRepitionsGoal = 0
}