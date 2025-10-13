//
//  ReferrerHomeView.swift
//  Cut to the Coffee
//
//  Home page for referrers (placeholder)
//

import SwiftUI

struct ReferrerHomeView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Light background
            AppTheme.lightGradient
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome, Referrer!")
                                .font(.system(size: 28, weight: .bold))
                                .coffeePrimaryText()
                            
                            Text("Manage your referrals")
                                .font(.system(size: 16))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Profile button
                        Circle()
                            .fill(AppTheme.latteBrown)
                            .frame(width: 45, height: 45)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppTheme.coffeeBrown)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
                .padding(.bottom, 20)
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Stats Cards
                        HStack(spacing: 12) {
                            ReferrerStatCard(
                                value: "12",
                                label: "Active Requests"
                            )
                            
                            ReferrerStatCard(
                                value: "28",
                                label: "Referrals Made"
                            )
                            
                            ReferrerStatCard(
                                value: "15",
                                label: "Successful"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Pending Requests Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pending Requests")
                                .font(.system(size: 20, weight: .semibold))
                                .coffeePrimaryText()
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(0..<5) { index in
                                    ReferrerRequestCard(
                                        studentName: "Student \(index + 1)",
                                        university: "University",
                                        message: "Hi, I'm interested in opportunities at your company..."
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Quick Actions Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick Actions")
                                .font(.system(size: 20, weight: .semibold))
                                .coffeePrimaryText()
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                QuickActionButton(
                                    icon: "person.badge.plus",
                                    title: "Update Availability",
                                    color: AppTheme.coffeeBrown
                                )
                                
                                QuickActionButton(
                                    icon: "envelope.fill",
                                    title: "Message Students",
                                    color: AppTheme.coffeeBrown
                                )
                                
                                QuickActionButton(
                                    icon: "chart.bar.fill",
                                    title: "View Analytics",
                                    color: AppTheme.coffeeBrown
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

// MARK: - Referrer Stat Card

struct ReferrerStatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .coffeePrimaryText()
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Referrer Request Card

struct ReferrerRequestCard: View {
    let studentName: String
    let university: String
    let message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Profile Picture
                Circle()
                    .fill(AppTheme.latteBrown)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.coffeeBrown)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(studentName)
                        .font(.system(size: 16, weight: .semibold))
                        .coffeePrimaryText()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "graduationcap")
                            .font(.system(size: 12))
                        Text(university)
                            .font(.system(size: 14))
                    }
                    .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
            }
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(2)
            
            // Action buttons
            HStack(spacing: 8) {
                Button {
                    // Accept action
                } label: {
                    Text("Accept")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppTheme.coffeeBrown)
                        .cornerRadius(8)
                }
                
                Button {
                    // Decline action
                } label: {
                    Text("Decline")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.coffeeBrown)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppTheme.latteBrown)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button {
            // Action
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
            }
            .foregroundColor(color)
            .padding(16)
            .background(AppTheme.creamWhite)
            .cornerRadius(12)
            .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    ReferrerHomeView()
}

