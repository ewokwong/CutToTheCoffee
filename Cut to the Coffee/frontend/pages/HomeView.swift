//
//  HomeView.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                // Light background
                AppTheme.lightGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Welcome Header
                        VStack(spacing: 8) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 50))
                                .foregroundColor(AppTheme.coffeeBrown)
                            
                            if let userName = authManager.userFullName {
                                Text("Welcome, \(userName)!")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .coffeePrimaryText()
                            } else {
                                Text("Welcome!")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .coffeePrimaryText()
                            }
                            
                            Text("Let's find your next opportunity")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(.top, 40)
                        
                        // Feature Cards
                        VStack(spacing: 16) {
                            // Find Referrers Card
                            NavigationLink(destination: Text("Referrers List").navigationTitle("Find Referrers")) {
                                FeatureCard(
                                    icon: "person.2.fill",
                                    title: "Find Referrers",
                                    description: "Skip the niceties, connect with professionals who can refer you to your dream company"
                                )
                            }
                            
                            // Browse Companies Card
                            NavigationLink(destination: Text("Companies List").navigationTitle("Companies")) {
                                FeatureCard(
                                    icon: "building.2.fill",
                                    title: "Browse Companies",
                                    description: "Explore opportunities at top companies and find the perfect match"
                                )
                            }
                            
                            // Your Requests Card
                            NavigationLink(destination: Text("My Requests").navigationTitle("My Requests")) {
                                FeatureCard(
                                    icon: "message.fill",
                                    title: "Your Requests",
                                    description: "View and manage your referral requests and conversations"
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Sign Out Button (only if authenticated)
                        if authManager.isAuthenticated {
                            Button("Sign Out") {
                                authManager.signOut()
                            }
                            .buttonStyle(.coffeeSecondary)
                            .padding(.top, 20)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Feature Card Component

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.coffeeBrown)
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .coffeePrimaryText()
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(2)
        }
        .padding(20)
        .coffeeCardStyle()
    }
}

#Preview {
    HomeView()
}

