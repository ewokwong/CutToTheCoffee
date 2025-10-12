//
//  Theme.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import SwiftUI

/// App-wide color theme inspired by coffee aesthetics
struct AppTheme {
    
    // MARK: - Primary Colors
    
    /// Rich dark coffee brown - perfect for headers and primary elements
    static let coffeeBrown = Color(red: 0.4, green: 0.2, blue: 0.1)
    
    /// Medium warm brown - great for secondary elements
    static let warmBrown = Color(red: 0.6, green: 0.3, blue: 0.2)
    
    /// Light latte brown - ideal for backgrounds and cards
    static let latteBrown = Color(red: 0.85, green: 0.75, blue: 0.65)
    
    /// Cream white - for text on dark backgrounds
    static let creamWhite = Color(red: 0.98, green: 0.96, blue: 0.94)
    
    /// Pure white - for highlights and emphasis
    static let pureWhite = Color.white
    
    // MARK: - Accent Colors
    
    /// Espresso dark - for very dark accents
    static let espresso = Color(red: 0.25, green: 0.15, blue: 0.1)
    
    /// Caramel - for interactive elements and highlights
    static let caramel = Color(red: 0.76, green: 0.5, blue: 0.26)
    
    // MARK: - Gradients
    
    /// Primary background gradient - coffee to warm brown
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [coffeeBrown, warmBrown]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Light background gradient - cream to latte
    static let lightGradient = LinearGradient(
        gradient: Gradient(colors: [creamWhite, latteBrown]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    /// Card gradient - subtle warm effect
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.95, green: 0.90, blue: 0.85),
            Color(red: 0.90, green: 0.82, blue: 0.72)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Text Colors
    
    /// Primary text color for light backgrounds
    static let textPrimary = coffeeBrown
    
    /// Secondary text color for light backgrounds
    static let textSecondary = warmBrown
    
    /// Text for dark backgrounds
    static let textOnDark = creamWhite
    
    /// Muted text color
    static let textMuted = Color.gray.opacity(0.7)
    
    // MARK: - UI Element Colors
    
    /// Background for cards and containers
    static let cardBackground = creamWhite
    
    /// Divider color
    static let divider = latteBrown.opacity(0.5)
    
    /// Shadow color
    static let shadow = espresso.opacity(0.2)
}

// MARK: - View Extension for Easy Access

extension View {
    /// Apply the primary coffee gradient background
    func coffeeGradientBackground() -> some View {
        self.background(AppTheme.primaryGradient.ignoresSafeArea())
    }
    
    /// Apply a card style with coffee theme
    func coffeeCardStyle() -> some View {
        self
            .background(AppTheme.cardBackground)
            .cornerRadius(16)
            .shadow(color: AppTheme.shadow, radius: 8, x: 0, y: 4)
    }
    
    /// Apply primary text styling
    func coffeePrimaryText() -> some View {
        self.foregroundColor(AppTheme.textPrimary)
    }
    
    /// Apply text styling for dark backgrounds
    func coffeeTextOnDark() -> some View {
        self.foregroundColor(AppTheme.textOnDark)
    }
}

// MARK: - Common Button Styles

struct CoffeePrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(AppTheme.creamWhite)
            .padding(.vertical, 14)
            .padding(.horizontal, 28)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppTheme.coffeeBrown, AppTheme.warmBrown]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CoffeeSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(AppTheme.coffeeBrown)
            .padding(.vertical, 14)
            .padding(.horizontal, 28)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.latteBrown)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.coffeeBrown, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == CoffeePrimaryButtonStyle {
    static var coffeePrimary: CoffeePrimaryButtonStyle {
        CoffeePrimaryButtonStyle()
    }
}

extension ButtonStyle where Self == CoffeeSecondaryButtonStyle {
    static var coffeeSecondary: CoffeeSecondaryButtonStyle {
        CoffeeSecondaryButtonStyle()
    }
}

