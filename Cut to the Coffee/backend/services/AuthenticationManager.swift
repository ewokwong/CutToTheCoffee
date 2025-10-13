//
//  AuthenticationManager.swift
//  Cut to the Coffee
//
//  Authentication state management for the app
//

import Foundation
import SwiftUI
import Combine
import AuthenticationServices

/// Manages user authentication state throughout the app
class AuthenticationManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current authentication state
    @Published var isAuthenticated: Bool = false
    
    /// Whether the initial auth check is complete
    @Published var isCheckingAuth: Bool = true
    
    /// Current user ID (Apple user identifier)
    @Published var currentUserId: String?
    
    /// User's full name (if available)
    @Published var userFullName: String?
    
    /// User's email (if available)
    @Published var userEmail: String?
    
    /// Whether the user needs to complete onboarding
    @Published var needsOnboarding: Bool = false
    
    /// Whether the user is browsing as a guest
    @Published var isGuestMode: Bool = false
    
    // MARK: - Singleton
    
    static let shared = AuthenticationManager()
    
    // MARK: - UserDefaults Keys
    
    private let isAuthenticatedKey = "isAuthenticated"
    private let userIdKey = "userId"
    private let userFullNameKey = "userFullName"
    private let userEmailKey = "userEmail"
    private let onboardingCompletedKey = "onboardingCompleted"
    
    // MARK: - Initialization
    
    private init() {
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Methods
    
    /// Check if user is already authenticated (e.g., on app launch)
    func checkAuthenticationStatus() {
        // Check UserDefaults for saved auth state
        isAuthenticated = UserDefaults.standard.bool(forKey: isAuthenticatedKey)
        currentUserId = UserDefaults.standard.string(forKey: userIdKey)
        userFullName = UserDefaults.standard.string(forKey: userFullNameKey)
        userEmail = UserDefaults.standard.string(forKey: userEmailKey)
        
        // Check if onboarding has been completed
        let onboardingCompleted = UserDefaults.standard.bool(forKey: onboardingCompletedKey)
        needsOnboarding = isAuthenticated && !onboardingCompleted
        
        // Complete the auth check with a minimum loading time for smooth UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isCheckingAuth = false
        }
    }
    
    /// Handle successful Sign in with Apple authentication
    func signInWithApple(authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ Failed to get Apple ID credential")
            return
        }
        
        let userId = appleIDCredential.user
        
        // Get user information
        var fullName: String?
        if let givenName = appleIDCredential.fullName?.givenName,
           let familyName = appleIDCredential.fullName?.familyName {
            fullName = "\(givenName) \(familyName)"
        }
        
        let email = appleIDCredential.email
        
        // Save authentication state and check onboarding status
        Task {
            let needsOnboarding = await checkNeedsOnboarding(appleUserId: userId)
            
            await MainActor.run {
                saveAuthenticationState(
                    userId: userId,
                    fullName: fullName,
                    email: email,
                    needsOnboarding: needsOnboarding
                )
            }
        }
        
        print("✅ Successfully signed in with Apple")
        print("   User ID: \(userId)")
        if let name = fullName {
            print("   Name: \(name)")
        }
        if let email = email {
            print("   Email: \(email)")
        }
    }
    
    /// Save authentication state to UserDefaults
    private func saveAuthenticationState(userId: String, fullName: String?, email: String?, needsOnboarding: Bool? = nil) {
        UserDefaults.standard.set(true, forKey: isAuthenticatedKey)
        UserDefaults.standard.set(userId, forKey: userIdKey)
        
        if let fullName = fullName {
            UserDefaults.standard.set(fullName, forKey: userFullNameKey)
        }
        
        if let email = email {
            UserDefaults.standard.set(email, forKey: userEmailKey)
        }
        
        // Update published properties
        self.isAuthenticated = true
        self.currentUserId = userId
        self.userFullName = fullName
        self.userEmail = email
        
        // Set onboarding status
        if let needsOnboarding = needsOnboarding {
            // Use the provided onboarding status (from checking Student profile)
            self.needsOnboarding = needsOnboarding
        } else {
            // Fallback: check if onboarding was previously completed
            let onboardingCompleted = UserDefaults.standard.bool(forKey: self.onboardingCompletedKey)
            self.needsOnboarding = !onboardingCompleted
        }
    }
    
    /// Mark onboarding as completed
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingCompletedKey)
        
        DispatchQueue.main.async {
            self.needsOnboarding = false
        }
        
        print("✅ Onboarding completed")
    }
    
    /// Sign out the current user
    func signOut() {
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: isAuthenticatedKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userFullNameKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: onboardingCompletedKey)
        
        // Update published properties
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.currentUserId = nil
            self.userFullName = nil
            self.userEmail = nil
            self.needsOnboarding = false
            self.isGuestMode = false
        }
        
        print("✅ Successfully signed out")
    }
    
    /// Continue as guest (without authentication)
    func continueAsGuest() {
        DispatchQueue.main.async {
            self.isCheckingAuth = false
            self.isGuestMode = true
        }
        print("ℹ️ Continuing as guest")
    }
    
    /// Exit guest mode and return to welcome screen
    func exitGuestMode() {
        DispatchQueue.main.async {
            self.isGuestMode = false
        }
        print("ℹ️ Exiting guest mode")
    }
    
    /// Check if user needs onboarding by fetching their Student profile
    /// Returns true if no profile exists OR if profile exists but has no resumeURL
    func checkNeedsOnboarding(appleUserId: String) async -> Bool {
        let repository = StudentRepository()
        
        do {
            // Try to fetch student by Apple User ID
            let student = try await repository.fetchByAppleUserId(appleUserId)
            
            if let student = student {
                // Student profile exists - check if they have a resume
                let hasResume = student.resumeURL != nil && !student.resumeURL!.isEmpty
                print("ℹ️ Student profile found. Has resume: \(hasResume)")
                return !hasResume // Needs onboarding if no resume
            } else {
                // No student profile exists - needs onboarding
                print("ℹ️ No student profile found. Needs onboarding.")
                return true
            }
        } catch {
            print("⚠️ Error checking onboarding status: \(error.localizedDescription)")
            // If error, assume needs onboarding to be safe
            return true
        }
    }
}

