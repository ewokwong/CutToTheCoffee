//
//  StudentRepository.swift
//  Cut to the Coffee
//
//  Firestore repository for Student operations
//

import Foundation
import FirebaseFirestore

class StudentRepository {
    private let db = FirebaseManager.shared.db
    private let collectionName = FirebaseManager.Collections.students
    
    // MARK: - CREATE
    
    /// Create a new student in Firestore
    func create(_ student: Student) async throws -> Student {
        let docRef = db.collection(collectionName).document(student.id.uuidString)
        try docRef.setData(from: student)
        return student
    }
    
    // MARK: - READ
    
    /// Fetch all students
    func fetchAll() async throws -> [Student] {
        let snapshot = try await db.collection(collectionName).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Student.self) }
    }
    
    /// Fetch a student by ID
    func fetch(by id: UUID) async throws -> Student? {
        let docRef = db.collection(collectionName).document(id.uuidString)
        let snapshot = try await docRef.getDocument()
        return try snapshot.data(as: Student.self)
    }
    
    /// Fetch students by university
    func fetchByUniversity(_ universityId: UUID) async throws -> [Student] {
        let snapshot = try await db.collection(collectionName)
            .whereField("universityID", isEqualTo: universityId.uuidString)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Student.self) }
    }
    
    /// Fetch students by graduation year
    func fetchByGraduationYear(_ year: Int) async throws -> [Student] {
        let snapshot = try await db.collection(collectionName)
            .whereField("yearGraduating", isEqualTo: year)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Student.self) }
    }
    
    /// Listen to real-time updates for all students
    func observeAll(completion: @escaping ([Student]) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching students: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                let students = documents.compactMap { try? $0.data(as: Student.self) }
                completion(students)
            }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing student
    func update(_ student: Student) async throws {
        let docRef = db.collection(collectionName).document(student.id.uuidString)
        try docRef.setData(from: student, merge: false)
    }
    
    /// Update specific fields
    func updateFields(for studentId: UUID, fields: [String: Any]) async throws {
        let docRef = db.collection(collectionName).document(studentId.uuidString)
        try await docRef.updateData(fields)
    }
    
    // MARK: - DELETE
    
    /// Delete a student by ID
    func delete(by id: UUID) async throws {
        let docRef = db.collection(collectionName).document(id.uuidString)
        try await docRef.delete()
    }
}

