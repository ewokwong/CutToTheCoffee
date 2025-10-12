//
//  Config.template.swift
//  Cut to the Coffee
//
//  Template for API keys and configuration
//  Copy this file to Config.swift and add your actual values
//

import Foundation

struct AppConfig {
    
    // MARK: - API Keys
    
    /// Firebase API Key (if needed separately)
    static let firebaseAPIKey = "YOUR_FIREBASE_API_KEY_HERE"
    
    /// Other API Keys
    static let linkedInAPIKey = "YOUR_LINKEDIN_API_KEY_HERE"
    static let stripePublishableKey = "YOUR_STRIPE_KEY_HERE"
    
    // MARK: - Environment
    
    enum Environment {
        case development
        case staging
        case production
    }
    
    static let currentEnvironment: Environment = .development
    
    // MARK: - API URLs
    
    static var apiBaseURL: String {
        switch currentEnvironment {
        case .development:
            return "https://dev-api.cuttothecoffee.com"
        case .staging:
            return "https://staging-api.cuttothecoffee.com"
        case .production:
            return "https://api.cuttothecoffee.com"
        }
    }
    
    // MARK: - Feature Flags
    
    static let enableAnalytics = true
    static let enableCrashReporting = true
    static let enableDebugLogging = true
    
    // MARK: - App Configuration
    
    static let appVersion = "1.0.0"
    static let minimumIOSVersion = "15.0"
}

