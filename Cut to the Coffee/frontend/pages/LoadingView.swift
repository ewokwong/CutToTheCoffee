//
//  LoadingView.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background gradient using theme
            AppTheme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Coffee cup icon with animation
                ZStack {
                    // Steam effect
                    VStack(spacing: 5) {
                        ForEach(0..<3) { index in
                            Image(systemName: "cloud.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.creamWhite.opacity(0.6))
                                .offset(y: isAnimating ? -20 : 0)
                                .opacity(isAnimating ? 0 : 0.8)
                                .animation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(index) * 0.3),
                                    value: isAnimating
                                )
                        }
                    }
                    .offset(y: -40)
                    
                    // Coffee cup
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppTheme.pureWhite)
                        .rotationEffect(.degrees(isAnimating ? 5 : -5))
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                .padding(.bottom, 20)
                
                // App name
                Text("Cut to the Coffee")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.creamWhite)
                    .opacity(opacity)
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.pureWhite))
                    .scaleEffect(1.5)
                    .padding(.top, 10)
                
                Text("Brewing your experience...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textOnDark.opacity(0.8))
                    .opacity(opacity)
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1.0
            }
        }
    }
}

#Preview {
    LoadingView()
}

