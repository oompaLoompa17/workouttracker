//
//  WorkoutSummary.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 25/10/25.
//

import SwiftUI

struct WorkoutSummary: View {
    let workout: Workout
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                VStack(spacing: 8) {
                    Text(workout.date, style: .date)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(workout.date, style: .time)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("\(workout.activities.count)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                            Text("Exercises")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        VStack(spacing: 4) {
                            Text("\(totalSets)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                            Text("Total Sets")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        VStack(spacing: 4) {
                            Text("\(averageIntensity, specifier: "%.1f")")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                            Text("Avg Intensity")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Activities List
                VStack(alignment: .leading, spacing: 12) {
                    Text("Exercises")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .padding(.horizontal)
                    
                    ForEach(Array(workout.activities.enumerated()), id: \.element.id) { index, activity in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 36, height: 36)
                                    Text("\(index + 1)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.blue)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(activity.exerciseName)
                                        .font(.headline)
                                    
                                    // Muscle groups
                                    if let exercise = activity.exercise {
                                        Text(exercise.muscleGroups.map { $0.rawValue.capitalized }.joined(separator: ", "))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            // Stats Grid
                            HStack(spacing: 12) {
                                StatBadge(icon: "repeat", label: "Reps", value: "\(activity.reps)")
                                StatBadge(icon: "square.stack.3d.up", label: "Sets", value: "\(activity.sets)")
                                
                                if let weight = activity.weight {
                                    StatBadge(icon: "scalemass", label: "Weight", value: "\(weight)kg")
                                }
                                
                                StatBadge(
                                    icon: "flame.fill",
                                    label: "Intensity",
                                    value: "\(activity.intensity)/10",
                                    color: intensityColor(Double(activity.intensity))
                                )
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var totalSets: Int {
        workout.activities.reduce(0) { $0 + $1.sets }
    }
    
    private var averageIntensity: Double {
        guard !workout.activities.isEmpty else { return 0 }
        let total = workout.activities.reduce(0) { $0 + $1.intensity }
        return Double(total) / Double(workout.activities.count)
    }
    
    private func intensityColor(_ value: Double) -> Color {
        switch value {
        case 0...3: return .green
        case 4...6: return .orange
        default: return .red
        }
    }
}

struct StatBadge: View {
    let icon: String
    let label: String
    let value: String
    var color: Color = .blue
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    let sampleWorkout = Workout(
        date: Date(),
        activities: [
            Activity(
                exerciseName: "Bench Press",
                reps: 10,
                sets: 3,
                weight: 80,
                intensity: 7
            ),
            Activity(
                exerciseName: "Pull-Up",
                reps: 8,
                sets: 4,
                weight: nil,
                intensity: 8
            )
        ]
    )
    
    NavigationStack {
        WorkoutSummary(workout: sampleWorkout)
    }
}
