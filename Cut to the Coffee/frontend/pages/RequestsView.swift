//
//  RequestsView.swift
//  Cut to the Coffee
//
//  View for managing user's referral requests
//

import SwiftUI

struct RequestsView: View {
    @State private var selectedFilter: RequestFilter = .all
    
    enum RequestFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case accepted = "Accepted"
        case completed = "Completed"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Light background
                AppTheme.lightGradient
                    .ignoresSafeArea(edges: .all)
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        HStack {
                            Text("Your Requests")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .coffeePrimaryText()
                            
                            Spacer()
                            
                            // New Request Button
                            Button {
                                // Action to create new request
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(AppTheme.coffeeBrown)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Filter Chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(RequestFilter.allCases, id: \.self) { filter in
                                    FilterChip(
                                        title: filter.rawValue,
                                        isSelected: selectedFilter == filter
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedFilter = filter
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 16)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 16) {
                            // Stats Cards
                            HStack(spacing: 12) {
                                StatCard(
                                    icon: "clock.fill",
                                    value: "5",
                                    label: "Pending"
                                )
                                
                                StatCard(
                                    icon: "checkmark.circle.fill",
                                    value: "12",
                                    label: "Accepted"
                                )
                                
                                StatCard(
                                    icon: "star.fill",
                                    value: "8",
                                    label: "Completed"
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            // Requests List
                            VStack(spacing: 12) {
                                ForEach(0..<8) { index in
                                    RequestItemCard(
                                        referrerName: "Referrer Name \(index + 1)",
                                        company: "Tech Company",
                                        role: "Software Engineer",
                                        status: getStatusForIndex(index),
                                        date: "2 days ago"
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 100) // Space for bottom nav bar
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func getStatusForIndex(_ index: Int) -> RequestStatus {
        switch index % 3 {
        case 0: return .pending
        case 1: return .accepted
        default: return .completed
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppTheme.coffeeBrown)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .coffeePrimaryText()
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Request Item Card

struct RequestItemCard: View {
    let referrerName: String
    let company: String
    let role: String
    let status: RequestStatus
    let date: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Profile Picture Placeholder
                Circle()
                    .fill(AppTheme.latteBrown)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.coffeeBrown)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(referrerName)
                        .font(.system(size: 16, weight: .semibold))
                        .coffeePrimaryText()
                    
                    Text("\(company) • \(role)")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    Text(date)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                // Status Badge
                HStack(spacing: 4) {
                    Image(systemName: status.icon)
                        .font(.system(size: 12))
                    Text(status.text)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(status.color)
                .cornerRadius(8)
            }
            
            // Action Buttons (conditionally shown based on status)
            if status == .accepted {
                HStack(spacing: 8) {
                    Button {
                        // Action to message referrer
                    } label: {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Message")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppTheme.coffeeBrown)
                        .cornerRadius(8)
                    }
                    
                    Button {
                        // Action to view details
                    } label: {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("Details")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.coffeeBrown)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppTheme.latteBrown)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    RequestsView()
}

