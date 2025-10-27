//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import Foundation

struct Workout: Codable, Hashable {
    let id: UUID
    let date: Date // and time?
    var activities: [Activity]
}

struct Activity: Codable, Identifiable, Hashable {
    let id: UUID
    let name: Exercise
    let reps: Int
    let sets: Int
    let weight: Int?
    let intensity: Int
}
