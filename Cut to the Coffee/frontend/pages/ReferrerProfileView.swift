//
//  ReferrerProfileView.swift
//  Cut the Coffee
//
//  Referrer profile page with request functionality
//

import SwiftUI

struct ReferrerProfileView: View {
    let referrerName: String
    let company: String
    let role: String
    let university: String
    let onBack: () -> Void
    
    @State private var currentRequestStatus: RequestStatus? = nil
    
    // Sample data - this would come from backend in real implementation
    let bio = "Passionate software engineer with 5+ years of experience in iOS development. Love mentoring and helping students break into tech!"
    let email = "referrer@company.com"
    let linkedin = "linkedin.com/in/referrer"
    
    var body: some View {
        ZStack {
            // Light background
            AppTheme.lightGradient
                .ignoresSafeArea(edges: .all)
            
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
                        // Profile Header
                        VStack(spacing: 16) {
                            // Profile Picture
                            Circle()
                                .fill(AppTheme.latteBrown)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(AppTheme.coffeeBrown)
                                )
                            
                            VStack(spacing: 8) {
                                Text(referrerName)
                                    .font(.system(size: 28, weight: .bold))
                                    .coffeePrimaryText()
                                
                                Text(role)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "building.2")
                                        .font(.system(size: 14))
                                    Text(company)
                                        .font(.system(size: 16))
                                }
                                .foregroundColor(AppTheme.textSecondary)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "graduationcap")
                                        .font(.system(size: 14))
                                    Text(university)
                                        .font(.system(size: 16))
                                }
                                .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                        .padding(.top, 8)
                        
                        // Request Button Section
                        requestButtonSection
                            .padding(.horizontal, 20)
                        
                        // About Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About")
                                .font(.system(size: 20, weight: .semibold))
                                .coffeePrimaryText()
                            
                            Text(bio)
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
                        
                        // Contact Info Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contact Information")
                                .font(.system(size: 20, weight: .semibold))
                                .coffeePrimaryText()
                            
                            if currentRequestStatus == .accepted {
                                VStack(spacing: 12) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(AppTheme.coffeeBrown)
                                        Text(email)
                                            .font(.system(size: 16))
                                            .foregroundColor(AppTheme.textSecondary)
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "link")
                                            .foregroundColor(AppTheme.coffeeBrown)
                                        Text(linkedin)
                                            .font(.system(size: 16))
                                            .foregroundColor(AppTheme.textSecondary)
                                        Spacer()
                                    }
                                }
                            } else {
                                Text("Contact information will be revealed once your request is accepted.")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .italic()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(AppTheme.creamWhite)
                        .cornerRadius(16)
                        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            // Simulate checking request status from backend
            checkRequestStatus()
        }
    }
    
    @ViewBuilder
    private var requestButtonSection: some View {
        if let status = currentRequestStatus {
            // Show pending status
            if status == .pending {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.white)
                    Text("Request Pending")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.orange)
                .cornerRadius(12)
            }
            // For accepted or read, don't show button
        } else {
            // No request exists - show send request button
            Button {
                sendRequest()
            } label: {
                HStack {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                    Text("Send Request")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppTheme.coffeeBrown)
                .cornerRadius(12)
                .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
            }
        }
    }
    
    private func checkRequestStatus() {
        // TODO: Implement backend call to check if request exists
        // For now, simulate with random status
        let random = Int.random(in: 0...2)
        switch random {
        case 0:
            currentRequestStatus = nil // No request
        case 1:
            currentRequestStatus = .pending
        default:
            currentRequestStatus = .accepted
        }
    }
    
    private func sendRequest() {
        // TODO: Implement backend call to create request
        withAnimation {
            currentRequestStatus = .pending
        }
    }
}

#Preview {
    ReferrerProfileView(
        referrerName: "John Smith",
        company: "Google",
        role: "Software Engineer",
        university: "Stanford University",
        onBack: {}
    )
}

