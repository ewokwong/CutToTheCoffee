//
//  Referrer.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

struct Referrer: User {
    // User protocol fields
    var id: UUID
    var name: String
    var email: String
    var linkedinURL: String
    var bio: String?
    var profilePictureURL: String?
    
    // Referrer-specific fields
    var companyID: UUID
    var roleID: UUID
    var roleStartDate: Date?
}

// MARK: - Convenience Initializers
extension Referrer {
    /// Initialize a new referrer with required fields
    init(
        name: String,
        email: String,
        linkedinURL: String,
        companyID: UUID,
        roleID: UUID,
        bio: String? = nil,
        profilePictureURL: String? = nil,
        roleStartDate: Date? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.linkedinURL = linkedinURL
        self.bio = bio
        self.profilePictureURL = profilePictureURL
        self.companyID = companyID
        self.roleID = roleID
        self.roleStartDate = roleStartDate
    }
}

