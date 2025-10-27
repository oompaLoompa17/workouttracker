//  Exercise.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import Foundation

struct Exercise: Codable, Hashable {
    let name: String
    let muscleGroups: [MuscleGroup]
    let type: ExerciseType
    let equipment: [Equipment]
}

enum MuscleGroup: String, Codable {
    case chest, back, shoulders, biceps, triceps, quads, hamstrings, glutes, calves, core, fullBody
}

enum ExerciseType: String, Codable {
    case strength, cardio, mobility, plyometric, bodyweight
}

enum Equipment: String, Codable {
    case none, dumbbell, barbell, kettlebell, machine, cable, bench, pullUpBar, resistanceBand
}

let exercises: [Exercise] = [
    // Upper Body - Push
    Exercise(name: "Push-Up", muscleGroups: [.chest, .triceps, .shoulders], type: .bodyweight, equipment: [.none]),
    Exercise(name: "Bench Press", muscleGroups: [.chest, .triceps, .shoulders], type: .strength, equipment: [.barbell, .bench]),
    Exercise(name: "Incline Bench Press", muscleGroups: [.chest, .triceps, .shoulders], type: .strength, equipment: [.barbell, .bench]),
    Exercise(name: "Decline Bench Press", muscleGroups: [.chest, .triceps], type: .strength, equipment: [.barbell, .bench]),
    Exercise(name: "Dumbbell Fly", muscleGroups: [.chest], type: .strength, equipment: [.dumbbell, .bench]),
    Exercise(name: "Chest Press Machine", muscleGroups: [.chest, .triceps], type: .strength, equipment: [.machine]),
    Exercise(name: "Tricep Dip", muscleGroups: [.triceps, .chest], type: .bodyweight, equipment: [.bench, .pullUpBar]),
    Exercise(name: "Overhead Tricep Extension", muscleGroups: [.triceps], type: .strength, equipment: [.dumbbell, .cable]),
    Exercise(name: "Skull Crusher", muscleGroups: [.triceps], type: .strength, equipment: [.barbell, .dumbbell, .bench]),
    Exercise(name: "Shoulder Press", muscleGroups: [.shoulders, .triceps], type: .strength, equipment: [.dumbbell, .barbell]),
    Exercise(name: "Arnold Press", muscleGroups: [.shoulders, .triceps], type: .strength, equipment: [.dumbbell]),
    Exercise(name: "Lateral Raise", muscleGroups: [.shoulders], type: .strength, equipment: [.dumbbell, .cable]),
    Exercise(name: "Front Raise", muscleGroups: [.shoulders], type: .strength, equipment: [.dumbbell, .barbell]),
    
    // Upper Body - Pull
    Exercise(name: "Pull-Up", muscleGroups: [.back, .biceps, .shoulders], type: .bodyweight, equipment: [.pullUpBar]),
    Exercise(name: "Chin-Up", muscleGroups: [.back, .biceps], type: .bodyweight, equipment: [.pullUpBar]),
    Exercise(name: "Barbell Row", muscleGroups: [.back, .biceps], type: .strength, equipment: [.barbell]),
    Exercise(name: "Dumbbell Row", muscleGroups: [.back, .biceps], type: .strength, equipment: [.dumbbell]),
    Exercise(name: "Lat Pulldown", muscleGroups: [.back, .biceps], type: .strength, equipment: [.cable, .machine]),
    Exercise(name: "Seated Cable Row", muscleGroups: [.back, .biceps], type: .strength, equipment: [.cable, .machine]),
    Exercise(name: "Bicep Curl", muscleGroups: [.biceps], type: .strength, equipment: [.dumbbell, .barbell, .cable]),
    Exercise(name: "Hammer Curl", muscleGroups: [.biceps], type: .strength, equipment: [.dumbbell]),
    Exercise(name: "Face Pull", muscleGroups: [.shoulders, .back], type: .strength, equipment: [.cable]),
    Exercise(name: "Rear Delt Fly", muscleGroups: [.shoulders, .back], type: .strength, equipment: [.dumbbell, .cable, .machine]),
    Exercise(name: "Bent-Over Row", muscleGroups: [.back, .biceps], type: .strength, equipment: [.barbell, .dumbbell]),
    
    // Lower Body
    Exercise(name: "Squat", muscleGroups: [.quads, .glutes, .hamstrings], type: .strength, equipment: [.none, .barbell]),
    Exercise(name: "Front Squat", muscleGroups: [.quads, .glutes, .core], type: .strength, equipment: [.barbell]),
    Exercise(name: "Goblet Squat", muscleGroups: [.quads, .glutes, .core], type: .strength, equipment: [.dumbbell, .kettlebell]),
    Exercise(name: "Deadlift", muscleGroups: [.back, .glutes, .hamstrings, .core], type: .strength, equipment: [.barbell]),
    Exercise(name: "Romanian Deadlift", muscleGroups: [.hamstrings, .glutes, .back], type: .strength, equipment: [.barbell, .dumbbell]),
    Exercise(name: "Sumo Deadlift", muscleGroups: [.glutes, .quads, .hamstrings], type: .strength, equipment: [.barbell]),
    Exercise(name: "Lunges", muscleGroups: [.quads, .glutes, .hamstrings], type: .strength, equipment: [.none, .dumbbell]),
    Exercise(name: "Reverse Lunge", muscleGroups: [.quads, .glutes, .hamstrings], type: .strength, equipment: [.none, .dumbbell]),
    Exercise(name: "Bulgarian Split Squat", muscleGroups: [.quads, .glutes], type: .strength, equipment: [.dumbbell, .bench]),
    Exercise(name: "Leg Press", muscleGroups: [.quads, .glutes], type: .strength, equipment: [.machine]),
    Exercise(name: "Leg Curl", muscleGroups: [.hamstrings], type: .strength, equipment: [.machine]),
    Exercise(name: "Leg Extension", muscleGroups: [.quads], type: .strength, equipment: [.machine]),
    Exercise(name: "Calf Raise", muscleGroups: [.calves], type: .strength, equipment: [.none, .machine]),
    Exercise(name: "Step-Up", muscleGroups: [.quads, .glutes], type: .strength, equipment: [.bench, .dumbbell]),
    
    // Core
    Exercise(name: "Plank", muscleGroups: [.core], type: .bodyweight, equipment: [.none]),
    Exercise(name: "Side Plank", muscleGroups: [.core], type: .bodyweight, equipment: [.none]),
    Exercise(name: "Russian Twist", muscleGroups: [.core], type: .bodyweight, equipment: [.none, .dumbbell]),
    Exercise(name: "Hanging Leg Raise", muscleGroups: [.core], type: .bodyweight, equipment: [.pullUpBar]),
    Exercise(name: "Bicycle Crunch", muscleGroups: [.core], type: .bodyweight, equipment: [.none]),
    Exercise(name: "Ab Rollout", muscleGroups: [.core], type: .bodyweight, equipment: [.none]),
    Exercise(name: "Mountain Climbers", muscleGroups: [.core, .fullBody], type: .cardio, equipment: [.none]),
    
    // Full Body / Cardio
    Exercise(name: "Burpee", muscleGroups: [.fullBody], type: .cardio, equipment: [.none]),
    Exercise(name: "Kettlebell Swing", muscleGroups: [.glutes, .hamstrings, .core], type: .plyometric, equipment: [.kettlebell]),
    Exercise(name: "Thruster", muscleGroups: [.fullBody], type: .strength, equipment: [.barbell, .dumbbell]),
    Exercise(name: "Box Jump", muscleGroups: [.quads, .glutes], type: .plyometric, equipment: [.bench]),
    Exercise(name: "Jump Rope", muscleGroups: [.fullBody, .calves], type: .cardio, equipment: [.none]),
    Exercise(name: "Battle Rope", muscleGroups: [.fullBody, .shoulders], type: .cardio, equipment: [.none]),
    Exercise(name: "Sled Push", muscleGroups: [.fullBody], type: .cardio, equipment: [.none]),
    
    // Climbing
    Exercise(name: "Abrahang", muscleGroups: [.core, .biceps], type: .bodyweight, equipment: [.pullUpBar]),
    Exercise(name: "Hangboard", muscleGroups: [.biceps, .back], type: .strength, equipment: [.none]),
    Exercise(name: "Block Pull (Half-Crimp)", muscleGroups: [.biceps, .back], type: .strength, equipment: [.none]),
    Exercise(name: "Block Pull (Drag)", muscleGroups: [.biceps, .back], type: .strength, equipment: [.none]),
    Exercise(name: "Block Pull (Pinkie)", muscleGroups: [.biceps, .back], type: .strength, equipment: [.none]),
    Exercise(name: "Block Pull (Index)", muscleGroups: [.biceps, .back], type: .strength, equipment: [.none]),
    Exercise(name: "Block Pull (Middle Finger)", muscleGroups: [.biceps, .back], type: .strength, equipment: [.none]),
    Exercise(name: "Block Pull (Finger Curl)", muscleGroups: [.biceps, .back], type: .strength, equipment: [.none]),
    Exercise(name: "Block Pinch", muscleGroups: [.biceps, .back], type: .strength, equipment: [.none]),
    Exercise(name: "One-Arm Hang", muscleGroups: [.back, .biceps], type: .bodyweight, equipment: [.pullUpBar]),
    Exercise(name: "Two-Arm Hang", muscleGroups: [.back, .biceps], type: .bodyweight, equipment: [.pullUpBar]),
    Exercise(name: "Weighted Pull-Up", muscleGroups: [.back, .biceps], type: .strength, equipment: [.pullUpBar]),
    Exercise(name: "Wrist Curl", muscleGroups: [.biceps], type: .strength, equipment: [.dumbbell, .barbell]),
    Exercise(name: "Wrist Extension", muscleGroups: [.biceps], type: .strength, equipment: [.dumbbell, .barbell]),
    Exercise(name: "Wrist Side-to-Side", muscleGroups: [.biceps], type: .mobility, equipment: [.none]),
    
    // Rehab
    Exercise(name: "Shoulder External Rotation", muscleGroups: [.shoulders], type: .mobility, equipment: [.resistanceBand]),
    Exercise(name: "Shoulder Internal Rotation", muscleGroups: [.shoulders], type: .mobility, equipment: [.resistanceBand]),
    Exercise(name: "Cat-Cow Stretch", muscleGroups: [.core, .back], type: .mobility, equipment: [.none]),
    Exercise(name: "Glute Bridge", muscleGroups: [.glutes, .hamstrings], type: .bodyweight, equipment: [.none]),
    Exercise(name: "Clamshell", muscleGroups: [.glutes], type: .bodyweight, equipment: [.resistanceBand]),
    Exercise(name: "Bird Dog", muscleGroups: [.core, .back], type: .bodyweight, equipment: [.none]),
    Exercise(name: "Wall Angels", muscleGroups: [.shoulders, .back], type: .mobility, equipment: [.none]),
    Exercise(name: "Ankle Circles", muscleGroups: [.calves], type: .mobility, equipment: [.none]),
    Exercise(name: "Knee-to-Chest Stretch", muscleGroups: [.glutes, .hamstrings], type: .mobility, equipment: [.none]),
    Exercise(name: "Seated Forward Fold", muscleGroups: [.hamstrings, .back], type: .mobility, equipment: [.none])
]
