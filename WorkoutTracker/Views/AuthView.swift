//
//  AuthView.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 29/10/25.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var authService = AuthService.shared
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo/Header
                    VStack(spacing: 8) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        Text("Workout Tracker")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(isLoginMode ? "Welcome back!" : "Create your account")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Input Fields
                    VStack(spacing: 16) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Email", systemImage: "envelope")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            TextField("your@email.com", text: $email)
                                .textContentType(.emailAddress)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Password", systemImage: "lock")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            SecureField("••••••••", text: $password)
                                .textContentType(isLoginMode ? .password : .newPassword)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Confirm Password (Sign Up only)
                        if !isLoginMode {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Confirm Password", systemImage: "lock.fill")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                
                                SecureField("••••••••", text: $confirmPassword)
                                    .textContentType(.newPassword)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action Button
                    Button(action: handleAuth) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: isLoginMode ? "arrow.right.circle.fill" : "person.badge.plus")
                                Text(isLoginMode ? "Sign In" : "Create Account")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(!isFormValid || isLoading)
                    .padding(.horizontal)
                    
                    // Toggle Mode
                    Button(action: {
                        withAnimation {
                            isLoginMode.toggle()
                            confirmPassword = ""
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(isLoginMode ? "Don't have an account?" : "Already have an account?")
                                .foregroundStyle(.secondary)
                            Text(isLoginMode ? "Sign Up" : "Sign In")
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                        }
                        .font(.subheadline)
                    }
                    
                    // Forgot Password
                    if isLoginMode {
                        Button(action: handleForgotPassword) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Validation
    private var isFormValid: Bool {
        if isLoginMode {
            return !email.isEmpty && !password.isEmpty && isValidEmail(email)
        } else {
            return !email.isEmpty &&
                   !password.isEmpty &&
                   !confirmPassword.isEmpty &&
                   password == confirmPassword &&
                   password.count >= 6 &&
                   isValidEmail(email)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: - Actions
    private func handleAuth() {
        isLoading = true
        
        Task {
            do {
                if isLoginMode {
                    try await authService.signIn(email: email, password: password)
                } else {
                    if password != confirmPassword {
                        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Passwords don't match"])
                    }
                    try await authService.signUp(email: email, password: password)
                }
            } catch let error as NSError {
                await MainActor.run {
                    errorMessage = mapFirebaseError(error)
                    showError = true
                    isLoading = false
                }
            }
        }
    }
    
    private func handleForgotPassword() {
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            showError = true
            return
        }
        
        Task {
            do {
                try await authService.resetPassword(email: email)
                await MainActor.run {
                    errorMessage = "Password reset email sent!"
                    showError = true
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
    
    private func mapFirebaseError(_ error: NSError) -> String {
        switch error.code {
        case 17007:
            return "This email is already registered."
        case 17008, 17009:
            return "Invalid email or password."
        case 17011:
            return "User not found."
        case 17026:
            return "Password must be at least 6 characters."
        case 17020:
            return "Network error. Please check your connection."
        default:
            return error.localizedDescription
        }
    }
}

#Preview {
    AuthView()
}
