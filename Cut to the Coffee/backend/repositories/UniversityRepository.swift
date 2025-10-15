//
//  UniversityRepository.swift
//  Cut the Coffee
//
//  Firestore repository for University operations
//

import Foundation
import FirebaseFirestore

class UniversityRepository {
    private let db = FirebaseManager.shared.db
    private let collectionName = FirebaseManager.Collections.universities
    
    // MARK: - CREATE
    
    /// Create a new university in Firestore
    func create(_ university: University) async throws -> University {
        let docRef = db.collection(collectionName).document(university.id.uuidString)
        try docRef.setData(from: university)
        return university
    }
    
    // MARK: - READ
    
    /// Fetch all universities
    func fetchAll() async throws -> [University] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "name")
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: University.self) }
    }
    
    /// Fetch a university by ID
    func fetch(by id: UUID) async throws -> University? {
        let docRef = db.collection(collectionName).document(id.uuidString)
        let snapshot = try await docRef.getDocument()
        return try snapshot.data(as: University.self)
    }
    
    /// Search universities by name
    func searchByName(_ name: String) async throws -> [University] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "name")
            .getDocuments()
        
        // Firestore doesn't support case-insensitive search, so filter locally
        let universities = try snapshot.documents.compactMap { try $0.data(as: University.self) }
        return universities.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    /// Listen to real-time updates for all universities
    func observeAll(completion: @escaping ([University]) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .order(by: "name")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching universities: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                let universities = documents.compactMap { try? $0.data(as: University.self) }
                completion(universities)
            }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing university
    func update(_ university: University) async throws {
        let docRef = db.collection(collectionName).document(university.id.uuidString)
        try docRef.setData(from: university, merge: false)
    }
    
    // MARK: - DELETE
    
    /// Delete a university by ID
    func delete(by id: UUID) async throws {
        let docRef = db.collection(collectionName).document(id.uuidString)
        try await docRef.delete()
    }
}

