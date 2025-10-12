//
//  StudentController.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

class StudentController: ObservableObject {
    @Published var students: [Student] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - CREATE
    
    /// Create a new student
    func createStudent(_ student: Student) async throws -> Student {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let response = try await APIService.shared.post("/students", body: student)
        
        // Simulated API call
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        
        await MainActor.run {
            self.students.append(student)
        }
        
        return student
    }
    
    // MARK: - READ
    
    /// Fetch all students
    func fetchAllStudents() async throws -> [Student] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let students = try await APIService.shared.get("/students")
        
        // Simulated API call
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            // Mock data for now
            self.students = []
        }
        
        return students
    }
    
    /// Fetch a single student by ID
    func fetchStudent(by id: UUID) async throws -> Student? {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let student = try await APIService.shared.get("/students/\(id)")
        
        // Simulated API call
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return students.first { $0.id == id }
    }
    
    /// Search students by university
    func searchStudents(by university: String) async throws -> [Student] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let students = try await APIService.shared.get("/students/search?university=\(university)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return students.filter { $0.university.localizedCaseInsensitiveContains(university) }
    }
    
    /// Search students by graduation year
    func searchStudents(by year: Int) async throws -> [Student] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return students.filter { $0.yearGraduating == year }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing student
    func updateStudent(_ student: Student) async throws -> Student {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let updated = try await APIService.shared.put("/students/\(student.id)", body: student)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
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
        
        // TODO: Replace with actual API call
        // Example: try await APIService.shared.delete("/students/\(id)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
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

