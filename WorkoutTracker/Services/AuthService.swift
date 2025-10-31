//
//  FirebaseAuth.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 29/10/25.
//

import Foundation
import FirebaseAuth

class AuthService: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    
    static let shared = AuthService()
    
    private init() {
        // Check if user is already logged in
        self.user = Auth.auth().currentUser
        self.isAuthenticated = user != nil
        
        // listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isAuthenticated = user != nil
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        await MainActor.run {
            self.user = result.user
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        await MainActor.run {
            self.user = result.user
        }
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
        self.user = nil
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Delete Account
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        try await user.delete()
        await MainActor.run {
            self.user = nil
        }
    }
    
    // MARK: - Get Current User ID
    var currentUserId: String? {
        return user?.uid
    }
}

enum AuthError: LocalizedError {
    case userNotFound
    case invalidCredentials
    case weakPassword
    case emailAlreadyInUse
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "No user found with this email."
        case .invalidCredentials:
            return "Invalid email or password."
        case .weakPassword:
            return "Password must be at least 6 characters."
        case .emailAlreadyInUse:
            return "This email is already registered."
        }
    }
}
