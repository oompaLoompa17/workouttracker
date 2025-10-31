//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import Foundation
import FirebaseFirestore

struct Workout: Codable, Hashable, Identifiable {
    @DocumentID var id: String? // Firestore document ID
    let date: Date
    var activities: [Activity]
    
    // for firestore timestamps
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case activities
    }
}

struct Activity: Codable, Identifiable, Hashable {
    var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let exerciseSlug = exerciseName.lowercased().replacingOccurrences(of: " ", with: "-")
        let timestamp = Int(Date().timeIntervalSince1970)
        return "\(dateString)_\(exerciseSlug)_\(timestamp)"
    }
    let exerciseName: String // store just the name; firestore doesnt handle NESTED custom structs well
    let reps: Int
    let sets: Int
    let weight: Int?
    let intensity: Int
    
    // Helper to get full Exercise object
    var exercise: Exercise? {
        exercises.first {$0.name == exerciseName }
    }
}
