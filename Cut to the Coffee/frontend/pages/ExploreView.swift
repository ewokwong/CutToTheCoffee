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
    @State private var selectedCompany: String? = nil
    @State private var selectedReferrer: (name: String, company: String, role: String, university: String)? = nil
    
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
                } else {
                    // Main Explore View
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("Explore Companies")
                                .font(.system(size: 28, weight: .bold))
                                .coffeePrimaryText()
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextField("Search companies", text: $searchText)
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
                        .padding(.bottom, 16)
                        
                        // Content - Vertical Grid of Companies
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(0..<20) { index in
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

// MARK: - Company Card

struct CompanyCard: View {
    let companyName: String
    let role: String
    let referrersCount: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            // Company Logo Placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.latteBrown)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppTheme.coffeeBrown)
                )
            
            VStack(alignment: .center, spacing: 4) {
                Text(companyName)
                    .font(.system(size: 15, weight: .semibold))
                    .coffeePrimaryText()
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    Image(systemName: "person.2")
                        .font(.system(size: 11))
                    Text("\(referrersCount) referrers")
                        .font(.system(size: 11))
                }
                .foregroundColor(AppTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
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

// MARK: - Company Detail View

struct CompanyDetailView: View {
    let companyName: String
    let onBack: () -> Void
    let onReferrerSelect: (String, String, String, String) -> Void
    @State private var showRequestSent = false
    @State private var showRoleLinkInput = false
    @State private var roleLink = ""
    
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
            
            ScrollView {
                VStack(spacing: 24) {
                    // Company Logo and Name
                    VStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.latteBrown)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "building.2.fill")
                                    .font(.system(size: 56))
                                    .foregroundColor(AppTheme.coffeeBrown)
                            )
                        
                        Text(companyName)
                            .font(.system(size: 32, weight: .bold))
                            .coffeePrimaryText()
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Company Info Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Explore Our Network")
                            .font(.system(size: 20, weight: .semibold))
                            .coffeePrimaryText()
                        
                        VStack(spacing: 12) {
                            CompanyInfoRow(
                                icon: "person.2.fill",
                                title: "Referrers Available",
                                value: "\(Int.random(in: 5...25))"
                            )
                            
                            CompanyInfoRow(
                                icon: "briefcase.fill",
                                title: "Open Roles",
                                value: "\(Int.random(in: 10...50))+"
                            )
                            
                            CompanyInfoRow(
                                icon: "checkmark.circle.fill",
                                title: "Success Rate",
                                value: "\(Int.random(in: 70...95))%"
                            )
                        }
                    }
                    .padding(20)
                    .background(AppTheme.creamWhite)
                    .cornerRadius(16)
                    .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About \(companyName)")
                            .font(.system(size: 20, weight: .semibold))
                            .coffeePrimaryText()
                        
                        Text("Connect with referrers from \(companyName) who can help you navigate the application process and increase your chances of landing your dream role.")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .background(AppTheme.creamWhite)
                    .cornerRadius(16)
                    .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
                    
                    // Apply for Referral Section
                    VStack(spacing: 16) {
                        if showRoleLinkInput {
                            // Role Link Input Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Role Link")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(AppTheme.coffeeBrown)
                                
                                HStack {
                                    Image(systemName: "link")
                                        .foregroundColor(AppTheme.textSecondary)
                                    
                                    TextField("Paste job posting URL here", text: $roleLink)
                                        .font(.system(size: 16))
                                        .autocapitalization(.none)
                                        .keyboardType(.URL)
                                }
                                .padding(12)
                                .background(AppTheme.creamWhite)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.latteBrown, lineWidth: 1)
                                )
                            }
                            
                            // Submit Button
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    showRoleLinkInput = false
                                    showRequestSent = true
                                    roleLink = ""
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showRequestSent = false
                                    }
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "paperplane.fill")
                                        .font(.system(size: 18))
                                    
                                    Text("Submit Request")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(AppTheme.creamWhite)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(roleLink.isEmpty ? AppTheme.textSecondary : AppTheme.coffeeBrown)
                                .cornerRadius(12)
                            }
                            .disabled(roleLink.isEmpty)
                            
                            // Cancel button
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showRoleLinkInput = false
                                    roleLink = ""
                                }
                            }) {
                                Text("Cancel")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppTheme.coffeeBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                        } else {
                            // Apply for Referral Button
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showRoleLinkInput = true
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "paperplane.fill")
                                        .font(.system(size: 18))
                                    
                                    Text("Apply for Referral")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(AppTheme.creamWhite)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppTheme.coffeeBrown)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .overlay(
            Group {
                if showRequestSent {
                    VStack {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.green)
                            
                            Text("Request sent successfully!")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.coffeeBrown)
                        }
                        .padding(20)
                        .background(AppTheme.creamWhite)
                        .cornerRadius(16)
                        .shadow(color: AppTheme.shadow, radius: 8, x: 0, y: 4)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        )
    }
}

// MARK: - Company Info Row

struct CompanyInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppTheme.coffeeBrown)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .coffeePrimaryText()
        }
    }
}

#Preview {
    ExploreView()
}

