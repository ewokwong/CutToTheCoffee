//
//  RoleRepository.swift
//  Cut to the Coffee
//
//  Firestore repository for Role operations
//

import Foundation
import FirebaseFirestore

class RoleRepository {
    private let db = FirebaseManager.shared.db
    private let collectionName = FirebaseManager.Collections.roles
    
    // MARK: - CREATE
    
    /// Create a new role in Firestore
    func create(_ role: Role) async throws -> Role {
        let docRef = db.collection(collectionName).document(role.id.uuidString)
        try docRef.setData(from: role)
        return role
    }
    
    // MARK: - READ
    
    /// Fetch all roles
    func fetchAll() async throws -> [Role] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "name")
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Role.self) }
    }
    
    /// Fetch a role by ID
    func fetch(by id: UUID) async throws -> Role? {
        let docRef = db.collection(collectionName).document(id.uuidString)
        let snapshot = try await docRef.getDocument()
        return try snapshot.data(as: Role.self)
    }
    
    /// Search roles by name
    func searchByName(_ name: String) async throws -> [Role] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "name")
            .getDocuments()
        
        // Firestore doesn't support case-insensitive search, so filter locally
        let roles = try snapshot.documents.compactMap { try $0.data(as: Role.self) }
        return roles.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    /// Listen to real-time updates for all roles
    func observeAll(completion: @escaping ([Role]) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .order(by: "name")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching roles: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                let roles = documents.compactMap { try? $0.data(as: Role.self) }
                completion(roles)
            }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing role
    func update(_ role: Role) async throws {
        let docRef = db.collection(collectionName).document(role.id.uuidString)
        try docRef.setData(from: role, merge: false)
    }
    
    // MARK: - DELETE
    
    /// Delete a role by ID
    func delete(by id: UUID) async throws {
        let docRef = db.collection(collectionName).document(id.uuidString)
        try await docRef.delete()
    }
}

