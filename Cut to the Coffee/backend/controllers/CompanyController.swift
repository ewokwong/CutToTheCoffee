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
    
    // MARK: - CREATE
    
    /// Create a new company
    func createCompany(_ company: Company) async throws -> Company {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let response = try await APIService.shared.post("/companies", body: company)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.companies.append(company)
        }
        
        return company
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
        
        // TODO: Replace with actual API call
        // Example: let companies = try await APIService.shared.get("/companies")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.companies = []
        }
        
        return companies
    }
    
    /// Fetch a single company by ID
    func fetchCompany(by id: UUID) async throws -> Company? {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return companies.first { $0.id == id }
    }
    
    /// Search companies by name
    func searchCompanies(by name: String) async throws -> [Company] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let companies = try await APIService.shared.get("/companies/search?name=\(name)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return companies.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing company
    func updateCompany(_ company: Company) async throws -> Company {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let updated = try await APIService.shared.put("/companies/\(company.id)", body: company)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
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
        
        // TODO: Replace with actual API call
        // Example: try await APIService.shared.delete("/companies/\(id)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
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

