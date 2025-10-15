//
//  Request.swift
//  Cut the Coffee
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
    case interested = "interested"
    case accepted = "accepted"
    case rejected = "rejected"
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .interested: return "Interested"
        case .accepted: return "Accepted"
        case .rejected: return "Rejected"
        }
    }
}

// MARK: - UI Extensions for RequestStatus
import SwiftUI

extension RequestStatus {
    /// Color for status badge in UI
    var color: Color {
        switch self {
        case .pending: return Color.orange
        case .interested: return Color.purple
        case .accepted: return Color.green
        case .rejected: return Color.red
        }
    }
    
    /// Icon for status badge in UI
    var icon: String {
        switch self {
        case .pending: return "clock.fill"
        case .interested: return "eye.fill"
        case .accepted: return "checkmark.circle.fill"
        case .rejected: return "xmark.circle.fill"
        }
    }
    
    /// Text label for status badge in UI
    var text: String {
        return displayName
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

