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
    @State private var selectedCompany: String? = nil
    @State private var selectedRole: String? = nil
    @State private var selectedReferrer: (name: String, company: String, role: String, university: String)? = nil
    
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
                } else if let companyName = selectedCompany {
                    // Company Detail View
                    CompanyDetailView(
                        companyName: companyName,
                        onBack: { 
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedCompany = nil
                            }
                        },
                        onReferrerSelect: { name, company, role, university in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedReferrer = (name, company, role, university)
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))
                } else if let roleName = selectedRole {
                    // Role Detail View
                    RoleDetailView(
                        roleName: roleName,
                        onBack: { 
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedRole = nil
                            }
                        },
                        onReferrerSelect: { name, company, role, university in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedReferrer = (name, company, role, university)
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))
                } else {
                    // Main Explore View
                    VStack(spacing: 0) {
                        // Search Bar and Filter Chips
                        VStack(spacing: 16) {
                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                TextField("Search by company or role", text: $searchText)
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
                            .padding(.top, 16)

                        }
                        .padding(.bottom, 16)
                        
                        // Content
                        ScrollView {
                            VStack(spacing: 16) {
                            if selectedFilter == .all || selectedFilter == .companies {
                                // Explore by Company Section
                                SectionHeader(title: "Explore by Company", icon: "building.2.fill")
                                    .padding(.horizontal, 20)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(0..<5) { index in
                                                CompanyCard(
                                                    companyName: "Company \(index + 1)",
                                                    role: "Software Engineer",
                                                    referrersCount: Int.random(in: 3...15)
                                                )
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        selectedCompany = "Company \(index + 1)"
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                                
                            if selectedFilter == .all || selectedFilter == .referrers {
                                // Explore by Role Section
                                SectionHeader(title: "Explore by Role", icon: "person.2.fill")
                                    .padding(.horizontal, 20)
                                    .padding(.top, 8)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(["Software Engineer", "Product Manager", "Consultant", "Data Scientist", "UX Designer"], id: \.self) { role in
                                                RoleCard(
                                                    roleName: role,
                                                    referrersCount: Int.random(in: 5...20)
                                                )
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        selectedRole = role
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                            .padding(.bottom, 100) // Space for bottom nav bar
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading)
                    ))
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

// MARK: - Role Card

struct RoleCard: View {
    let roleName: String
    let referrersCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Role Icon Placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.latteBrown)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "briefcase.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppTheme.coffeeBrown)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(roleName)
                    .font(.system(size: 16, weight: .semibold))
                    .coffeePrimaryText()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
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

// MARK: - Role Detail View

struct RoleDetailView: View {
    let roleName: String
    let onBack: () -> Void
    let onReferrerSelect: (String, String, String, String) -> Void
    @State private var searchText = ""
    
    // Sample companies for referrers with this role
    let companies = [
        "Google", "Microsoft", "Amazon", "Meta", "Apple",
        "Netflix", "Tesla", "Uber", "Airbnb", "Stripe"
    ]
    
    var filteredReferrers: [(String, String)] {
        let allReferrers = companies.enumerated().map { (index, company) in
            ("Referrer \(index + 1)", company)
        }
        
        if searchText.isEmpty {
            return allReferrers
        } else {
            return allReferrers.filter { $0.1.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Back Button
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppTheme.coffeeBrown)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            
            // Title
            HStack {
                Text("Referrers for \(roleName)")
                    .font(.system(size: 24, weight: .bold))
                    .coffeePrimaryText()
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.textSecondary)
                
                TextField("Filter by company...", text: $searchText)
                    .font(.system(size: 16))
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
            .padding(12)
            .background(AppTheme.creamWhite)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.latteBrown, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            // Referrer List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Array(filteredReferrers.enumerated()), id: \.offset) { index, referrer in
                        ReferrerCard(
                            name: referrer.0,
                            company: referrer.1,
                            role: roleName,
                            university: "University \(index + 1)"
                        )
                        .onTapGesture {
                            onReferrerSelect(referrer.0, referrer.1, roleName, "University \(index + 1)")
                        }
                    }
                    
                    if filteredReferrers.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(AppTheme.textSecondary)
                                .padding(.top, 40)
                            
                            Text("No referrers found")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            Text("Try adjusting your search")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
}

// MARK: - Company Detail View

struct CompanyDetailView: View {
    let companyName: String
    let onBack: () -> Void
    let onReferrerSelect: (String, String, String, String) -> Void
    @State private var searchText = ""
    
    // Sample roles for filtering
    let referrers = [
        ("Referrer 1", "Software Engineer"),
        ("Referrer 2", "Product Manager"),
        ("Referrer 3", "Software Engineer"),
        ("Referrer 4", "Data Scientist"),
        ("Referrer 5", "Senior Software Engineer"),
        ("Referrer 6", "Product Manager"),
        ("Referrer 7", "Data Analyst"),
        ("Referrer 8", "Software Engineer")
    ]
    
    var filteredReferrers: [(String, String)] {
        if searchText.isEmpty {
            return referrers
        } else {
            return referrers.filter { $0.1.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Back Button
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppTheme.coffeeBrown)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            
            // Title
            HStack {
                Text("Referrers from \(companyName)")
                    .font(.system(size: 24, weight: .bold))
                    .coffeePrimaryText()
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.textSecondary)
                
                TextField("Filter by role...", text: $searchText)
                    .font(.system(size: 16))
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
            .padding(12)
            .background(AppTheme.creamWhite)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.latteBrown, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            // Referrer List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Array(filteredReferrers.enumerated()), id: \.offset) { index, referrer in
                        ReferrerCard(
                            name: referrer.0,
                            company: companyName,
                            role: referrer.1,
                            university: "University \(index + 1)"
                        )
                        .onTapGesture {
                            onReferrerSelect(referrer.0, companyName, referrer.1, "University \(index + 1)")
                        }
                    }
                    
                    if filteredReferrers.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(AppTheme.textSecondary)
                                .padding(.top, 40)
                            
                            Text("No referrers found")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            Text("Try adjusting your search")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    ExploreView()
}

