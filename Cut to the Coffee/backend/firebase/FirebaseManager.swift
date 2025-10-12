//
//  FirebaseManager.swift
//  Cut to the Coffee
//
//  Firebase configuration and singleton manager
//

import Foundation
import FirebaseCore
import FirebaseFirestore

/// Singleton manager for Firebase configuration
class FirebaseManager {
    static let shared = FirebaseManager()
    
    let db: Firestore
    
    private init() {
        // Firestore instance
        self.db = Firestore.firestore()
        
        // Configure Firestore settings
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        db.settings = settings
    }
    
    /// Collection references
    struct Collections {
        static let students = "students"
        static let referrers = "referrers"
        static let requests = "requests"
        static let companies = "companies"
        static let roles = "roles"
        static let universities = "universities"
    }
}

