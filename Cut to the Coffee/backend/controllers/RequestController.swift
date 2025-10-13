//
//  RequestController.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import Foundation
import Combine

class RequestController: ObservableObject {
    @Published var requests: [Request] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = RequestRepository()
    
    // MARK: - CREATE
    
    /// Create a new request
    func createRequest(_ request: Request) async throws -> Request {
        isLoading = true
        defer { isLoading = false }
        
        let createdRequest = try await repository.create(request)
        
        await MainActor.run {
            self.requests.append(createdRequest)
        }
        
        return createdRequest
    }
    
    /// Create a new request between student and referrer
    func createRequest(studentId: UUID, referrerId: UUID) async throws -> Request {
        let request = Request(studentID: studentId, referrerID: referrerId)
        return try await createRequest(request)
    }
    
    // MARK: - READ
    
    /// Fetch all requests
    func fetchAllRequests() async throws -> [Request] {
        isLoading = true
        defer { isLoading = false }
        
        let fetchedRequests = try await repository.fetchAll()
        
        await MainActor.run {
            self.requests = fetchedRequests
        }
        
        return fetchedRequests
    }
    
    /// Fetch a single request by ID
    func fetchRequest(by id: UUID) async throws -> Request? {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetch(by: id)
    }
    
    /// Fetch all requests for a student
    func fetchRequests(forStudent studentId: UUID) async throws -> [Request] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchByStudent(studentId)
    }
    
    /// Fetch all requests for a referrer
    func fetchRequests(forReferrer referrerId: UUID) async throws -> [Request] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchByReferrer(referrerId)
    }
    
    /// Fetch requests by status
    func fetchRequests(withStatus status: RequestStatus) async throws -> [Request] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchByStatus(status)
    }
    
    /// Fetch pending requests for a referrer
    func fetchPendingRequests(forReferrer referrerId: UUID) async throws -> [Request] {
        isLoading = true
        defer { isLoading = false }
        
        return try await repository.fetchPendingByReferrer(referrerId)
    }
    
    // MARK: - UPDATE
    
    /// Update an existing request
    func updateRequest(_ request: Request) async throws -> Request {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.update(request)
        
        await MainActor.run {
            if let index = self.requests.firstIndex(where: { $0.id == request.id }) {
                self.requests[index] = request
            }
        }
        
        return request
    }
    
    /// Update request status
    func updateRequestStatus(for requestId: UUID, to status: RequestStatus) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.updateStatus(for: requestId, to: status)
        
        // Update local cache
        await MainActor.run {
            if let index = self.requests.firstIndex(where: { $0.id == requestId }) {
                self.requests[index].updateStatus(to: status)
            }
        }
    }
    
    /// Accept a request
    func acceptRequest(by id: UUID) async throws {
        try await updateRequestStatus(for: id, to: .accepted)
    }
        
    // MARK: - DELETE
    
    /// Delete a request by ID
    func deleteRequest(by id: UUID) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await repository.delete(by: id)
        
        await MainActor.run {
            self.requests.removeAll { $0.id == id }
        }
    }
    
    // MARK: - Statistics
    
    /// Get request statistics for a referrer
    func getRequestStats(forReferrer referrerId: UUID) async throws -> RequestStats {
        let referrerRequests = try await fetchRequests(forReferrer: referrerId)
        
        return RequestStats(
            total: referrerRequests.count,
            pending: referrerRequests.filter { $0.status == .pending }.count,
            accepted: referrerRequests.filter { $0.status == .accepted }.count,
            rejected: referrerRequests.filter { $0.status == .rejected }.count
        )
    }
    
    // MARK: - Error Handling
    
    enum RequestControllerError: LocalizedError {
        case requestNotFound
        case invalidData
        case networkError
        case invalidStatusTransition
        
        var errorDescription: String? {
            switch self {
            case .requestNotFound:
                return "Request not found"
            case .invalidData:
                return "Invalid request data"
            case .networkError:
                return "Network error occurred"
            case .invalidStatusTransition:
                return "Invalid status transition"
            }
        }
    }
}

// MARK: - Request Statistics

struct RequestStats {
    let total: Int
    let pending: Int
    let accepted: Int
    let rejected: Int
}

