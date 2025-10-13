//
//  WelcomeView.swift
//  Cut to the Coffee
//
//  Welcome screen with sign-in options
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    
    @State private var isAnimating = false
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background gradient using theme
            AppTheme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Coffee cup icon with animation
                ZStack {
                    // Steam effect
                    VStack(spacing: 5) {
                        ForEach(0..<3) { index in
                            Image(systemName: "cloud.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.creamWhite.opacity(0.6))
                                .offset(y: isAnimating ? -20 : 0)
                                .opacity(isAnimating ? 0 : 0.8)
                                .animation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(index) * 0.3),
                                    value: isAnimating
                                )
                        }
                    }
                    .offset(y: -40)
                    
                    // Coffee cup
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppTheme.pureWhite)
                        .rotationEffect(.degrees(isAnimating ? 5 : -5))
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                .padding(.bottom, 20)
                
                // App name
                Text("Cut to the Coffee")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.creamWhite)
                    .opacity(opacity)
                
                Spacer()
                
                // Sign-in buttons
                VStack(spacing: 16) {
                    // Sign in with Apple button (hardcoded for now)
                    Button {
                        // TODO: Replace with actual Sign in with Apple integration
                        // For now, hardcode authentication with placeholder data
                        let placeholderUserId = "placeholder_user_\(UUID().uuidString.prefix(8))"
                        let placeholderName = "Test User"
                        let placeholderEmail = "testuser@example.com"
                        
                        // Save auth state with placeholder data
                        UserDefaults.standard.set(true, forKey: "isAuthenticated")
                        UserDefaults.standard.set(placeholderUserId, forKey: "userId")
                        UserDefaults.standard.set(placeholderName, forKey: "userFullName")
                        UserDefaults.standard.set(placeholderEmail, forKey: "userEmail")
                        
                        // Update auth manager
                        DispatchQueue.main.async {
                            authManager.isAuthenticated = true
                            authManager.currentUserId = placeholderUserId
                            authManager.userFullName = placeholderName
                            authManager.userEmail = placeholderEmail
                            authManager.needsOnboarding = true // Force onboarding for new users
                        }
                        
                        print("✅ Signed in with placeholder data")
                        print("   User ID: \(placeholderUserId)")
                        print("   Name: \(placeholderName)")
                        print("   Email: \(placeholderEmail)")
                    } label: {
                        HStack {
                            Image(systemName: "applelogo")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Sign in with Apple")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    
                    // Spacer and description for explore network
                    VStack(spacing: 8) {
                        Text("Just looking around?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.textOnDark.opacity(0.9))
                        
                        // Explore network button
                        Button {
                            // Continue as guest
                            authManager.continueAsGuest()
                        } label: {
                            Text("Explore Our Network")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.coffeeBrown)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(AppTheme.creamWhite)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.top, 8)
                }
                .opacity(opacity)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1.0
            }
        }
    }
}

#Preview {
    WelcomeView()
}

