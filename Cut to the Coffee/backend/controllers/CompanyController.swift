//
//  CompanyController.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation
import Combine

class CompanyController: ObservableObject {
    @Published var companies: [Company] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = CompanyRepository()
    
    // MARK: - CREATE
    
    /// Create a new company
    func createCompany(_ company: Company) async throws -> Company {
        isLoading = true
        defer { isLoading = false }
        
        let createdCompany = try await repository.create(company)
        
        await MainActor.run {
            self.companies.append(createdCompany)
        }
        
        return createdCompany
    }
    
    /// Create a new company with just a name
    func createCompany(name: String) async throws -> Company {
        let company = Company(name: name)
        return try await createCompany(company)
    }
    
    // MARK: - READ
    
    /// Fetch all companies
    func fetchAllCompanies() async throws -> [Company] {
        isLoading = true
        defer { isLoading = false }
        
        let fetchedCompanies = try await repository.fetchAll()
        
        await MainActor.run {
            self.companies = fetchedCompanies
        }
        
        return fetchedCompanies
    }
    
    /// Fetch a single company by ID
    func fetchCompany(by id: UUID) async throws -> Company? {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetch(by: id)
    }
    
    /// Search companies by name
    func searchCompanies(by name: String) async throws -> [Company] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.searchByName(name)
    }
    
    // MARK: - UPDATE
    
    /// Update an existing company
    func updateCompany(_ company: Company) async throws -> Company {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.update(company)
        
        await MainActor.run {
            if let index = self.companies.firstIndex(where: { $0.id == company.id }) {
                self.companies[index] = company
            }
        }
        
        return company
    }
    
    /// Update company name
    func updateCompanyName(for companyId: UUID, newName: String) async throws {
        guard var company = companies.first(where: { $0.id == companyId }) else {
            throw CompanyControllerError.companyNotFound
        }
        
        company.name = newName
        try await updateCompany(company)
    }
    
    // MARK: - DELETE
    
    /// Delete a company by ID
    func deleteCompany(by id: UUID) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.delete(by: id)
        
        await MainActor.run {
            self.companies.removeAll { $0.id == id }
        }
    }
    
    // MARK: - Error Handling
    
    enum CompanyControllerError: LocalizedError {
        case companyNotFound
        case invalidData
        case networkError
        
        var errorDescription: String? {
            switch self {
            case .companyNotFound:
                return "Company not found"
            case .invalidData:
                return "Invalid company data"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
}
