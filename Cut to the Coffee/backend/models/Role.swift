//
//  Role.swift
//  Cut the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

struct Role: Identifiable, Codable {
    var id: UUID
    var name: String
}

// MARK: - Convenience Initializers
extension Role {
    /// Initialize a new role
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

