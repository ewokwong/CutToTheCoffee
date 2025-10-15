//
//  CompaniesExplorerView.swift
//  Cut the Coffee
//
//  Explore network of companies and their open roles
//

import SwiftUI

struct CompaniesExplorerView: View {
    let onBack: () -> Void
    @State private var selectedCompany: CompanyData? = nil
    
    // Sample company data
    let companies = [
        CompanyData(
            id: 0,
            name: "Apple",
            logo: "applelogo",
            industry: "Technology",
            description: "Think different. Apple leads the world in innovation with iPhone, iPad, Mac, Apple Watch, and more.",
            openRolesCount: 12,
            careersURL: "https://www.apple.com/careers"
        ),
        CompanyData(
            id: 1,
            name: "Google",
            logo: "magnifyingglass.circle.fill",
            industry: "Technology",
            description: "Organize the world's information and make it universally accessible and useful.",
            openRolesCount: 28,
            careersURL: "https://careers.google.com"
        ),
        CompanyData(
            id: 2,
            name: "Microsoft",
            logo: "square.grid.2x2.fill",
            industry: "Technology",
            description: "Empower every person and organization on the planet to achieve more.",
            openRolesCount: 19,
            careersURL: "https://careers.microsoft.com"
        ),
        CompanyData(
            id: 3,
            name: "Amazon",
            logo: "shippingbox.fill",
            industry: "E-commerce & Cloud",
            description: "Earth's most customer-centric company, where people can find and discover anything online.",
            openRolesCount: 35,
            careersURL: "https://www.amazon.jobs"
        ),
        CompanyData(
            id: 4,
            name: "Meta",
            logo: "person.3.fill",
            industry: "Social Media",
            description: "Building the future of human connection and the technology that makes it possible.",
            openRolesCount: 15,
            careersURL: "https://www.metacareers.com"
        ),
        CompanyData(
            id: 5,
            name: "Netflix",
            logo: "play.rectangle.fill",
            industry: "Entertainment",
            description: "Entertainment company offering streaming movies and TV series.",
            openRolesCount: 8,
            careersURL: "https://jobs.netflix.com"
        ),
        CompanyData(
            id: 6,
            name: "Spotify",
            logo: "music.note.list",
            industry: "Music Streaming",
            description: "Unlock the potential of human creativity by giving a million creative artists opportunities.",
            openRolesCount: 11,
            careersURL: "https://www.lifeatspotify.com"
        ),
        CompanyData(
            id: 7,
            name: "Tesla",
            logo: "bolt.car.fill",
            industry: "Automotive",
            description: "Accelerate the world's transition to sustainable energy.",
            openRolesCount: 22,
            careersURL: "https://www.tesla.com/careers"
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.lightGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Our Network")
                                .font(.system(size: 32, weight: .bold))
                                .coffeePrimaryText()
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        
                        // Company Cards
                        VStack(spacing: 16) {
                            ForEach(companies) { company in
                                NetworkCompanyCard(company: company) {
                                    selectedCompany = company
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        onBack()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(AppTheme.coffeeBrown)
                    }
                }
            }
        }
        .sheet(item: $selectedCompany) { company in
            NetworkCompanyDetailView(company: company)
        }
    }
}

// MARK: - Company Data Model

struct CompanyData: Identifiable {
    let id: Int
    let name: String
    let logo: String
    let industry: String
    let description: String
    let openRolesCount: Int
    let careersURL: String
}

// MARK: - Network Company Card

struct NetworkCompanyCard: View {
    let company: CompanyData
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Logo
                    ZStack {
                        Circle()
                            .fill(AppTheme.latteBrown)
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: company.logo)
                            .font(.system(size: 32))
                            .foregroundColor(AppTheme.coffeeBrown)
                    }
                    
                    // Company Info
                    VStack(alignment: .leading, spacing: 6) {
                        Text(company.name)
                            .font(.system(size: 20, weight: .bold))
                            .coffeePrimaryText()
                        
                        Text(company.industry)
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "briefcase.fill")
                                .font(.system(size: 13))
                            Text("\(company.openRolesCount) open roles")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(AppTheme.coffeeBrown)
                        .padding(.top, 4)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            .padding(20)
            .background(AppTheme.creamWhite)
            .cornerRadius(16)
            .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Network Company Detail View

struct NetworkCompanyDetailView: View {
    @Environment(\.dismiss) var dismiss
    let company: CompanyData
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.lightGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 28) {
                        // Company Logo
                        ZStack {
                            Circle()
                                .fill(AppTheme.latteBrown)
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: company.logo)
                                .font(.system(size: 50))
                                .foregroundColor(AppTheme.coffeeBrown)
                        }
                        .padding(.top, 30)
                        
                        // Company Info
                        VStack(spacing: 12) {
                            Text(company.name)
                                .font(.system(size: 32, weight: .bold))
                                .coffeePrimaryText()
                            
                            Text(company.industry)
                                .font(.system(size: 18))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            // Open Roles Badge
                            HStack(spacing: 8) {
                                Image(systemName: "briefcase.fill")
                                    .font(.system(size: 14))
                                Text("\(company.openRolesCount) Open Roles")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(AppTheme.coffeeBrown)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(AppTheme.latteBrown)
                            .cornerRadius(12)
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About")
                                .font(.system(size: 20, weight: .semibold))
                                .coffeePrimaryText()
                            
                            Text(company.description)
                                .font(.system(size: 16))
                                .foregroundColor(AppTheme.textSecondary)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(AppTheme.creamWhite)
                        .cornerRadius(16)
                        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        
                        // Why Join Card
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Why Join?")
                                .font(.system(size: 20, weight: .semibold))
                                .coffeePrimaryText()
                            
                            VStack(spacing: 12) {
                                InfoRow(icon: "person.3.fill", text: "Get referred by alumni in your network")
                                InfoRow(icon: "star.fill", text: "Increase your chances of getting hired")
                                InfoRow(icon: "heart.fill", text: "Join a supportive community")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(AppTheme.creamWhite)
                        .cornerRadius(16)
                        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        
                        // View Open Roles Button
                        Link(destination: URL(string: company.careersURL)!) {
                            HStack {
                                Image(systemName: "link.circle.fill")
                                    .font(.system(size: 20))
                                
                                Text("View Open Roles")
                                    .font(.system(size: 17, weight: .bold))
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(AppTheme.coffeeBrown)
                            .cornerRadius(14)
                            .shadow(color: AppTheme.shadow, radius: 6, x: 0, y: 3)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppTheme.coffeeBrown)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
            
            Spacer()
        }
    }
}

#Preview {
    CompaniesExplorerView(onBack: {})
}

