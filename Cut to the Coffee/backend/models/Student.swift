//
//  Student.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

struct Student: User {
    // User protocol fields
    var id: UUID
    var name: String
    var email: String
    var linkedinURL: String
    var universityID: UUID
    var bio: String?
    var profilePictureURL: String?
    
    // Student-specific fields
    var resumeURL: String
    var degree: String
    var yearGraduating: Int
}

// MARK: - Convenience Initializers
extension Student {
    /// Initialize a new student with required fields
    init(
        name: String,
        email: String,
        linkedinURL: String,
        universityID: UUID,
        resumeURL: String,
        degree: String,
        yearGraduating: Int,
        bio: String? = nil,
        profilePictureURL: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.linkedinURL = linkedinURL
        self.universityID = universityID
        self.bio = bio
        self.profilePictureURL = profilePictureURL
        self.resumeURL = resumeURL
        self.degree = degree
        self.yearGraduating = yearGraduating
    }
}

