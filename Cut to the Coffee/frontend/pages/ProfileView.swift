//
//  ProfileView.swift
//  Cut to the Coffee
//
//  User profile page
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Light background
                AppTheme.lightGradient
                    .ignoresSafeArea(edges: .all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Profile Picture
                            Circle()
                                .fill(AppTheme.latteBrown)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 44))
                                        .foregroundColor(AppTheme.coffeeBrown)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(AppTheme.coffeeBrown, lineWidth: 3)
                                )
                            
                            VStack(spacing: 4) {
                                if let userName = authManager.userFullName {
                                    Text(userName)
                                        .font(.system(size: 24, weight: .bold))
                                        .coffeePrimaryText()
                                }
                                
                                if let userEmail = authManager.userEmail {
                                    Text(userEmail)
                                        .font(.system(size: 14))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                            }
                            
                            // Edit Profile Button
                            Button {
                                // Action to edit profile
                            } label: {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Profile")
                                }
                                .font(.system(size: 14, weight: .semibold))
                            }
                            .buttonStyle(.coffeeSecondary)
                        }
                        .padding(.top, 32)
                        
                        // Profile Information
                        VStack(spacing: 16) {
                            ProfileInfoSection(title: "Academic Information") {
                                ProfileInfoRow(
                                    icon: "graduationcap.fill",
                                    label: "University",
                                    value: "Your University"
                                )
                                
                                ProfileInfoRow(
                                    icon: "book.fill",
                                    label: "Degree",
                                    value: "Computer Science"
                                )
                                
                                ProfileInfoRow(
                                    icon: "calendar",
                                    label: "Graduation Year",
                                    value: "2025"
                                )
                            }
                            
                            ProfileInfoSection(title: "Professional") {
                                ProfileInfoRow(
                                    icon: "link",
                                    label: "LinkedIn",
                                    value: "linkedin.com/in/profile",
                                    isLink: true
                                )
                                
                                ProfileInfoRow(
                                    icon: "doc.fill",
                                    label: "Resume",
                                    value: "View Resume",
                                    isLink: true
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Sign Out Button
                        Button {
                            showingSignOutAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Sign Out")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppTheme.creamWhite)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 100) // Space for bottom nav bar
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authManager.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

// MARK: - Profile Stat Card

struct ProfileStatCard: View {
    let icon: String
    var value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppTheme.coffeeBrown)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .coffeePrimaryText()
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppTheme.creamWhite)
        .cornerRadius(12)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Profile Info Section

struct ProfileInfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .coffeePrimaryText()
            
            VStack(spacing: 12) {
                content
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Profile Info Row

struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    var isLink: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.coffeeBrown)
                .frame(width: 24)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
            
            Spacer()
            
            if isLink {
                Button {
                    // Action to open link
                } label: {
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.coffeeBrown)
                        .underline()
                }
            } else {
                Text(value)
                    .font(.system(size: 14, weight: .medium))
                    .coffeePrimaryText()
            }
        }
    }
}

// MARK: - Settings Button

struct SettingsButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.coffeeBrown)
                    .frame(width: 28)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .coffeePrimaryText()
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(16)
            .background(AppTheme.creamWhite)
            .cornerRadius(12)
            .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    ProfileView()
}

