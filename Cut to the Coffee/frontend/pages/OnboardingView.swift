//
//  OnboardingView.swift
//  Cut to the Coffee
//
//  Created by Ethan Kwong on 12/10/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct OnboardingView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    
    // Form state
    @State private var currentStep = 0
    @State private var degree: String = ""
    @State private var yearGraduating: String = ""
    @State private var linkedinURL: String = ""
    @State private var bio: String = ""
    @State private var hasUploadedResume: Bool = false
    @State private var resumeFileName: String = ""
    
    // UI state
    @State private var showingDocumentPicker = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let totalSteps = 3
    
    var body: some View {
        ZStack {
            // Light background
            AppTheme.lightGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Bar
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        ForEach(0..<totalSteps, id: \.self) { step in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(step <= currentStep ? AppTheme.coffeeBrown : AppTheme.latteBrown)
                                .frame(height: 6)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Step \(currentStep + 1) of \(totalSteps)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 40))
                                .foregroundColor(AppTheme.coffeeBrown)
                            
                            Text(stepTitle)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .coffeePrimaryText()
                                .multilineTextAlignment(.center)
                            
                            Text(stepDescription)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                        
                        // Step Content
                        VStack(spacing: 20) {
                            switch currentStep {
                            case 0:
                                academicInfoStep
                            case 1:
                                resumeUploadStep
                            case 2:
                                profileDetailsStep
                            default:
                                EmptyView()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                // Navigation Buttons
                VStack(spacing: 12) {
                    Button(currentStep == totalSteps - 1 ? "Complete Onboarding" : "Continue") {
                        handleContinue()
                    }
                    .buttonStyle(.coffeePrimary)
                    .disabled(!canProceed)
                    .opacity(canProceed ? 1.0 : 0.5)
                    
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                        .buttonStyle(.coffeeSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker(onDocumentPicked: handleDocumentPicked)
        }
    }
    
    // MARK: - Step Views
    
    private var academicInfoStep: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Degree Program")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                
                TextField("e.g., Computer Science", text: $degree)
                    .textFieldStyle(.coffeeStyle)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Graduation Year")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                
                TextField("e.g., 2025", text: $yearGraduating)
                    .textFieldStyle(.coffeeStyle)
                    .keyboardType(.numberPad)
            }
        }
        .padding(20)
        .coffeeCardStyle()
    }
    
    private var resumeUploadStep: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                if hasUploadedResume {
                    // Resume uploaded state
                    VStack(spacing: 12) {
                        Image(systemName: "doc.fill.badge.checkmark")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.coffeeBrown)
                        
                        Text("Resume Uploaded")
                            .font(.system(size: 18, weight: .semibold))
                            .coffeePrimaryText()
                        
                        Text(resumeFileName)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        Button("Change Resume") {
                            showingDocumentPicker = true
                        }
                        .buttonStyle(.coffeeSecondary)
                        .padding(.top, 8)
                    }
                } else {
                    // No resume uploaded state
                    VStack(spacing: 12) {
                        Image(systemName: "doc.badge.arrow.up")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        Text("Upload Your Resume")
                            .font(.system(size: 18, weight: .semibold))
                            .coffeePrimaryText()
                        
                        Text("We'll use this to help referrers learn about your background")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Button("Choose File") {
                            showingDocumentPicker = true
                        }
                        .buttonStyle(.coffeePrimary)
                        .padding(.top, 8)
                    }
                }
            }
            .padding(40)
            .coffeeCardStyle()
        }
    }
    
    private var profileDetailsStep: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("LinkedIn URL")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                
                TextField("https://linkedin.com/in/yourprofile", text: $linkedinURL)
                    .textFieldStyle(.coffeeStyle)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Bio (Optional)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                
                TextEditor(text: $bio)
                    .frame(height: 120)
                    .padding(12)
                    .background(AppTheme.creamWhite)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.latteBrown, lineWidth: 1)
                    )
            }
        }
        .padding(20)
        .coffeeCardStyle()
    }
    
    // MARK: - Helper Properties
    
    private var stepTitle: String {
        switch currentStep {
        case 0:
            return "Academic Information"
        case 1:
            return "Upload Resume"
        case 2:
            return "Complete Your Profile"
        default:
            return ""
        }
    }
    
    private var stepDescription: String {
        switch currentStep {
        case 0:
            return "Let's start with your academic background"
        case 1:
            return "Help referrers understand your experience"
        case 2:
            return "Add your LinkedIn and a brief bio"
        default:
            return ""
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return !degree.isEmpty && !yearGraduating.isEmpty && Int(yearGraduating) != nil
        case 1:
            return hasUploadedResume
        case 2:
            return !linkedinURL.isEmpty
        default:
            return false
        }
    }
    
    // MARK: - Actions
    
    private func handleContinue() {
        if currentStep < totalSteps - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    private func handleDocumentPicked(_ url: URL) {
        // In a real app, you would upload this to Firebase Storage
        // For now, we'll just mark it as uploaded and store the filename
        resumeFileName = url.lastPathComponent
        hasUploadedResume = true
        
        // TODO: Implement actual file upload to Firebase Storage
        print("📄 Resume selected: \(resumeFileName)")
    }
    
    private func completeOnboarding() {
        // Validate all fields
        guard let graduationYear = Int(yearGraduating) else {
            showError(message: "Please enter a valid graduation year")
            return
        }
        
        guard hasUploadedResume else {
            showError(message: "Please upload your resume")
            return
        }
        
        guard !linkedinURL.isEmpty else {
            showError(message: "Please enter your LinkedIn URL")
            return
        }
        
        // TODO: Create student profile in Firebase
        // For now, we'll just mark onboarding as complete
        print("✅ Onboarding data collected:")
        print("   Degree: \(degree)")
        print("   Graduation Year: \(graduationYear)")
        print("   LinkedIn: \(linkedinURL)")
        print("   Bio: \(bio)")
        print("   Resume: \(resumeFileName)")
        
        // Mark onboarding as complete
        authManager.completeOnboarding()
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}

// MARK: - Custom Text Field Style

struct CoffeeTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(AppTheme.creamWhite)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.latteBrown, lineWidth: 1)
            )
    }
}

extension TextFieldStyle where Self == CoffeeTextFieldStyle {
    static var coffeeStyle: CoffeeTextFieldStyle {
        CoffeeTextFieldStyle()
    }
}

// MARK: - Document Picker

struct DocumentPicker: UIViewControllerRepresentable {
    let onDocumentPicked: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDocumentPicked: onDocumentPicked)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onDocumentPicked: (URL) -> Void
        
        init(onDocumentPicked: @escaping (URL) -> Void) {
            self.onDocumentPicked = onDocumentPicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onDocumentPicked(url)
        }
    }
}

#Preview {
    OnboardingView()
}

