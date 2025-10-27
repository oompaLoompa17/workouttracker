//
//  WorkoutTrackerViewModel.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import Foundation

class WorkoutTrackerViewModel: ObservableObject {
    
    @Published var workouts: [Workout]
    @Published var newWorkout: Workout?
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "SavedWorkouts") {
            if let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
                workouts = decoded
                return
            }
        }
        workouts = []
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
    
    func save() {
        guard let workout = newWorkout else { return }
        workouts.append(workout)
        
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: "SavedWorkouts")
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
