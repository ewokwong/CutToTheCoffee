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
    
    private let repository = RoleRepository()
    
    // MARK: - CREATE
    
    /// Create a new role
    func createRole(_ role: Role) async throws -> Role {
        isLoading = true
        defer { isLoading = false }
        
        let createdRole = try await repository.create(role)
        
        await MainActor.run {
            self.roles.append(createdRole)
        }
        
        return createdRole
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
        
        let fetchedRoles = try await repository.fetchAll()
        
        await MainActor.run {
            self.roles = fetchedRoles
        }
        
        return fetchedRoles
    }
    
    /// Fetch a single role by ID
    func fetchRole(by id: UUID) async throws -> Role? {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetch(by: id)
    }
    
    /// Search roles by name
    func searchRoles(by name: String) async throws -> [Role] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.searchByName(name)
    }
    
    // MARK: - UPDATE
    
    /// Update an existing role
    func updateRole(_ role: Role) async throws -> Role {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.update(role)
        
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
        
        try await repository.delete(by: id)
        
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
