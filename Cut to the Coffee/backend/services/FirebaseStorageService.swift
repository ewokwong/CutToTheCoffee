//
//  FirebaseStorageService.swift
//  Cut the Coffee
//
//  Service for uploading files to Firebase Storage
//

import Foundation
import FirebaseStorage

/// Service responsible for uploading and managing files in Firebase Storage
class FirebaseStorageService {
    
    static let shared = FirebaseStorageService()
    
    private let storage = Storage.storage()
    
    private init() {}
    
    // MARK: - Resume Upload
    
    /// Upload a PDF resume to Firebase Storage
    /// - Parameters:
    ///   - fileURL: Local file URL of the PDF
    ///   - userId: User ID to organize files
    /// - Returns: Download URL of the uploaded file
    func uploadResume(fileURL: URL, userId: String) async throws -> String {
        // Create a unique filename
        let filename = "\(userId)_resume_\(Date().timeIntervalSince1970).pdf"
        let storageRef = storage.reference().child("resumes/\(filename)")
        
        // Read file data
        let fileData = try Data(contentsOf: fileURL)
        
        // Set metadata
        let metadata = StorageMetadata()
        metadata.contentType = "application/pdf"
        
        // Upload file
        print("📤 Uploading resume to Firebase Storage...")
        let _ = try await storageRef.putDataAsync(fileData, metadata: metadata)
        
        // Get download URL
        let downloadURL = try await storageRef.downloadURL()
        
        print("✅ Resume uploaded successfully: \(downloadURL.absoluteString)")
        
        return downloadURL.absoluteString
    }
    
    /// Delete a resume from Firebase Storage
    /// - Parameter resumeURL: The download URL of the resume to delete
    func deleteResume(resumeURL: String) async throws {
        guard let url = URL(string: resumeURL) else {
            throw StorageError.invalidURL
        }
        
        let storageRef = storage.reference(forURL: url.absoluteString)
        try await storageRef.delete()
        
        print("🗑️ Resume deleted from Firebase Storage")
    }
    
    // MARK: - Error Types
    
    enum StorageError: LocalizedError {
        case invalidURL
        case uploadFailed
        case deleteFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid storage URL"
            case .uploadFailed:
                return "Failed to upload file"
            case .deleteFailed:
                return "Failed to delete file"
            }
        }
    }
}

