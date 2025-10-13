//
//  AnonymousNetworkView.swift
//  Cut to the Coffee
//
//  Anonymous network browsing view for guest users
//

import SwiftUI

struct AnonymousNetworkView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    
    let companies = ["Google", "Meta", "Apple", "Amazon", "Microsoft", "Netflix", "Stripe"]
    let sampleProfiles = [
        ("Sarah Chen", "Google", "Senior Software Engineer"),
        ("Michael Rodriguez", "Meta", "Product Manager"),
        ("Emily Wang", "Apple", "iOS Engineer"),
        ("David Kim", "Amazon", "Software Development Engineer"),
        ("Jessica Lee", "Microsoft", "Cloud Solutions Architect"),
        ("James Park", "Netflix", "Backend Engineer"),
        ("Rachel Brown", "Stripe", "Engineering Manager"),
        ("Alex Johnson", "Google", "Staff Engineer"),
        ("Sophia Martinez", "Meta", "Data Scientist"),
        ("Chris Taylor", "Apple", "Design Lead")
    ]
    
    var body: some View {
        ZStack {
            // Light background
            AppTheme.lightGradient
                .ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    Text("Some of our profiles")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .coffeePrimaryText()
                        .padding(.horizontal, 20)
                        .padding(.top, 60)
                    
                    // Filter by company
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Filter by company")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(companies, id: \.self) { company in
                                    Text(company)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppTheme.coffeeBrown)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(AppTheme.creamWhite)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(AppTheme.coffeeBrown, lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // Profiles list
                    VStack(spacing: 12) {
                        ForEach(0..<10) { index in
                            ProfileCard(
                                name: sampleProfiles[index].0,
                                company: sampleProfiles[index].1,
                                role: sampleProfiles[index].2
                            )
                        }
                        
                        // Sign in prompt after 10 profiles
                        VStack(spacing: 16) {
                            Text("Sign in to view full profiles and the rest of the list")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Button {
                                authManager.exitGuestMode()
                            } label: {
                                Text("Sign In")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppTheme.creamWhite)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(AppTheme.coffeeBrown)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(32)
                        .coffeeCardStyle()
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Profile Card

struct ProfileCard: View {
    let name: String
    let company: String
    let role: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Picture Placeholder (blurred)
            Circle()
                .fill(AppTheme.latteBrown)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppTheme.coffeeBrown)
                )
                .blur(radius: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                // Name (blurred)
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .coffeePrimaryText()
                    .blur(radius: 3)
                
                HStack(spacing: 6) {
                    Image(systemName: "building.2")
                        .font(.system(size: 12))
                    Text("\(company) • \(role)")
                        .font(.system(size: 14))
                }
                .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AnonymousNetworkView()
}

