//
//  ReferrerController.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

class ReferrerController: ObservableObject {
    @Published var referrers: [Referrer] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - CREATE
    
    /// Create a new referrer
    func createReferrer(_ referrer: Referrer) async throws -> Referrer {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let response = try await APIService.shared.post("/referrers", body: referrer)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.referrers.append(referrer)
        }
        
        return referrer
    }
    
    // MARK: - READ
    
    /// Fetch all referrers
    func fetchAllReferrers() async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let referrers = try await APIService.shared.get("/referrers")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.referrers = []
        }
        
        return referrers
    }
    
    /// Fetch a single referrer by ID
    func fetchReferrer(by id: UUID) async throws -> Referrer? {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return referrers.first { $0.id == id }
    }
    
    /// Fetch referrers by company
    func fetchReferrers(by companyId: UUID) async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let referrers = try await APIService.shared.get("/referrers?company_id=\(companyId)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return referrers.filter { $0.companyID == companyId }
    }
    
    /// Fetch referrers by role
    func fetchReferrers(by roleId: UUID) async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return referrers.filter { $0.roleID == roleId }
    }
    
    /// Search referrers by name
    func searchReferrers(by name: String) async throws -> [Referrer] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return referrers.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing referrer
    func updateReferrer(_ referrer: Referrer) async throws -> Referrer {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let updated = try await APIService.shared.put("/referrers/\(referrer.id)", body: referrer)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
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
        
        // TODO: Replace with actual API call
        // Example: try await APIService.shared.delete("/referrers/\(id)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
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

