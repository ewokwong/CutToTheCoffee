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
    
    // MARK: - CREATE
    
    /// Create a new request
    func createRequest(_ request: Request) async throws -> Request {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let response = try await APIService.shared.post("/requests", body: request)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.requests.append(request)
        }
        
        return request
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
        
        // TODO: Replace with actual API call
        // Example: let requests = try await APIService.shared.get("/requests")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            self.requests = []
        }
        
        return requests
    }
    
    /// Fetch a single request by ID
    func fetchRequest(by id: UUID) async throws -> Request? {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return requests.first { $0.id == id }
    }
    
    /// Fetch all requests for a student
    func fetchRequests(forStudent studentId: UUID) async throws -> [Request] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let requests = try await APIService.shared.get("/requests?student_id=\(studentId)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return requests.filter { $0.studentID == studentId }
    }
    
    /// Fetch all requests for a referrer
    func fetchRequests(forReferrer referrerId: UUID) async throws -> [Request] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let requests = try await APIService.shared.get("/requests?referrer_id=\(referrerId)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return requests.filter { $0.referrerID == referrerId }
    }
    
    /// Fetch requests by status
    func fetchRequests(withStatus status: RequestStatus) async throws -> [Request] {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let requests = try await APIService.shared.get("/requests?status=\(status.rawValue)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return requests.filter { $0.status == status }
    }
    
    /// Fetch pending requests for a referrer
    func fetchPendingRequests(forReferrer referrerId: UUID) async throws -> [Request] {
        let referrerRequests = try await fetchRequests(forReferrer: referrerId)
        return referrerRequests.filter { $0.status == .pending }
    }
    
    // MARK: - UPDATE
    
    /// Update an existing request
    func updateRequest(_ request: Request) async throws -> Request {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: let updated = try await APIService.shared.put("/requests/\(request.id)", body: request)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            if let index = self.requests.firstIndex(where: { $0.id == request.id }) {
                self.requests[index] = request
            }
        }
        
        return request
    }
    
    /// Update request status
    func updateRequestStatus(for requestId: UUID, to status: RequestStatus) async throws {
        guard var request = requests.first(where: { $0.id == requestId }) else {
            throw RequestControllerError.requestNotFound
        }
        
        request.updateStatus(to: status)
        try await updateRequest(request)
    }
    
    /// Accept a request
    func acceptRequest(by id: UUID) async throws {
        try await updateRequestStatus(for: id, to: .accepted)
    }
    
    /// Complete a request
    func completeRequest(by id: UUID) async throws {
        try await updateRequestStatus(for: id, to: .completed)
    }
    
    // MARK: - DELETE
    
    /// Delete a request by ID
    func deleteRequest(by id: UUID) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Replace with actual API call
        // Example: try await APIService.shared.delete("/requests/\(id)")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
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
            rejected: referrerRequests.filter { $0.status == .rejected }.count,
            completed: referrerRequests.filter { $0.status == .completed }.count,
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
    let completed: Int
}

