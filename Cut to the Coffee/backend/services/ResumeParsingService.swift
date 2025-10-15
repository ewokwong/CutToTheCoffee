//
//  ResumeParsingService.swift
//  Cut the Coffee
//
//  Service for parsing PDF resumes using LLM
//

import Foundation
import PDFKit

/// Service responsible for extracting text from PDF resumes and parsing with LLM
class ResumeParsingService {
    
    static let shared = ResumeParsingService()
    
    private init() {}
    
    // MARK: - Models
    
    /// Structured data extracted from a resume
    struct ParsedResumeData: Codable {
        let name: String?
        let email: String?
        let linkedinURL: String?
        let degree: String?
        let graduationYear: Int?
        let bio: String?
        let university: String?
        let major: String?
        let skills: [String]?
        let experiences: [WorkExperience]?
    }
    
    struct WorkExperience: Codable {
        let company: String
        let position: String
        let duration: String
        let description: String?
    }
    
    // MARK: - Public Methods
    
    /// Parse a PDF resume and extract structured data
    /// - Parameter url: Local file URL of the PDF
    /// - Returns: Parsed resume data
    func parseResume(from url: URL) async throws -> ParsedResumeData {
        // Step 1: Extract text from PDF
        let pdfText = try extractTextFromPDF(url: url)
        
        guard !pdfText.isEmpty else {
            throw ResumeParsingError.emptyPDF
        }
        
        print("📄 Extracted text from PDF (\(pdfText.count) characters)")
        print("📝 Extracted text preview:")
        print(String(pdfText.prefix(500))) // Print first 500 characters for debugging
        
        // Step 2: Basic parsing (LLM integration disabled for testing)
        let parsedData = parseBasicInfo(from: pdfText)
        
        print("✅ Successfully extracted text from resume")
        
        return parsedData
    }
    
    // MARK: - PDF Text Extraction
    
    /// Extract text content from a PDF file
    private func extractTextFromPDF(url: URL) throws -> String {
        guard let pdfDocument = PDFDocument(url: url) else {
            throw ResumeParsingError.invalidPDF
        }
        
        var extractedText = ""
        
        // Iterate through all pages
        for pageIndex in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else { continue }
            guard let pageText = page.string else { continue }
            
            extractedText += pageText + "\n\n"
        }
        
        return extractedText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Basic Parsing (No LLM)
    
    /// Basic parsing that extracts simple patterns from resume text
    /// TODO: Replace with LLM integration later
    private func parseBasicInfo(from text: String) -> ParsedResumeData {
        let lines = text.components(separatedBy: .newlines)
        
        // Try to find email using regex
        var email: String?
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if let regex = try? NSRegularExpression(pattern: emailPattern) {
            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, range: range) {
                if let emailRange = Range(match.range, in: text) {
                    email = String(text[emailRange])
                }
            }
        }
        
        // Try to find LinkedIn URL
        var linkedinURL: String?
        let linkedinPattern = "(https?://)?(www\\.)?linkedin\\.com/in/[A-Za-z0-9_-]+"
        if let regex = try? NSRegularExpression(pattern: linkedinPattern) {
            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, range: range) {
                if let urlRange = Range(match.range, in: text) {
                    linkedinURL = String(text[urlRange])
                    if !linkedinURL!.hasPrefix("http") {
                        linkedinURL = "https://" + linkedinURL!
                    }
                }
            }
        }
        
        // Try to extract graduation year (4-digit number between 2020-2030)
        var graduationYear: Int?
        let yearPattern = "20[2-3][0-9]"
        if let regex = try? NSRegularExpression(pattern: yearPattern) {
            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, range: range) {
                if let yearRange = Range(match.range, in: text),
                   let year = Int(text[yearRange]) {
                    graduationYear = year
                }
            }
        }
        
        // Name is often on the first non-empty line
        let name = lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty })
        
        // Return basic extracted data
        return ParsedResumeData(
            name: name,
            email: email,
            linkedinURL: linkedinURL,
            degree: nil,
            graduationYear: graduationYear,
            bio: nil,
            university: nil,
            major: nil,
            skills: nil,
            experiences: nil
        )
    }
    
    // MARK: - LLM Integration (Disabled for Testing)
    
    /* 
    TODO: Enable this later when you want to use OpenAI for better parsing
    
    /// Parse resume text using OpenAI API
    private func parseWithLLM(resumeText: String) async throws -> ParsedResumeData {
        // Check if API key is configured
        guard !AppConfig.openAIAPIKey.isEmpty && AppConfig.openAIAPIKey != "YOUR_OPENAI_API_KEY_HERE" else {
            throw ResumeParsingError.apiKeyNotConfigured
        }
        
        // Prepare the prompt for the LLM
        let systemPrompt = """
        You are a resume parsing assistant. Extract structured information from the provided resume text.
        Return the data in valid JSON format with the following structure:
        {
            "name": "Full name of the candidate",
            "email": "Email address",
            "linkedinURL": "LinkedIn profile URL",
            "degree": "Current degree program (e.g., Bachelor of Science in Computer Science)",
            "graduationYear": 2025,
            "university": "University name",
            "major": "Major/field of study",
            "bio": "A brief professional summary (2-3 sentences)",
            "skills": ["skill1", "skill2"],
            "experiences": [
                {
                    "company": "Company name",
                    "position": "Job title",
                    "duration": "Time period",
                    "description": "Brief description"
                }
            ]
        }
        
        Important rules:
        - If any field is not found, use null
        - graduationYear should be a number
        - Extract only factual information from the resume
        - For bio, create a concise summary based on their experience and skills
        - Return ONLY valid JSON, no additional text or markdown formatting
        """
        
        let userPrompt = """
        Parse the following resume and extract structured data:
        
        \(resumeText)
        """
        
        // Prepare API request
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(AppConfig.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini", // Using GPT-4o mini for cost efficiency
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.3, // Lower temperature for more consistent extraction
            "response_format": ["type": "json_object"]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Make API request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ResumeParsingError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            // Try to extract error message
            if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = errorResponse["error"] as? [String: Any],
               let message = error["message"] as? String {
                print("❌ OpenAI API Error: \(message)")
                throw ResumeParsingError.apiError(message)
            }
            throw ResumeParsingError.apiError("HTTP \(httpResponse.statusCode)")
        }
        
        // Parse response
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = jsonResponse["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw ResumeParsingError.invalidResponse
        }
        
        // Parse the JSON content
        guard let contentData = content.data(using: .utf8) else {
            throw ResumeParsingError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let parsedData = try decoder.decode(ParsedResumeData.self, from: contentData)
        
        return parsedData
    }
    */
    
    // MARK: - Error Types
    
    enum ResumeParsingError: LocalizedError {
        case invalidPDF
        case emptyPDF
        case apiKeyNotConfigured
        case apiError(String)
        case invalidResponse
        case parsingFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidPDF:
                return "The selected file is not a valid PDF"
            case .emptyPDF:
                return "The PDF appears to be empty or contains no readable text"
            case .apiKeyNotConfigured:
                return "OpenAI API key is not configured. Please add it to Config.swift"
            case .apiError(let message):
                return "API Error: \(message)"
            case .invalidResponse:
                return "Failed to parse the API response"
            case .parsingFailed:
                return "Failed to extract data from the resume"
            }
        }
    }
}

