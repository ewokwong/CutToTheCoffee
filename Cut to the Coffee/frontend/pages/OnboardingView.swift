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
    
    // Intro animation state
    @State private var showIntro = true
    @State private var currentIntroPhrase = 0
    @State private var phraseOpacity: Double = 0
    
    let totalSteps = 3
    
    let introPhrases = [
        "Hello!",
        "We're so glad you're here.",
        "Just before you jump in,",
        "we need to explain a few things"
    ]
    
    var body: some View {
        ZStack {
            // Light background
            AppTheme.lightGradient
                .ignoresSafeArea()
            
            if showIntro {
                // Intro animation view
                introAnimationView
                    .transition(.opacity)
            } else {
                // Main onboarding view
                onboardingContentView
                    .transition(.opacity)
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
        .onAppear {
            startIntroAnimation()
        }
    }
    
    // MARK: - Intro Animation View
    
    private var introAnimationView: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Animated text
                Text(introPhrases[currentIntroPhrase])
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.coffeeBrown)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(phraseOpacity)
                
                Spacer()
            }
            
            // Skip button
            VStack {
                HStack {
                    Spacer()
                    Button("Skip") {
                        skipIntro()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Main Onboarding Content View
    
    private var onboardingContentView: some View {
        VStack(spacing: 0) {
            // Top bar with back button
            HStack {
                Button(action: {
                    authManager.signOut()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(AppTheme.coffeeBrown)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                
                Spacer()
                
                // Test button to skip to homepage
                Button(action: {
                    authManager.completeOnboarding()
                }) {
                    Text("TEST: Skip to Home")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.creamWhite)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppTheme.coffeeBrown)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 8)
            }
            .padding(.horizontal, 8)
            .padding(.top, 20)
            
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
    
    // MARK: - Intro Animation Actions
    
    private func startIntroAnimation() {
        animateNextPhrase()
    }
    
    private func animateNextPhrase() {
        // Fade in current phrase
        withAnimation(.easeIn(duration: 0.6)) {
            phraseOpacity = 1.0
        }
        
        // Wait, then fade out and move to next phrase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                phraseOpacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if currentIntroPhrase < introPhrases.count - 1 {
                    currentIntroPhrase += 1
                    animateNextPhrase()
                } else {
                    // Animation complete, show main content
                    completeIntro()
                }
            }
        }
    }
    
    private func completeIntro() {
        withAnimation(.easeInOut(duration: 0.6)) {
            showIntro = false
        }
    }
    
    private func skipIntro() {
        currentIntroPhrase = introPhrases.count - 1
        withAnimation(.easeInOut(duration: 0.4)) {
            showIntro = false
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
        
        // Create student profile in Firebase
        Task {
            do {
                // Get user info from auth manager
                guard let appleUserId = authManager.currentUserId,
                      let name = authManager.userFullName,
                      let email = authManager.userEmail else {
                    showError(message: "Missing user information. Please sign in again.")
                    return
                }
                
                // TODO: Get actual university ID (for now using a placeholder)
                // You'll need to implement university selection in onboarding
                let placeholderUniversityId = UUID()
                
                // Create student profile
                let student = Student(
                    name: name,
                    email: email,
                    linkedinURL: linkedinURL,
                    universityID: placeholderUniversityId,
                    appleUserId: appleUserId,
                    resumeURL: resumeFileName, // TODO: Replace with actual uploaded URL from Firebase Storage
                    degree: degree,
                    yearGraduating: graduationYear,
                    bio: bio.isEmpty ? nil : bio,
                    profilePictureURL: nil
                )
                
                // Save to Firebase
                let controller = StudentController()
                let _ = try await controller.createStudent(student)
                
                print("✅ Student profile created in Firebase:")
                print("   ID: \(student.id)")
                print("   Name: \(name)")
                print("   Email: \(email)")
                print("   Degree: \(degree)")
                print("   Graduation Year: \(graduationYear)")
                print("   LinkedIn: \(linkedinURL)")
                print("   Bio: \(bio)")
                print("   Resume: \(resumeFileName)")
                
                // Mark onboarding as complete
                await MainActor.run {
                    authManager.completeOnboarding()
                }
            } catch {
                print("❌ Error creating student profile: \(error.localizedDescription)")
                showError(message: "Failed to create profile. Please try again.")
            }
        }
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

