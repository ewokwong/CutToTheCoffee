//
//  OnboardingView.swift
//  Cut the Coffee
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
    @State private var resumeFileURL: URL?
    @State private var name: String = ""
    @State private var email: String = ""
    
    // Resume parsing state
    @State private var isParsingResume: Bool = false
    @State private var parsedResumeData: ResumeParsingService.ParsedResumeData?
    
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
        VStack(spacing: 20) {
            // PDF Upload Section
            VStack(spacing: 16) {
                if isParsingResume {
                    // Parsing state
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(AppTheme.coffeeBrown)
                        
                        Text("Analyzing your resume...")
                            .font(.system(size: 16, weight: .semibold))
                            .coffeePrimaryText()
                        
                        Text("This may take a few moments")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(40)
                    .coffeeCardStyle()
                } else if hasUploadedResume {
                    // Resume uploaded state
                    VStack(spacing: 12) {
                        Image(systemName: "doc.fill.badge.checkmark")
                            .font(.system(size: 40))
                            .foregroundColor(AppTheme.coffeeBrown)
                        
                        Text("Resume Uploaded")
                            .font(.system(size: 16, weight: .semibold))
                            .coffeePrimaryText()
                        
                        Text(resumeFileName)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        Button("Upload Different Resume") {
                            showingDocumentPicker = true
                        }
                        .buttonStyle(.coffeeSecondary)
                        .padding(.top, 8)
                    }
                    .padding(30)
                    .coffeeCardStyle()
                } else {
                    // No resume uploaded state
                    VStack(spacing: 12) {
                        Image(systemName: "doc.badge.arrow.up")
                            .font(.system(size: 40))
                            .foregroundColor(AppTheme.coffeeBrown)
                        
                        Text("Upload Your Resume")
                            .font(.system(size: 16, weight: .semibold))
                            .coffeePrimaryText()
                        
                        Text("We'll automatically fill in your information")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Choose PDF") {
                            showingDocumentPicker = true
                        }
                        .buttonStyle(.coffeePrimary)
                        .padding(.top, 8)
                    }
                    .padding(30)
                    .coffeeCardStyle()
                }
            }
            
            // Show form fields after upload or allow manual entry
            if hasUploadedResume || !degree.isEmpty || !yearGraduating.isEmpty {
                VStack(spacing: 16) {
                    Text("Review & Edit Your Information")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textSecondary)
                    
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
            
            // Option to skip resume upload
            if !hasUploadedResume && degree.isEmpty && yearGraduating.isEmpty {
                Button("Skip - Enter Manually") {
                    // Just set a flag to show the form fields
                    degree = ""
                    yearGraduating = ""
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
            }
        }
    }
    
    private var resumeUploadStep: some View {
        VStack(spacing: 20) {
            // Summary of extracted information
            if hasUploadedResume, let parsedData = parsedResumeData {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                        
                        Text("Information Extracted")
                            .font(.system(size: 18, weight: .semibold))
                            .coffeePrimaryText()
                        
                        Spacer()
                    }
                    
                    // Show extracted data summary
                    VStack(alignment: .leading, spacing: 12) {
                        if let name = parsedData.name {
                            InfoLabelValueRow(label: "Name", value: name)
                        }
                        
                        if let email = parsedData.email {
                            InfoLabelValueRow(label: "Email", value: email)
                        }
                        
                        if let degree = parsedData.degree {
                            InfoLabelValueRow(label: "Degree", value: degree)
                        }
                        
                        if let year = parsedData.graduationYear {
                            InfoLabelValueRow(label: "Graduation Year", value: String(year))
                        }
                        
                        if let skills = parsedData.skills, !skills.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Skills")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                FlowLayout(spacing: 8) {
                                    ForEach(skills.prefix(8), id: \.self) { skill in
                                        Text(skill)
                                            .font(.system(size: 12))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(AppTheme.latteBrown)
                                            .foregroundColor(AppTheme.coffeeBrown)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .coffeeCardStyle()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.coffeeBrown)
                    
                    Text("Review Your Information")
                        .font(.system(size: 18, weight: .semibold))
                        .coffeePrimaryText()
                    
                    Text("Your details have been extracted from your resume. You can make any changes in the previous or next steps.")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(40)
                .coffeeCardStyle()
            }
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
            return "Upload Your Resume"
        case 1:
            return "Review Your Details"
        case 2:
            return "Complete Your Profile"
        default:
            return ""
        }
    }
    
    private var stepDescription: String {
        switch currentStep {
        case 0:
            return "We'll automatically extract your information"
        case 1:
            return "Confirm or update the details we found"
        case 2:
            return "Add your LinkedIn and a brief bio"
        default:
            return ""
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            // Can proceed if they have uploaded a resume OR filled in the fields manually
            return (hasUploadedResume && !degree.isEmpty && !yearGraduating.isEmpty && Int(yearGraduating) != nil) ||
                   (!hasUploadedResume && !degree.isEmpty && !yearGraduating.isEmpty && Int(yearGraduating) != nil)
        case 1:
            // Step 1 is now for reviewing additional details
            return true
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
        resumeFileName = url.lastPathComponent
        resumeFileURL = url
        
        print("📄 Resume selected: \(resumeFileName)")
        
        // Start parsing the resume
        Task {
            await parseResume(url: url)
        }
    }
    
    /// Parse the uploaded resume and auto-fill form fields
    private func parseResume(url: URL) async {
        await MainActor.run {
            isParsingResume = true
        }
        
        do {
            // Parse resume with LLM
            let service = ResumeParsingService.shared
            let parsedData = try await service.parseResume(from: url)
            
            await MainActor.run {
                // Store parsed data
                self.parsedResumeData = parsedData
                
                // Auto-fill form fields
                if let degree = parsedData.degree {
                    self.degree = degree
                }
                
                if let year = parsedData.graduationYear {
                    self.yearGraduating = String(year)
                }
                
                if let linkedin = parsedData.linkedinURL {
                    self.linkedinURL = linkedin
                }
                
                if let bio = parsedData.bio {
                    self.bio = bio
                }
                
                if let name = parsedData.name {
                    self.name = name
                }
                
                if let email = parsedData.email {
                    self.email = email
                }
                
                // Mark as uploaded and stop parsing
                self.hasUploadedResume = true
                self.isParsingResume = false
                
                print("✅ Resume parsed and fields auto-filled:")
                print("   Degree: \(self.degree)")
                print("   Year: \(self.yearGraduating)")
                print("   LinkedIn: \(self.linkedinURL)")
                print("   Bio: \(self.bio)")
            }
        } catch {
            await MainActor.run {
                self.isParsingResume = false
                self.hasUploadedResume = false
                
                // Show error to user
                let errorMsg = (error as? ResumeParsingService.ResumeParsingError)?.errorDescription 
                    ?? "Failed to parse resume. Please try again or enter information manually."
                showError(message: errorMsg)
                
                print("❌ Error parsing resume: \(error.localizedDescription)")
            }
        }
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
                guard let appleUserId = authManager.currentUserId else {
                    showError(message: "Missing user information. Please sign in again.")
                    return
                }
                
                // Use parsed name/email if available, otherwise fall back to auth manager
                let studentName = !name.isEmpty ? name : (authManager.userFullName ?? "")
                let studentEmail = !email.isEmpty ? email : (authManager.userEmail ?? "")
                
                guard !studentName.isEmpty, !studentEmail.isEmpty else {
                    showError(message: "Missing name or email. Please sign in again.")
                    return
                }
                
                // Upload resume to Firebase Storage
                var resumeDownloadURL: String? = nil
                if let resumeFileURL = resumeFileURL {
                    print("📤 Uploading resume to Firebase Storage...")
                    let storageService = FirebaseStorageService.shared
                    resumeDownloadURL = try await storageService.uploadResume(fileURL: resumeFileURL, userId: appleUserId)
                }
                
                // TODO: Get actual university ID (for now using a placeholder)
                // You'll need to implement university selection in onboarding
                let placeholderUniversityId = UUID()
                
                // Create student profile
                let student = Student(
                    name: studentName,
                    email: studentEmail,
                    linkedinURL: linkedinURL,
                    universityID: placeholderUniversityId,
                    appleUserId: appleUserId,
                    resumeURL: resumeDownloadURL,
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
                print("   Name: \(studentName)")
                print("   Email: \(studentEmail)")
                print("   Degree: \(degree)")
                print("   Graduation Year: \(graduationYear)")
                print("   LinkedIn: \(linkedinURL)")
                print("   Bio: \(bio)")
                if let resumeURL = resumeDownloadURL {
                    print("   Resume URL: \(resumeURL)")
                }
                
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

// MARK: - Helper Views

struct InfoLabelValueRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(AppTheme.textSecondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.coffeeBrown)
            
            Spacer()
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: result.positions[index], proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    OnboardingView()
}

