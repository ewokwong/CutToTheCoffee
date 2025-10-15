//
//  University.swift
//  Cut the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

struct University: Identifiable, Codable {
    var id: UUID
    var name: String
}

// MARK: - Convenience Initializers
extension University {
    /// Initialize a new university
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
