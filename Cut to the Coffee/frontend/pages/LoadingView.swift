//
//  LoadingView.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import SwiftUI
import AuthenticationServices

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var opacity: Double = 0
    @State private var loadingComplete = false
    @State private var showButtons = false
    
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
                
                // Loading indicator - fades out when complete
                if !loadingComplete {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.pureWhite))
                            .scaleEffect(1.5)
                            .padding(.top, 10)
                        
                        Text("Brewing your experience...")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.textOnDark.opacity(0.8))
                    }
                    .transition(.opacity.combined(with: .scale))
                }
                
                // Buttons - slide in when loading complete
                if showButtons {
                    VStack(spacing: 16) {
                        // Sign in with Apple button
                        SignInWithAppleButton(
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                switch result {
                                case .success(let authorization):
                                    // Handle successful authorization
                                    print("Authorization successful: \(authorization)")
                                case .failure(let error):
                                    // Handle error
                                    print("Authorization failed: \(error.localizedDescription)")
                                }
                            }
                        )
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                        
                        // Spacer and description for explore network
                        VStack(spacing: 8) {
                            Text("Just looking around?")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppTheme.textOnDark.opacity(0.9))
                            
                            // Explore network button
                            Button {
                                // Action for explore network
                                print("Explore network tapped")
                            } label: {
                                Text("Explore Our Network")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppTheme.coffeeBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(AppTheme.creamWhite)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 40)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.top, 10)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1.0
            }
            
            // Simulate loading completion after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.4)) {
                    loadingComplete = true
                }
                
                // Show buttons slightly after loading disappears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showButtons = true
                    }
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}

