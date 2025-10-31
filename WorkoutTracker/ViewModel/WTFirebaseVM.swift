//
//  WTFirebaseVM.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 29/10/25.
//

import Foundation
import FirebaseFirestore

class WTFirebaseVM: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var newWorkout: Workout?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let firebaseService = FirebaseService.shared
    private var listener: ListenerRegistration?
    
    init() {
        // Option 1: Fetch once
        Task {
            await loadWorkouts()
        }
        
        // Option 2: Real-time listener (better UX)
        // setupListener()
    }
    
    deinit {
        listener?.remove()
    }
    
    // MARK: - Setup Real-time Listener
    func setupListener() {
        listener = firebaseService.listenToWorkouts { [weak self] workouts in
            DispatchQueue.main.async {
                self?.workouts = workouts
            }
        }
    }
    
    // MARK: - Load Workouts
    @MainActor
    func loadWorkouts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            workouts = try await firebaseService.fetchWorkouts()
        } catch {
            errorMessage = "Failed to load workouts: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Save Workout
    @MainActor
    func save() async {
        guard let workout = newWorkout else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await firebaseService.saveWorkout(workout)
            // Refresh workouts
            await loadWorkouts()
            newWorkout = nil
        } catch {
            errorMessage = "Failed to save workout: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Delete Workout
    @MainActor
    func deleteWorkout(_ workout: Workout) async {
        guard let id = workout.id else { return }
        
        do {
            try await firebaseService.deleteWorkout(id: id)
            await loadWorkouts()
        } catch {
            errorMessage = "Failed to delete workout: \(error.localizedDescription)"
        }
    }
    
    // ... rest of your existing methods
    func addWorkout(date: Date, activity: Activity) {
        newWorkout = Workout(date: date, activities: [activity])
    }
    
    func addActivity(activity: Activity) {
        guard var workout = newWorkout else { return }
        workout.activities.append(activity)
        newWorkout = workout
    }
    
    func removeActivity(at index: Int) {
        guard var workout = newWorkout else { return }
        workout.activities.remove(at: index)
        newWorkout = workout
    }
    
    func muscleGroupsWorked() -> [MuscleGroupData] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Calculate the start date (7 days ago, inclusive of today)
        guard let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: currentDate)) else {
            return []
        }
        
        let lastSevenDays = workouts
            .sorted(by: {$0.date > $1.date})
            .filter { workout in
                workout.date >= startDate && workout.date <= currentDate
            }
        
        var muscleGroupSets: [MuscleGroup: Int] = [:]
        
        for workout in lastSevenDays {
            for activity in workout.activities {
                let muscleGroups = activity.exercise!.muscleGroups
                
                for muscleGroup in muscleGroups {
                    muscleGroupSets[muscleGroup, default: 0] += activity.sets
                }
            }
        }
        return muscleGroupSets.map { muscleGroup, sets in
            MuscleGroupData(muscleGroup: muscleGroup.rawValue.capitalized, sets: sets)
        }.sorted { $0.muscleGroup < $1.muscleGroup} //sorts alphabetically
    }
}
