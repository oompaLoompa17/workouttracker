//
//  Chart.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import Charts
import SwiftUI
import Foundation

struct MuscleGroupData: Identifiable {
    let id = UUID()
    let muscleGroup: String
    let sets: Int
}

struct BarChart: View {
    let chartData: [MuscleGroupData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Summary Stats
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Sets")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(totalSets)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Muscle Groups")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(chartData.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
                
                Spacer()
            }
            
            // Chart
            Chart(chartData) { data in
                BarMark(
                    x: .value("Muscle Group", data.muscleGroup),
                    y: .value("Sets", data.sets)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(6)
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.2))
                    AxisValueLabel()
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 250)
            
            // Top Muscle Groups
            if !chartData.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Top 3 Muscle Groups")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                    
                    ForEach(Array(topThreeMuscleGroups.enumerated()), id: \.element.id) { index, data in
                        HStack {
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(width: 20, height: 20)
                                .background(medalColor(for: index))
                                .clipShape(Circle())
                            
                            Text(data.muscleGroup)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("\(data.sets) sets")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
            }
        }
    }
    
    private var totalSets: Int {
        chartData.reduce(0) { $0 + $1.sets }
    }
    
    private var topThreeMuscleGroups: [MuscleGroupData] {
        Array(chartData.sorted { $0.sets > $1.sets }.prefix(3))
    }
    
    private func medalColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow
        case 1: return .gray
        case 2: return .orange
        default: return .blue
        }
    }
}

#Preview {
    VStack {
        BarChart(chartData: [
            MuscleGroupData(muscleGroup: "Chest", sets: 12),
            MuscleGroupData(muscleGroup: "Back", sets: 15),
            MuscleGroupData(muscleGroup: "Legs", sets: 18),
            MuscleGroupData(muscleGroup: "Arms", sets: 10),
            MuscleGroupData(muscleGroup: "Shoulders", sets: 8)
        ])
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
