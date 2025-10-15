//
//  User.swift
//  Cut the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

/// Common protocol for all user types in the system
protocol User: Identifiable, Codable {
    var id: UUID { get }
    var name: String { get set }
    var email: String { get set }
    var linkedinURL: String { get set }
    var universityID: UUID { get set }
    var bio: String? { get set }
    var profilePictureURL: String? { get set }
}

