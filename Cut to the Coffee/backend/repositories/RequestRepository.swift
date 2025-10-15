//
//  RequestRepository.swift
//  Cut the Coffee
//
//  Firestore repository for Request operations
//

import Foundation
import FirebaseFirestore

class RequestRepository {
    private let db = FirebaseManager.shared.db
    private let collectionName = FirebaseManager.Collections.requests
    
    // MARK: - CREATE
    
    /// Create a new request in Firestore
    func create(_ request: Request) async throws -> Request {
        let docRef = db.collection(collectionName).document(request.id.uuidString)
        try docRef.setData(from: request)
        return request
    }
    
    // MARK: - READ
    
    /// Fetch all requests
    func fetchAll() async throws -> [Request] {
        let snapshot = try await db.collection(collectionName).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Request.self) }
    }
    
    /// Fetch a request by ID
    func fetch(by id: UUID) async throws -> Request? {
        let docRef = db.collection(collectionName).document(id.uuidString)
        let snapshot = try await docRef.getDocument()
        return try snapshot.data(as: Request.self)
    }
    
    /// Fetch requests for a student
    func fetchByStudent(_ studentId: UUID) async throws -> [Request] {
        let snapshot = try await db.collection(collectionName)
            .whereField("studentID", isEqualTo: studentId.uuidString)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Request.self) }
    }
    
    /// Fetch requests for a referrer
    func fetchByReferrer(_ referrerId: UUID) async throws -> [Request] {
        let snapshot = try await db.collection(collectionName)
            .whereField("referrerID", isEqualTo: referrerId.uuidString)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Request.self) }
    }
    
    /// Fetch requests by status
    func fetchByStatus(_ status: RequestStatus) async throws -> [Request] {
        let snapshot = try await db.collection(collectionName)
            .whereField("status", isEqualTo: status.rawValue)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Request.self) }
    }
    
    /// Fetch pending requests for a referrer
    func fetchPendingByReferrer(_ referrerId: UUID) async throws -> [Request] {
        let snapshot = try await db.collection(collectionName)
            .whereField("referrerID", isEqualTo: referrerId.uuidString)
            .whereField("status", isEqualTo: RequestStatus.pending.rawValue)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Request.self) }
    }
    
    /// Listen to real-time updates for requests by student
    func observeByStudent(_ studentId: UUID, completion: @escaping ([Request]) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .whereField("studentID", isEqualTo: studentId.uuidString)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching requests: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                let requests = documents.compactMap { try? $0.data(as: Request.self) }
                completion(requests)
            }
    }
    
    /// Listen to real-time updates for requests by referrer
    func observeByReferrer(_ referrerId: UUID, completion: @escaping ([Request]) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .whereField("referrerID", isEqualTo: referrerId.uuidString)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching requests: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                let requests = documents.compactMap { try? $0.data(as: Request.self) }
                completion(requests)
            }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing request
    func update(_ request: Request) async throws {
        let docRef = db.collection(collectionName).document(request.id.uuidString)
        try docRef.setData(from: request, merge: false)
    }
    
    /// Update request status
    func updateStatus(for requestId: UUID, to status: RequestStatus) async throws {
        let docRef = db.collection(collectionName).document(requestId.uuidString)
        try await docRef.updateData([
            "status": status.rawValue,
            "updatedAt": Timestamp(date: Date())
        ])
    }
    
    // MARK: - DELETE
    
    /// Delete a request by ID
    func delete(by id: UUID) async throws {
        let docRef = db.collection(collectionName).document(id.uuidString)
        try await docRef.delete()
    }
}

