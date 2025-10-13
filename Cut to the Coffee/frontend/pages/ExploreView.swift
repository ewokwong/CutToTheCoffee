//
//  ExploreView.swift
//  Cut to the Coffee
//
//  Explore page - browse referrers and companies
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @State private var searchText = ""
    @State private var selectedFilter: ExploreFilter = .all
    
    enum ExploreFilter: String, CaseIterable {
        case all = "All"
        case referrers = "Referrers"
        case companies = "Companies"
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
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Explore")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .coffeePrimaryText()
                                
                                if let userName = authManager.userFullName?.components(separatedBy: " ").first {
                                    Text("Welcome back, \(userName)!")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 32))
                                .foregroundColor(AppTheme.coffeeBrown)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextField("Search referrers or companies...", text: $searchText)
                                .font(.system(size: 16))
                        }
                        .padding(12)
                        .background(AppTheme.creamWhite)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppTheme.latteBrown, lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        // Filter Chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(ExploreFilter.allCases, id: \.self) { filter in
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
                            if selectedFilter == .all || selectedFilter == .companies {
                                // Featured Companies Section
                                SectionHeader(title: "Featured Companies", icon: "building.2.fill")
                                    .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(0..<5) { index in
                                            CompanyCard(
                                                companyName: "Company \(index + 1)",
                                                role: "Software Engineer",
                                                referrersCount: Int.random(in: 3...15)
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            if selectedFilter == .all || selectedFilter == .referrers {
                                // Top Referrers Section
                                SectionHeader(title: "Top Referrers", icon: "person.2.fill")
                                    .padding(.horizontal, 20)
                                    .padding(.top, 8)
                                
                                VStack(spacing: 12) {
                                    ForEach(0..<10) { index in
                                        ReferrerCard(
                                            name: "Referrer \(index + 1)",
                                            company: "Tech Company \(index + 1)",
                                            role: "Senior Software Engineer",
                                            university: "University"
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 100) // Space for bottom nav bar
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.coffeeBrown)
            
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .coffeePrimaryText()
            
            Spacer()
        }
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

// MARK: - Company Card

struct CompanyCard: View {
    let companyName: String
    let role: String
    let referrersCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Company Logo Placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.latteBrown)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppTheme.coffeeBrown)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(companyName)
                    .font(.system(size: 16, weight: .semibold))
                    .coffeePrimaryText()
                
                Text(role)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "person.2")
                        .font(.system(size: 12))
                    Text("\(referrersCount) referrers")
                        .font(.system(size: 12))
                }
                .foregroundColor(AppTheme.textSecondary)
            }
        }
        .frame(width: 160)
        .padding(16)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Referrer Card

struct ReferrerCard: View {
    let name: String
    let company: String
    let role: String
    let university: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Picture Placeholder
            Circle()
                .fill(AppTheme.latteBrown)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppTheme.coffeeBrown)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .coffeePrimaryText()
                
                HStack(spacing: 6) {
                    Image(systemName: "building.2")
                        .font(.system(size: 12))
                    Text("\(company) • \(role)")
                        .font(.system(size: 14))
                }
                .foregroundColor(AppTheme.textSecondary)
                
                HStack(spacing: 6) {
                    Image(systemName: "graduationcap")
                        .font(.system(size: 12))
                    Text(university)
                        .font(.system(size: 12))
                }
                .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(16)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ExploreView()
}

