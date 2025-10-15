//
//  ContentView.swift
//  Cut the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Light background
            AppTheme.lightGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.coffeeBrown)
                        
                        Text("Cut the Coffee")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .coffeePrimaryText()
                        
                        Text("Connect over coffee")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.top, 40)
                    
                    // Sample Cards
                    VStack(spacing: 16) {
                        // Card 1
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(AppTheme.coffeeBrown)
                                Text("Find Referrers")
                                    .font(.system(size: 20, weight: .semibold))
                                    .coffeePrimaryText()
                                Spacer()
                            }
                            
                            Text("Skip the niceties, connect with professionals who can refer you to your dream company")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textSecondary)
                                .lineLimit(2)
                        }
                        .padding(20)
                        .coffeeCardStyle()
                        
                        // Card 2
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "building.2.fill")
                                    .foregroundColor(AppTheme.coffeeBrown)
                                Text("Browse Companies")
                                    .font(.system(size: 20, weight: .semibold))
                                    .coffeePrimaryText()
                                Spacer()
                            }
                            
                            Text("Explore opportunities at top companies and find the perfect match")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textSecondary)
                                .lineLimit(2)
                        }
                        .padding(20)
                        .coffeeCardStyle()
                        
                        // Card 3
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "message.fill")
                                    .foregroundColor(AppTheme.coffeeBrown)
                                Text("Start Conversations")
                                    .font(.system(size: 20, weight: .semibold))
                                    .coffeePrimaryText()
                                Spacer()
                            }
                            
                            Text("Break the ice with professionals over a virtual coffee chat")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textSecondary)
                                .lineLimit(2)
                        }
                        .padding(20)
                        .coffeeCardStyle()
                    }
                    .padding(.horizontal, 20)
                    
                    // Sample Buttons
                    VStack(spacing: 12) {
                        Button("Get Started") {
                            // Action
                        }
                        .buttonStyle(.coffeePrimary)
                        
                        Button("Learn More") {
                            // Action
                        }
                        .buttonStyle(.coffeeSecondary)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
