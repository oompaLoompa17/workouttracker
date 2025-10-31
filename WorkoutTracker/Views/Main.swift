//
//  Main.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import Foundation
import SwiftUI
import Charts

struct Main: View {
    @StateObject private var viewModel = WTFirebaseVM()
    @State private var selectedDate = Date()
    @State private var path = NavigationPath()
    
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDate = Date()
        let distantPast = calendar.date(byAdding: .year, value: -50, to: currentDate)!
        let startOfCurrentDay = calendar.startOfDay(for: currentDate)
        return distantPast...startOfCurrentDay
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Card with Date Picker
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                                .font(.title2)
                                .foregroundStyle(.blue)
                            Text("New Workout")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        DatePicker(
                            "Workout Date",
                            selection: $selectedDate,
                            in: dateRange,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)
                        .tint(.blue)
                        
                        Button(action: {
                            path.append(selectedDate)
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Start Workout")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Stats Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .font(.title3)
                                .foregroundStyle(.blue)
                            Text("Weekly Progress")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            Text("Last 7 Days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                        }
                        
                        if !viewModel.muscleGroupsWorked().isEmpty {
                            BarChart(chartData: viewModel.muscleGroupsWorked())
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary)
                                Text("No workout data yet")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                Text("Start tracking your workouts to see your progress")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Recent Workouts Summary
                    if !viewModel.workouts.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .font(.title3)
                                    .foregroundStyle(.blue)
                                Text("Recent Workouts")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            
                            ForEach(viewModel.workouts.sorted(by: { $0.date > $1.date }).prefix(5), id: \.id) { workout in // \. (key path) is used to refer to properties of types without directly accessing their values
                                Button(action: {
                                    path.append(workout)
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(workout.date, style: .date)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            Text("\(workout.activities.count) exercises")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundStyle(.tertiary)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Workout Tracker")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive, action: {
                            Task {
                                try? AuthService.shared.signOut()
                            }
                        }) {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.title3)
                    }
                }
            }
            .navigationDestination(for: Date.self) { date in
                AddActivity(date: date)
                    .environmentObject(viewModel)
            }
            .navigationDestination(for: Workout.self) { workout in
                WorkoutSummary(workout: workout)
            }
        }
    }
}

#Preview {
    Main()
}
