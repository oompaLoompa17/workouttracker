//
//  AddActivity.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import Foundation
import SwiftUI

struct AddActivity: View {
    let date: Date
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: WorkoutTrackerViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var exercise = ""
    @State private var reps = 8
    @State private var sets = 3
    @State private var weights: Int? = nil
    @State private var intensity = 5.0
    @State private var showAlert = false
    @State private var listExists = false
    
    var filteredOptions: [String] {
        if exercise.isEmpty {
            return exercises.map { $0.name }
        } else {
            return exercises.map { $0.name }
                            .filter {$0.lowercased().contains(exercise.lowercased())}
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Date Header
                VStack(spacing: 8) {
                    Text("Workout Session")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(date, style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Exercise Selection Card
                VStack(alignment: .leading, spacing: 16) {
                    Label("Exercise Details", systemImage: "figure.strengthtraining.traditional")
                        .font(.headline)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Exercise")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)
                                TextField("Search exercises...", text: $exercise)
                                    .focused($isTextFieldFocused)
                                if !exercise.isEmpty {
                                    Button(action: { exercise = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(isTextFieldFocused ? 10 : 10, corners: isTextFieldFocused ? [.topLeft, .topRight] : .allCorners)
                            
                            if isTextFieldFocused && !filteredOptions.isEmpty {
                                Divider()
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(filteredOptions.prefix(6), id: \.self) { option in
                                            Button(action: {
                                                exercise = option
                                                isTextFieldFocused = false
                                            }) {
                                                HStack {
                                                    Text(option)
                                                        .foregroundColor(.primary)
                                                    Spacer()
                                                }
                                                .padding()
                                                .background(Color(.systemBackground))
                                            }
                                            if option != filteredOptions.prefix(6).last {
                                                Divider()
                                            }
                                        }
                                    }
                                }
                                .frame(maxHeight: 200)
                                .background(Color(.systemBackground))
                                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    // Reps and Sets
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Reps", systemImage: "repeat")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            Picker("", selection: $reps) {
                                ForEach(1..<31) {
                                    Text("\($0)").tag($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Sets", systemImage: "square.stack.3d.up")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            Picker("", selection: $sets) {
                                ForEach(1..<11) {
                                    Text("\($0)").tag($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    
                    // Weight
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Weight (kg)", systemImage: "scalemass")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        TextField("Optional", value: $weights, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Intensity
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Intensity", systemImage: "flame.fill")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(Int(intensity))/10")
                                .font(.headline)
                                .foregroundColor(intensityColor(intensity))
                        }
                        
                        Slider(value: $intensity, in: 0...10, step: 1)
                            .tint(intensityColor(intensity))
                        
                        HStack {
                            Text("Light")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("Moderate")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("Intense")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Add Activity Button
                Button(action: {
                    if let selectedExercise = exercises.first(where: { $0.name == exercise}) {
                        let activity = Activity(
                            id: UUID(),
                            name: selectedExercise,
                            reps: reps,
                            sets: sets,
                            weight: weights,
                            intensity: Int(intensity)
                        )
                        if viewModel.newWorkout == nil || viewModel.newWorkout!.activities.isEmpty {
                            viewModel.addWorkout(date: date, activity: activity)
                        } else {
                            viewModel.addActivity(activity: activity)
                        }
                        listExists = true
                        
                        // Reset form
                        exercise = ""
                        reps = 8
                        sets = 3
                        weights = nil
                        intensity = 5.0
                    } else {
                        showAlert = true
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Exercise")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(exercise.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(exercise.isEmpty)
                .padding(.horizontal)
                
                // Current Workout Activities
                if let activities = viewModel.newWorkout?.activities, !activities.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Current Workout", systemImage: "list.bullet.clipboard")
                                .font(.headline)
                                .foregroundStyle(.blue)
                            Spacer()
                            Text("\(activities.count) exercises")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        ForEach(Array(activities.enumerated()), id: \.element.id) { index, activity in
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 40, height: 40)
                                    Text("\(index + 1)")
                                        .font(.headline)
                                        .foregroundStyle(.blue)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(activity.name.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    HStack(spacing: 12) {
                                        Label("\(activity.sets)×\(activity.reps)", systemImage: "repeat")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        if let weight = activity.weight {
                                            Label("\(weight)kg", systemImage: "scalemass")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Label("\(activity.intensity)/10", systemImage: "flame.fill")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if var workout = viewModel.newWorkout {
                                        workout.activities.remove(at: index)
                                        viewModel.newWorkout = workout
                                        
                                        // If no activities left, reset listExists
                                        if workout.activities.isEmpty {
                                            listExists = false
                                        }
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Add Activities")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if listExists {
                    Button("Finish") {
                        viewModel.save()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .alert("Invalid Exercise", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please select a valid exercise from the list.")
        }
    }
    
    private func intensityColor(_ value: Double) -> Color {
        switch value {
        case 0...3: return .green
        case 4...6: return .orange
        default: return .red
        }
    }
}

// Helper extension for selective corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    let viewModel = WorkoutTrackerViewModel()
    NavigationStack {
        AddActivity(date: Date())
            .environmentObject(viewModel)
    }
}
