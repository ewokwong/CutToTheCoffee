//
//  RequestsView.swift
//  Cut to the Coffee
//
//  View for managing user's referral requests
//

import SwiftUI

struct RequestsView: View {
    @State private var selectedFilter: RequestFilter = .all
    @State private var selectedReferrer: (name: String, company: String, role: String, university: String)? = nil
    
    enum RequestFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case read = "Read"
        case accepted = "Accepted"
    }
    
    // Sample data for demonstration
    let sampleRequests: [(referrerName: String, company: String, role: String, status: RequestStatus, date: String)] = [
        ("John Smith", "Google", "Software Engineer", .pending, "2 days ago"),
        ("Sarah Johnson", "Microsoft", "Product Manager", .accepted, "3 days ago"),
        ("Mike Chen", "Amazon", "Data Scientist", .read, "5 days ago"),
        ("Emily Davis", "Meta", "Software Engineer", .pending, "1 week ago"),
        ("David Lee", "Apple", "UX Designer", .accepted, "1 week ago"),
        ("Jessica Brown", "Netflix", "Software Engineer", .read, "2 weeks ago"),
        ("Chris Wilson", "Tesla", "Consultant", .pending, "2 weeks ago"),
        ("Amanda Garcia", "Uber", "Product Manager", .accepted, "3 weeks ago"),
    ]
    
    var filteredRequests: [(referrerName: String, company: String, role: String, status: RequestStatus, date: String)] {
        if selectedFilter == .all {
            return sampleRequests
        } else {
            return sampleRequests.filter { selectedFilter.rawValue == $0.status.displayName }
        }
    }
    
    var pendingCount: Int {
        sampleRequests.filter { $0.status == .pending }.count
    }
    
    var readCount: Int {
        sampleRequests.filter { $0.status == .read }.count
    }
    
    var acceptedCount: Int {
        sampleRequests.filter { $0.status == .accepted }.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Light background
                AppTheme.lightGradient
                    .ignoresSafeArea(edges: .all)
                
                if let referrer = selectedReferrer {
                    // Referrer Profile View
                    ReferrerProfileView(
                        referrerName: referrer.name,
                        company: referrer.company,
                        role: referrer.role,
                        university: referrer.university,
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedReferrer = nil
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))
                } else {
                    VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        
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
                                    value: "\(pendingCount)",
                                    label: "Pending"
                                )
                                
                                StatCard(
                                    value: "\(readCount)",
                                    label: "Read"
                                )
                                
                                StatCard(
                                    value: "\(acceptedCount)",
                                    label: "Accepted"
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            // Requests List
                            VStack(spacing: 12) {
                                if filteredRequests.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "tray")
                                            .font(.system(size: 48))
                                            .foregroundColor(AppTheme.textSecondary)
                                            .padding(.top, 40)
                                        
                                        Text("No \(selectedFilter.rawValue.lowercased()) requests")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    .padding(.top, 20)
                                } else {
                                    ForEach(Array(filteredRequests.enumerated()), id: \.offset) { index, request in
                                        RequestItemCard(
                                            referrerName: request.referrerName,
                                            company: request.company,
                                            role: request.role,
                                            status: request.status,
                                            date: request.date
                                        )
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                selectedReferrer = (request.referrerName, request.company, request.role, "University")
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 100) // Space for bottom nav bar
                    }
                }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .coffeePrimaryText()
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
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

