//
//  ReferrerController.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation
import Combine

class ReferrerController: ObservableObject {
    @Published var referrers: [Referrer] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = ReferrerRepository()
    
    // MARK: - CREATE
    
    /// Create a new referrer
    func createReferrer(_ referrer: Referrer) async throws -> Referrer {
        isLoading = true
        defer { isLoading = false }
        
        let createdReferrer = try await repository.create(referrer)
        
        await MainActor.run {
            self.referrers.append(createdReferrer)
        }
        
        return createdReferrer
    }
    
    // MARK: - READ
    
    /// Fetch all referrers
    func fetchAllReferrers() async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        let fetchedReferrers = try await repository.fetchAll()
        
        await MainActor.run {
            self.referrers = fetchedReferrers
        }
        
        return fetchedReferrers
    }
    
    /// Fetch a single referrer by ID
    func fetchReferrer(by id: UUID) async throws -> Referrer? {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetch(by: id)
    }
    
    /// Fetch referrers by company
    func fetchReferrers(byCompany companyId: UUID) async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchByCompany(companyId)
    }
    
    /// Fetch referrers by role
    func fetchReferrers(byRole roleId: UUID) async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchByRole(roleId)
    }
    
    /// Fetch referrers by university
    func fetchReferrers(byUniversity universityId: UUID) async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchByUniversity(universityId)
    }
    
    /// Search referrers by name
    func searchReferrers(byName name: String) async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        // Fetch all referrers and filter locally (Firestore doesn't support case-insensitive search)
        let allReferrers = try await repository.fetchAll()
        return allReferrers.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing referrer
    func updateReferrer(_ referrer: Referrer) async throws -> Referrer {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.update(referrer)
        
        await MainActor.run {
            if let index = self.referrers.firstIndex(where: { $0.id == referrer.id }) {
                self.referrers[index] = referrer
            }
        }
        
        return referrer
    }
    
    /// Update referrer's bio
    func updateBio(for referrerId: UUID, bio: String) async throws {
        guard var referrer = referrers.first(where: { $0.id == referrerId }) else {
            throw ReferrerControllerError.referrerNotFound
        }
        
        referrer.bio = bio
        try await updateReferrer(referrer)
    }
    
    /// Update referrer's company and role
    func updateCompanyAndRole(for referrerId: UUID, companyId: UUID, roleId: UUID, startDate: Date?) async throws {
        guard var referrer = referrers.first(where: { $0.id == referrerId }) else {
            throw ReferrerControllerError.referrerNotFound
        }
        
        referrer.companyID = companyId
        referrer.roleID = roleId
        referrer.roleStartDate = startDate
        try await updateReferrer(referrer)
    }
    
    // MARK: - DELETE
    
    /// Delete a referrer by ID
    func deleteReferrer(by id: UUID) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.delete(by: id)
        
        await MainActor.run {
            self.referrers.removeAll { $0.id == id }
        }
    }
    
    // MARK: - Error Handling
    
    enum ReferrerControllerError: LocalizedError {
        case referrerNotFound
        case invalidData
        case networkError
        
        var errorDescription: String? {
            switch self {
            case .referrerNotFound:
                return "Referrer not found"
            case .invalidData:
                return "Invalid referrer data"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
}

