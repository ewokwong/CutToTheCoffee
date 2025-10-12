//
//  Company.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

struct Company: Identifiable, Codable {
    var id: UUID
    var name: String
}

// MARK: - Convenience Initializers
extension Company {
    /// Initialize a new company
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
