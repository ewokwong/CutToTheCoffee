//
//  ReferrerCodeEntryView.swift
//  Cut to the Coffee
//
//  Screen for referrers to enter their access code
//

import SwiftUI

struct ReferrerCodeEntryView: View {
    @State private var code = ""
    @State private var isCodeValid = false
    @State private var showError = false
    let onCodeEntered: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            // Background gradient
            AppTheme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with back button and test skip button
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppTheme.creamWhite)
                    }
                    
                    Spacer()
                    
                    // Test skip button
                    Button(action: onCodeEntered) {
                        Text("Test: Go to Homepage")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppTheme.coffeeBrown)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(AppTheme.creamWhite)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                VStack(spacing: 40) {
                    // Icon
                    Image(systemName: "key.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.creamWhite)
                    
                    // Title and subtitle
                    VStack(spacing: 12) {
                        Text("Enter Your Referrer Code")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppTheme.creamWhite)
                            .multilineTextAlignment(.center)
                        
                        Text("Please enter the 6-character code provided to you")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.textOnDark.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    // Code input
                    VStack(spacing: 16) {
                        ZStack {
                            // Hidden text field for keyboard input
                            TextField("", text: $code)
                                .keyboardType(.asciiCapable)
                                .textInputAutocapitalization(.characters)
                                .onChange(of: code) { oldValue, newValue in
                                    // Limit to 6 characters
                                    if newValue.count > 6 {
                                        code = String(newValue.prefix(6))
                                    }
                                    // Convert to uppercase
                                    code = code.uppercased()
                                    
                                    // Check if code is valid (6 characters)
                                    if code.count == 6 {
                                        isCodeValid = true
                                        showError = false
                                    } else {
                                        isCodeValid = false
                                    }
                                }
                                .frame(width: 1, height: 1)
                                .opacity(0.01)
                            
                            // Visible code boxes
                            HStack(spacing: 12) {
                                ForEach(0..<6) { index in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppTheme.creamWhite)
                                            .frame(width: 45, height: 55)
                                        
                                        if code.count > index {
                                            Text(String(Array(code)[index]))
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(AppTheme.coffeeBrown)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Error message
                        if showError {
                            Text("Please enter a complete 6-character code")
                                .font(.system(size: 14))
                                .foregroundColor(.red.opacity(0.9))
                        }
                    }
                    
                    // Continue button
                    Button {
                        if code.count == 6 {
                            // Accept any 6 character code for now
                            onCodeEntered()
                        } else {
                            showError = true
                        }
                    } label: {
                        HStack {
                            Text("Continue")
                                .font(.system(size: 16, weight: .semibold))
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(isCodeValid ? AppTheme.coffeeBrown : AppTheme.coffeeBrown.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isCodeValid ? AppTheme.creamWhite : AppTheme.creamWhite.opacity(0.5))
                        .cornerRadius(12)
                    }
                    .disabled(!isCodeValid)
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ReferrerCodeEntryView(
        onCodeEntered: {},
        onBack: {}
    )
}

