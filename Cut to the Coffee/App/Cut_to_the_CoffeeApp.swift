//
//  Cut_to_the_CoffeeApp.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import SwiftUI
import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("✅ Firebase configured successfully")
        return true
    }
}

@main
struct Cut_to_the_CoffeeApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Observe authentication state
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Background to prevent white flash
                AppTheme.primaryGradient
                    .ignoresSafeArea()
                
                if authManager.isCheckingAuth {
                    // Show loading screen while checking auth status
                    LoadingView()
                        .transition(.opacity)
                        .zIndex(1)
                } else if authManager.isAuthenticated {
                    // User is authenticated - show home page
                    HomeView()
                        .transition(.opacity)
                        .zIndex(2)
                } else {
                    // User is not authenticated - show welcome/sign-in view
                    WelcomeView()
                        .transition(.opacity)
                        .zIndex(3)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: authManager.isCheckingAuth)
            .animation(.easeInOut(duration: 0.4), value: authManager.isAuthenticated)
        }
    }
}
