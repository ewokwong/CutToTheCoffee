//
//  RoleController.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation
import Combine

class RoleController: ObservableObject {
    @Published var roles: [Role] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - CREATE
    
    /// Create a new role
    func createRole(_ role: Role) async throws -> Role {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let response = try await APIService.shared.post("/roles", body: role)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.roles.append(role)
        }
        
        return role
    }
    
    /// Create a new role with just a name
    func createRole(name: String) async throws -> Role {
        let role = Role(name: name)
        return try await createRole(role)
    }
    
    // MARK: - READ
    
    /// Fetch all roles
    func fetchAllRoles() async throws -> [Role] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let roles = try await APIService.shared.get("/roles")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.roles = []
        }
        
        return roles
    }
    
    /// Fetch a single role by ID
    func fetchRole(by id: UUID) async throws -> Role? {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return roles.first { $0.id == id }
    }
    
    /// Search roles by name
    func searchRoles(by name: String) async throws -> [Role] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let roles = try await APIService.shared.get("/roles/search?name=\(name)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return roles.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing role
    func updateRole(_ role: Role) async throws -> Role {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let updated = try await APIService.shared.put("/roles/\(role.id)", body: role)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            if let index = self.roles.firstIndex(where: { $0.id == role.id }) {
                self.roles[index] = role
            }
        }
        
        return role
    }
    
    /// Update role name
    func updateRoleName(for roleId: UUID, newName: String) async throws {
        guard var role = roles.first(where: { $0.id == roleId }) else {
            throw RoleControllerError.roleNotFound
        }
        
        role.name = newName
        try await updateRole(role)
    }
    
    // MARK: - DELETE
    
    /// Delete a role by ID
    func deleteRole(by id: UUID) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: try await APIService.shared.delete("/roles/\(id)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.roles.removeAll { $0.id == id }
        }
    }
    
    // MARK: - Error Handling
    
    enum RoleControllerError: LocalizedError {
        case roleNotFound
        case invalidData
        case networkError
        
        var errorDescription: String? {
            switch self {
            case .roleNotFound:
                return "Role not found"
            case .invalidData:
                return "Invalid role data"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
}

