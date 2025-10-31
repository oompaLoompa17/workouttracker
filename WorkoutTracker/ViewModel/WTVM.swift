//
//  WorkoutTrackerViewModel.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import Foundation

/*
class WTVM: ObservableObject {
    
    @Published var workouts: [Workout]
    @Published var newWorkout: Workout?
    
    private let fileName = "workouts.json"
    
    private var fileURL: URL? {
        try? FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(fileName)
    }
    
    init() {
        // Can't use async in init, so load synchronously or trigger async load
        workouts = []
        
        // Option 1: Load synchronously (simple but blocks)
        // loadWorkoutsSync()
        
        // Option 2: Trigger async load (better UX)
        Task {
            await loadWorkouts()
        }
    }
    
    // Synchronous load (if you want to call in init)
    private func loadWorkoutsSync() {
        guard let fileURL = fileURL else { return }
                
        do {
            let data = try Data(contentsOf: fileURL)
            workouts = try JSONDecoder().decode([Workout].self, from: data)
        } catch {
            print("Failed to load workouts: \(error)")
            workouts = []
        }
    }
    
    // Async load (preferred for better performance)
    func loadWorkouts() async {
        guard let fileURL = fileURL else { return }
        
        do {
            // read file on background thread
            let data = try await Task { // async alone doesnt move to background, tasks do that
                try Data(contentsOf: fileURL)
            }.value // 'await' waits for completion here
            
            // decode on background thread
            let decoded = try await Task {
                try JSONDecoder().decode([Workout].self, from:data)
            }.value
            
            await MainActor.run { // Explicitly switch to main thread for UI update
                self.workouts = decoded
            }
        } catch {
            await MainActor.run {
                print("Failed to load workouts: \(error)")
                self.workouts = []
            }
        }
    }
    
    // Async save
    func save() async {
        guard let workout = newWorkout,
              let fileURL = fileURL else { return }
        
        // Update model on main thread (since it's @Published)
        await MainActor.run {
            self.workouts.append(workout)
            self.newWorkout = nil
        }
        
        // Do heavy work in background
        do {
            try await Task {
                let data = try JSONEncoder().encode(self.workouts)
                try data.write(to: fileURL)
            }.value
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func addWorkout(date: Date, activity: Activity) {
        newWorkout = Workout(id: UUID(), date: date, activities: [activity])
        workouts = workouts.sorted(by: { $0.date > $1.date })
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
    
    func saveSync() {
        guard let workout = newWorkout else { return }
        guard let fileURL = fileURL else { return }
        workouts.append(workout)
        
        // MARK: Saving via UserDefaults
//        if let encoded = try? JSONEncoder().encode(workouts) {
//            UserDefaults.standard.set(encoded, forKey: "SavedWorkouts")
//        }
        
        // MARK: Saving via URL (app support directory)
        do {
            let data = try JSONEncoder().encode(workouts)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save workouts: \(error)")
        }
        
        newWorkout = nil
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
                let muscleGroups = activity.name.muscleGroups
                
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

enum WorkoutError: Error {
    case fileURLNotFound
    case encodingFailed
    case DecodingFailed
}
*/
