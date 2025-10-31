//
//  FirebaseService.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 29/10/25.
//

import Foundation
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    private let workoutsCollection = "workouts"
    
    // Optional: add user ID for multi-user support
    private var userId: String {
        // For now, use a device-specific ID
        // Later, integrate with FirebaseAuth
//        UIDevice.current.identifierForVendor?.uuidString ?? "default_user"
        
        AuthService.shared.currentUserId ?? "anonymous"
    }
    
    // MARK: - Create
    func saveWorkout(_ workout: Workout) async throws {
        let workoutData: [String: Any] = [ // firebase expects dictionaries, not custom structs
            "date": Timestamp(date: workout.date),
            "activities": workout.activities.map { activity in
                [
                    "id": activity.id,
                    "exerciseName": activity.exerciseName,
                    "reps": activity.reps,
                    "sets": activity.sets,
                    "weight": activity.weight as Any,
                    "intensity": activity.intensity
                ]
            },
            "userId": userId
        ]
        
        if let id = workout.id {
            // update existing workout
            try await db.collection(workoutsCollection).document(id).setData(workoutData)
        } else {
            // Create new workout
            _ = try await db.collection(workoutsCollection).addDocument(data: workoutData)
        }
    }
    
    // MARK: - Read
    func fetchWorkouts() async throws -> [Workout] {
        let snapshot = try await db.collection(workoutsCollection)
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in // compactMap removes any that fail to decode
            try? document.data(as: Workout.self)
        }
    }
    
    func fetchWorkout(id: String) async throws -> Workout? {
        let document = try await db.collection(workoutsCollection).document(id).getDocument()
        return try? document.data(as: Workout.self)
    }
    
    // MARK: - Update
    func updateWorkout(_ workout: Workout) async throws {
        if workout.id == nil {
            throw FirebaseError.missingDocumentID
        }
        try await saveWorkout(workout)
    }
    
    // MARK: - Delete
    func deleteWorkout(id: String) async throws {
        try await db.collection(workoutsCollection).document(id).delete()
    }
    
    // MARK: - Real-time Listener (unlike fetchWorkouts() which fetches once, this continuously listens)
    // returns ListenerRegistration so you can stop listening later
    /*
         // Start listening
         let listener = firebaseService.listenToWorkouts { newWorkouts in
             self.workouts = newWorkouts  // Auto-updates!
         }

         // Stop listening (to save resources)
         listener.remove()
     */
    func listenToWorkouts(completion: @escaping ([Workout]) -> Void) -> ListenerRegistration {
        return db.collection(workoutsCollection)
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching workouts: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let workouts = documents.compactMap { document in
                    try? document.data(as: Workout.self)
                }
                completion(workouts)
            }
    }
}

enum FirebaseError: Error {
    case missingDocumentID
    case encodingFailed
    case decodingFailed
}
