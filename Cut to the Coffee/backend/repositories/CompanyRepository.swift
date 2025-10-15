//
//  CompanyRepository.swift
//  Cut the Coffee
//
//  Firestore repository for Company operations
//

import Foundation
import FirebaseFirestore

class CompanyRepository {
    private let db = FirebaseManager.shared.db
    private let collectionName = FirebaseManager.Collections.companies
    
    // MARK: - CREATE
    
    /// Create a new company in Firestore
    func create(_ company: Company) async throws -> Company {
        let docRef = db.collection(collectionName).document(company.id.uuidString)
        try docRef.setData(from: company)
        return company
    }
    
    // MARK: - READ
    
    /// Fetch all companies
    func fetchAll() async throws -> [Company] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "name")
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Company.self) }
    }
    
    /// Fetch a company by ID
    func fetch(by id: UUID) async throws -> Company? {
        let docRef = db.collection(collectionName).document(id.uuidString)
        let snapshot = try await docRef.getDocument()
        return try snapshot.data(as: Company.self)
    }
    
    /// Search companies by name
    func searchByName(_ name: String) async throws -> [Company] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "name")
            .getDocuments()
        
        // Firestore doesn't support case-insensitive search, so filter locally
        let companies = try snapshot.documents.compactMap { try $0.data(as: Company.self) }
        return companies.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    /// Listen to real-time updates for all companies
    func observeAll(completion: @escaping ([Company]) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .order(by: "name")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching companies: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                let companies = documents.compactMap { try? $0.data(as: Company.self) }
                completion(companies)
            }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing company
    func update(_ company: Company) async throws {
        let docRef = db.collection(collectionName).document(company.id.uuidString)
        try docRef.setData(from: company, merge: false)
    }
    
    // MARK: - DELETE
    
    /// Delete a company by ID
    func delete(by id: UUID) async throws {
        let docRef = db.collection(collectionName).document(id.uuidString)
        try await docRef.delete()
    }
}

