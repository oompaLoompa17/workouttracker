//
//  RootView.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 29/10/25.
//

import Foundation
import SwiftUI

struct RootView: View {
    @StateObject private var authService = AuthService.shared
        
    var body: some View {
        Group {
            if authService.isAuthenticated {
                Main()
                    .transition(.opacity)
            } else {
                AuthView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: authService.isAuthenticated)
    }
}
