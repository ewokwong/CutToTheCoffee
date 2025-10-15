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
        case interested = "Interested"
        case accepted = "Accepted"
    }
    
    // Sample data for demonstration
    let sampleRequests: [(referrerName: String, company: String, role: String, status: RequestStatus, date: String)] = [
        ("John Smith", "Google", "Software Engineer", .pending, "2 days ago"),
        ("Sarah Johnson", "Microsoft", "Product Manager", .accepted, "3 days ago"),
        ("Mike Chen", "Amazon", "Data Scientist", .interested, "5 days ago"),
        ("Emily Davis", "Meta", "Software Engineer", .pending, "1 week ago"),
        ("David Lee", "Apple", "UX Designer", .accepted, "1 week ago"),
        ("Jessica Brown", "Netflix", "Software Engineer", .interested, "2 weeks ago"),
        ("Chris Wilson", "Google", "Data Scientist", .pending, "2 weeks ago"),
        ("Amanda Garcia", "Microsoft", "Product Manager", .accepted, "3 weeks ago"),
        ("Tom Anderson", "Amazon", "Software Engineer", .interested, "3 weeks ago"),
    ]
    
    var filteredRequests: [(referrerName: String, company: String, role: String, status: RequestStatus, date: String)] {
        if selectedFilter == .all {
            return sampleRequests
        } else {
            return sampleRequests.filter { selectedFilter.rawValue == $0.status.displayName }
        }
    }
    
    // Group requests by company
    var groupedRequests: [(company: String, requests: [(referrerName: String, company: String, role: String, status: RequestStatus, date: String)])] {
        let grouped = Dictionary(grouping: filteredRequests) { $0.company }
        return grouped.map { (company: $0.key, requests: $0.value) }
            .sorted { $0.company < $1.company }
    }
    
    var pendingCount: Int {
        sampleRequests.filter { $0.status == .pending }.count
    }
    
    var interestedCount: Int {
        sampleRequests.filter { $0.status == .interested }.count
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
                        // Title
                        HStack {
                            Text("Your Requests")
                                .font(.system(size: 28, weight: .bold))
                                .coffeePrimaryText()
                            
                            Spacer()
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
                            if groupedRequests.isEmpty {
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
                                // Show company cards
                                ForEach(Array(groupedRequests.enumerated()), id: \.offset) { _, group in
                                    CompanyRequestCard(
                                        company: group.company,
                                        requests: group.requests
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
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

// MARK: - Company Request Card

struct CompanyRequestCard: View {
    let company: String
    let requests: [(referrerName: String, company: String, role: String, status: RequestStatus, date: String)]
    
    // Calculate status counts for this company
    var statusCounts: (pending: Int, interested: Int, accepted: Int) {
        let pending = requests.filter { $0.status == .pending }.count
        let interested = requests.filter { $0.status == .interested }.count
        let accepted = requests.filter { $0.status == .accepted }.count
        return (pending, interested, accepted)
    }
    
    // Get the most recent request date
    var mostRecentDate: String {
        requests.first?.date ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                // Company Logo
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.latteBrown)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.coffeeBrown)
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(company)
                        .font(.system(size: 20, weight: .bold))
                        .coffeePrimaryText()
                    
                    Text("\(requests.count) request\(requests.count == 1 ? "" : "s")")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    Text("Most recent: \(mostRecentDate)")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            // Status breakdown
            HStack(spacing: 8) {
                if statusCounts.pending > 0 {
                    StatusBadge(
                        count: statusCounts.pending,
                        label: "Pending",
                        color: Color.orange
                    )
                }
                
                if statusCounts.interested > 0 {
                    StatusBadge(
                        count: statusCounts.interested,
                        label: "Interested",
                        color: Color.purple
                    )
                }
                
                if statusCounts.accepted > 0 {
                    StatusBadge(
                        count: statusCounts.accepted,
                        label: "Accepted",
                        color: Color.green
                    )
                }
            }
        }
        .padding(16)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Status Badge

struct StatusBadge: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Text("\(count)")
                .font(.system(size: 12, weight: .bold))
            Text(label)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color)
        .cornerRadius(8)
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

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? AppTheme.creamWhite : AppTheme.coffeeBrown)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppTheme.coffeeBrown : AppTheme.creamWhite)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppTheme.coffeeBrown, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

#Preview {
    RequestsView()
}

