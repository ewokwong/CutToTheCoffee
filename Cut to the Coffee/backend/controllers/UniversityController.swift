//
//  UniversityController.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation
import Combine

class UniversityController: ObservableObject {
    @Published var universities: [University] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = UniversityRepository()
    
    // MARK: - CREATE
    
    /// Create a new university
    func createUniversity(_ university: University) async throws -> University {
        isLoading = true
        defer { isLoading = false }
        
        let createdUniversity = try await repository.create(university)
        
        await MainActor.run {
            self.universities.append(createdUniversity)
        }
        
        return createdUniversity
    }
    
    /// Create a new university with just a name
    func createUniversity(name: String) async throws -> University {
        let university = University(name: name)
        return try await createUniversity(university)
    }
    
    // MARK: - READ
    
    /// Fetch all universities
    func fetchAllUniversities() async throws -> [University] {
        isLoading = true
        defer { isLoading = false }
        
        let fetchedUniversities = try await repository.fetchAll()
        
        await MainActor.run {
            self.universities = fetchedUniversities
        }
        
        return fetchedUniversities
    }
    
    /// Fetch a single university by ID
    func fetchUniversity(by id: UUID) async throws -> University? {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetch(by: id)
    }
    
    /// Search universities by name
    func searchUniversities(by name: String) async throws -> [University] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.searchByName(name)
    }
    
    // MARK: - UPDATE
    
    /// Update an existing university
    func updateUniversity(_ university: University) async throws -> University {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.update(university)
        
        await MainActor.run {
            if let index = self.universities.firstIndex(where: { $0.id == university.id }) {
                self.universities[index] = university
            }
        }
        
        return university
    }
    
    /// Update university name
    func updateUniversityName(for universityId: UUID, newName: String) async throws {
        guard var university = universities.first(where: { $0.id == universityId }) else {
            throw UniversityControllerError.universityNotFound
        }
        
        university.name = newName
        try await updateUniversity(university)
    }
    
    // MARK: - DELETE
    
    /// Delete a university by ID
    func deleteUniversity(by id: UUID) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.delete(by: id)
        
        await MainActor.run {
            self.universities.removeAll { $0.id == id }
        }
    }
    
    // MARK: - Error Handling
    
    enum UniversityControllerError: LocalizedError {
        case universityNotFound
        case invalidData
        case networkError
        
        var errorDescription: String? {
            switch self {
            case .universityNotFound:
                return "University not found"
            case .invalidData:
                return "Invalid university data"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
}
