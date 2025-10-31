//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 21/10/25.
//

import SwiftUI
import FirebaseCore

@main
struct WorkoutTrackerApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
