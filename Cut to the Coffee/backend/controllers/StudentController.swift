//
//  StudentController.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation
import Combine

class StudentController: ObservableObject {
    @Published var students: [Student] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = StudentRepository()
    
    // MARK: - CREATE
    
    /// Create a new student
    func createStudent(_ student: Student) async throws -> Student {
        isLoading = true
        defer { isLoading = false }
        
        let createdStudent = try await repository.create(student)
        
        await MainActor.run {
            self.students.append(createdStudent)
        }
        
        return createdStudent
    }
    
    // MARK: - READ
    
    /// Fetch all students
    func fetchAllStudents() async throws -> [Student] {
        isLoading = true
        defer { isLoading = false }
        
        let fetchedStudents = try await repository.fetchAll()
        
        await MainActor.run {
            self.students = fetchedStudents
        }
        
        return fetchedStudents
    }
    
    /// Fetch a single student by ID
    func fetchStudent(by id: UUID) async throws -> Student? {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetch(by: id)
    }
    
    /// Search students by university
    func searchStudents(by universityId: UUID) async throws -> [Student] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchByUniversity(universityId)
    }
    
    /// Search students by graduation year
    func searchStudents(by year: Int) async throws -> [Student] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchByGraduationYear(year)
    }
    
    // MARK: - UPDATE
    
    /// Update an existing student
    func updateStudent(_ student: Student) async throws -> Student {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.update(student)
        
        await MainActor.run {
            if let index = self.students.firstIndex(where: { $0.id == student.id }) {
                self.students[index] = student
            }
        }
        
        return student
    }
    
    /// Update student's bio
    func updateBio(for studentId: UUID, bio: String) async throws {
        guard var student = students.first(where: { $0.id == studentId }) else {
            throw StudentControllerError.studentNotFound
        }
        
        student.bio = bio
        try await updateStudent(student)
    }
    
    /// Update student's profile picture
    func updateProfilePicture(for studentId: UUID, pictureURL: String) async throws {
        guard var student = students.first(where: { $0.id == studentId }) else {
            throw StudentControllerError.studentNotFound
        }
        
        student.profilePictureURL = pictureURL
        try await updateStudent(student)
    }
    
    // MARK: - DELETE
    
    /// Delete a student by ID
    func deleteStudent(by id: UUID) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.delete(by: id)
        
        await MainActor.run {
            self.students.removeAll { $0.id == id }
        }
    }
    
    // MARK: - Error Handling
    
    enum StudentControllerError: LocalizedError {
        case studentNotFound
        case invalidData
        case networkError
        
        var errorDescription: String? {
            switch self {
            case .studentNotFound:
                return "Student not found"
            case .invalidData:
                return "Invalid student data"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
}

