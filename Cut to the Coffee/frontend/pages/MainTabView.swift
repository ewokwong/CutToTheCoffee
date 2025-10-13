//
//  MainTabView.swift
//  Cut to the Coffee
//
//  Main container view with bottom navigation bar
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background color to prevent brown showing through
            AppTheme.lightGradient
                .ignoresSafeArea()
            
            // Tab Content
            TabView(selection: $selectedTab) {
                ExploreView()
                    .tag(0)
                
                RequestsView()
                    .tag(1)
                
                ProfileView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Bottom Navigation Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // Explore Tab
            TabBarButton(
                icon: "magnifyingglass.circle.fill",
                label: "Explore",
                isSelected: selectedTab == 0
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 0
                }
            }
            
            // Your Requests Tab
            TabBarButton(
                icon: "envelope.circle.fill",
                label: "Your Requests",
                isSelected: selectedTab == 1
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 1
                }
            }
            
            // Profile Tab
            TabBarButton(
                icon: "person.circle.fill",
                label: "Your Profile",
                isSelected: selectedTab == 2
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 2
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            Rectangle()
                .fill(AppTheme.creamWhite)
                .shadow(color: AppTheme.shadow, radius: 10, x: 0, y: -5)
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Tab Bar Button

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? AppTheme.coffeeBrown : AppTheme.textSecondary)
                
                Text(label)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppTheme.coffeeBrown : AppTheme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppTheme.latteBrown.opacity(0.3) : Color.clear)
            )
        }
    }
}

#Preview {
    MainTabView()
}

