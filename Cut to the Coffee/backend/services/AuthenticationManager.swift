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
    
    // MARK: - Singleton
    
    static let shared = AuthenticationManager()
    
    // MARK: - UserDefaults Keys
    
    private let isAuthenticatedKey = "isAuthenticated"
    private let userIdKey = "userId"
    private let userFullNameKey = "userFullName"
    private let userEmailKey = "userEmail"
    
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
        
        // Save authentication state
        saveAuthenticationState(
            userId: userId,
            fullName: fullName,
            email: email
        )
        
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
    private func saveAuthenticationState(userId: String, fullName: String?, email: String?) {
        UserDefaults.standard.set(true, forKey: isAuthenticatedKey)
        UserDefaults.standard.set(userId, forKey: userIdKey)
        
        if let fullName = fullName {
            UserDefaults.standard.set(fullName, forKey: userFullNameKey)
        }
        
        if let email = email {
            UserDefaults.standard.set(email, forKey: userEmailKey)
        }
        
        // Update published properties
        DispatchQueue.main.async {
            self.isAuthenticated = true
            self.currentUserId = userId
            self.userFullName = fullName
            self.userEmail = email
        }
    }
    
    /// Sign out the current user
    func signOut() {
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: isAuthenticatedKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userFullNameKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        
        // Update published properties
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.currentUserId = nil
            self.userFullName = nil
            self.userEmail = nil
        }
        
        print("✅ Successfully signed out")
    }
    
    /// Continue as guest (without authentication)
    func continueAsGuest() {
        DispatchQueue.main.async {
            self.isCheckingAuth = false
        }
        print("ℹ️ Continuing as guest")
    }
}

