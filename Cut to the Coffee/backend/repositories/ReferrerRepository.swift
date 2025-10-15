//
//  ReferrerRepository.swift
//  Cut the Coffee
//
//  Firestore repository for Referrer operations
//

import Foundation
import FirebaseFirestore

class ReferrerRepository {
    private let db = FirebaseManager.shared.db
    private let collectionName = FirebaseManager.Collections.referrers
    
    // MARK: - CREATE
    
    /// Create a new referrer in Firestore
    func create(_ referrer: Referrer) async throws -> Referrer {
        let docRef = db.collection(collectionName).document(referrer.id.uuidString)
        try docRef.setData(from: referrer)
        return referrer
    }
    
    // MARK: - READ
    
    /// Fetch all referrers
    func fetchAll() async throws -> [Referrer] {
        let snapshot = try await db.collection(collectionName).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Referrer.self) }
    }
    
    /// Fetch a referrer by ID
    func fetch(by id: UUID) async throws -> Referrer? {
        let docRef = db.collection(collectionName).document(id.uuidString)
        let snapshot = try await docRef.getDocument()
        return try snapshot.data(as: Referrer.self)
    }
    
    /// Fetch referrers by company
    func fetchByCompany(_ companyId: UUID) async throws -> [Referrer] {
        let snapshot = try await db.collection(collectionName)
            .whereField("companyID", isEqualTo: companyId.uuidString)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Referrer.self) }
    }
    
    /// Fetch referrers by role
    func fetchByRole(_ roleId: UUID) async throws -> [Referrer] {
        let snapshot = try await db.collection(collectionName)
            .whereField("roleID", isEqualTo: roleId.uuidString)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Referrer.self) }
    }
    
    /// Fetch referrers by university
    func fetchByUniversity(_ universityId: UUID) async throws -> [Referrer] {
        let snapshot = try await db.collection(collectionName)
            .whereField("universityID", isEqualTo: universityId.uuidString)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Referrer.self) }
    }
    
    /// Listen to real-time updates for all referrers
    func observeAll(completion: @escaping ([Referrer]) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching referrers: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                let referrers = documents.compactMap { try? $0.data(as: Referrer.self) }
                completion(referrers)
            }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing referrer
    func update(_ referrer: Referrer) async throws {
        let docRef = db.collection(collectionName).document(referrer.id.uuidString)
        try docRef.setData(from: referrer, merge: false)
    }
    
    /// Update specific fields
    func updateFields(for referrerId: UUID, fields: [String: Any]) async throws {
        let docRef = db.collection(collectionName).document(referrerId.uuidString)
        try await docRef.updateData(fields)
    }
    
    // MARK: - DELETE
    
    /// Delete a referrer by ID
    func delete(by id: UUID) async throws {
        let docRef = db.collection(collectionName).document(id.uuidString)
        try await docRef.delete()
    }
}

