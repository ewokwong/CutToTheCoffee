//
//  Request.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation

struct Request: Identifiable, Codable {
    var id: UUID
    var studentID: UUID
    var referrerID: UUID
    var status: RequestStatus
    var createdAt: Date
    var updatedAt: Date
}

// MARK: - Request Status
enum RequestStatus: String, Codable, CaseIterable {
    case pending = "pending"
    case accepted = "accepted"
    case rejected = "rejected"
    case completed = "completed"
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .accepted: return "Accepted"
        case .rejected: return "Rejected"
        case .completed: return "Completed"
        }
    }
}

// MARK: - Convenience Initializers
extension Request {
    /// Initialize a new request with pending status
    init(studentID: UUID, referrerID: UUID) {
        self.id = UUID()
        self.studentID = studentID
        self.referrerID = referrerID
        self.status = .pending
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    /// Update request status
    mutating func updateStatus(to newStatus: RequestStatus) {
        self.status = newStatus
        self.updatedAt = Date()
    }
}

