//
//  ReferrerHomeView.swift
//  Cut to the Coffee
//
//  Home page for referrers (placeholder)
//

import SwiftUI

struct ReferrerHomeView: View {
    @State private var selectedTab = 0
    @State private var selectedStudent: Int? = nil
    
    var body: some View {
        ZStack {
            // Light background
            AppTheme.lightGradient
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Pending Requests Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pending Requests")
                                .font(.system(size: 20, weight: .semibold))
                                .coffeePrimaryText()
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(0..<5) { index in
                                    ReferrerRequestCard(
                                        studentName: "Student \(index + 1)",
                                        university: "University",
                                        degree: "Computer Science",
                                        role: index == 0 ? "Software Engineering Grad Program" : "Product Manager Internship"
                                    ) {
                                        selectedStudent = index
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedStudent.map { StudentModalData(id: $0) } },
            set: { selectedStudent = $0?.id }
        )) { student in
            StudentProfileModal(
                studentName: "Student \(student.id + 1)",
                university: "University",
                degree: "Computer Science",
                role: student.id == 0 ? "Software Engineering Grad Program" : "Product Manager Internship",
                resumeURL: "https://example.com/resume.pdf",
                onReject: {
                    // Handle reject
                    selectedStudent = nil
                },
                onRefer: {
                    // Handle refer
                    selectedStudent = nil
                }
            )
        }
    }
}

// Helper struct for sheet binding
struct StudentModalData: Identifiable {
    let id: Int
}

// MARK: - Referrer Stat Card

struct ReferrerStatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .coffeePrimaryText()
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppTheme.creamWhite)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Referrer Request Card

struct ReferrerRequestCard: View {
    let studentName: String
    let university: String
    let degree: String
    let role: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    // Profile Picture
                    Circle()
                        .fill(AppTheme.latteBrown)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppTheme.coffeeBrown)
                        )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(studentName)
                            .font(.system(size: 17, weight: .semibold))
                            .coffeePrimaryText()
                        
                        HStack(spacing: 6) {
                            Image(systemName: "building.columns")
                                .font(.system(size: 12))
                            Text(university)
                                .font(.system(size: 14))
                        }
                        .foregroundColor(AppTheme.textSecondary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "graduationcap")
                                .font(.system(size: 12))
                            Text(degree)
                                .font(.system(size: 14))
                        }
                        .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                // Role Tag
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "briefcase.fill")
                            .font(.system(size: 11))
                        Text(role)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(AppTheme.coffeeBrown)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.latteBrown)
                    .cornerRadius(8)
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(AppTheme.creamWhite)
            .cornerRadius(16)
            .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Student Profile Modal

struct StudentProfileModal: View {
    @Environment(\.dismiss) var dismiss
    let studentName: String
    let university: String
    let degree: String
    let role: String
    let resumeURL: String
    let onReject: () -> Void
    let onRefer: () -> Void
    
    @State private var showRejectSheet = false
    @State private var showMoreInfoSheet = false
    @State private var showReferSheet = false
    @State private var feedbackText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.lightGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Profile Picture
                            Circle()
                                .fill(AppTheme.latteBrown)
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(AppTheme.coffeeBrown)
                                )
                                .padding(.top, 20)
                            
                            // Student Info
                            VStack(spacing: 12) {
                                Text(studentName)
                                    .font(.system(size: 28, weight: .bold))
                                    .coffeePrimaryText()
                                
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "building.columns")
                                            .font(.system(size: 16))
                                        Text(university)
                                            .font(.system(size: 16))
                                    }
                                    .foregroundColor(AppTheme.textSecondary)
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "graduationcap")
                                            .font(.system(size: 16))
                                        Text(degree)
                                            .font(.system(size: 16))
                                    }
                                    .foregroundColor(AppTheme.textSecondary)
                                }
                                
                                // Role Tag
                                HStack(spacing: 6) {
                                    Image(systemName: "briefcase.fill")
                                        .font(.system(size: 13))
                                    Text(role)
                                        .font(.system(size: 15, weight: .medium))
                                }
                                .foregroundColor(AppTheme.coffeeBrown)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(AppTheme.latteBrown)
                                .cornerRadius(10)
                            }
                            
                            // Resume Link Section
                            Link(destination: URL(string: resumeURL)!) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Resume")
                                            .font(.system(size: 18, weight: .semibold))
                                            .coffeePrimaryText()
                                        
                                        Text("Tap to view student's resume")
                                            .font(.system(size: 14))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.right.square.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(AppTheme.coffeeBrown)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(AppTheme.creamWhite)
                                .cornerRadius(16)
                                .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    
                    // Action Buttons (Fixed at bottom)
                    VStack(spacing: 0) {
                        Divider()
                            .background(AppTheme.textSecondary.opacity(0.2))
                        
                        HStack(spacing: 8) {
                            Button(action: {
                                showRejectSheet = true
                            }) {
                                Text("Reject")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(AppTheme.coffeeBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(AppTheme.latteBrown)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                showMoreInfoSheet = true
                            }) {
                                Text("More Info")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(AppTheme.coffeeBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppTheme.coffeeBrown, lineWidth: 1.5)
                                    )
                            }
                            
                            Button(action: {
                                showReferSheet = true
                            }) {
                                Text("Refer")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(AppTheme.coffeeBrown)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(AppTheme.creamWhite)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
        }
        .sheet(isPresented: $showRejectSheet) {
            RejectFeedbackSheet(
                studentName: studentName,
                feedbackText: $feedbackText,
                onSubmit: {
                    onReject()
                    showRejectSheet = false
                    dismiss()
                }
            )
        }
        .sheet(isPresented: $showMoreInfoSheet) {
            MoreInfoSheet(
                studentName: studentName,
                linkedInURL: "https://linkedin.com/in/student"
            )
        }
        .sheet(isPresented: $showReferSheet) {
            ReferConfirmationSheet(
                studentName: studentName,
                role: role,
                onConfirm: {
                    onRefer()
                    showReferSheet = false
                    dismiss()
                }
            )
        }
    }
}

// MARK: - Reject Feedback Sheet

struct RejectFeedbackSheet: View {
    @Environment(\.dismiss) var dismiss
    let studentName: String
    @Binding var feedbackText: String
    let onSubmit: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.lightGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Icon
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 60))
                            .foregroundColor(AppTheme.coffeeBrown)
                            .padding(.top, 30)
                        
                        // Title
                        Text("Help \(studentName) Improve")
                            .font(.system(size: 24, weight: .bold))
                            .coffeePrimaryText()
                            .multilineTextAlignment(.center)
                        
                        Text("Your feedback will help them prepare better for their next referral opportunity")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        // Feedback Text Editor
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Feedback (Optional)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextEditor(text: $feedbackText)
                                .frame(height: 150)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.textSecondary.opacity(0.3), lineWidth: 1)
                                )
                                .overlay(
                                    Group {
                                        if feedbackText.isEmpty {
                                            Text("Share constructive feedback to help them improve...")
                                                .font(.system(size: 15))
                                                .foregroundColor(AppTheme.textSecondary.opacity(0.5))
                                                .padding(.top, 20)
                                                .padding(.leading, 16)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        }
                                    }
                                )
                        }
                        .padding(.horizontal, 20)
                        
                        // Submit Button
                        Button(action: onSubmit) {
                            Text("Submit Feedback")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppTheme.coffeeBrown)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.coffeeBrown)
                }
            }
        }
    }
}

// MARK: - More Info Sheet

struct MoreInfoSheet: View {
    @Environment(\.dismiss) var dismiss
    let studentName: String
    let linkedInURL: String
    @State private var showShareLinkedIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.lightGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Icon
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 60))
                            .foregroundColor(AppTheme.coffeeBrown)
                            .padding(.top, 30)
                        
                        // Title
                        Text("Connect with \(studentName)")
                            .font(.system(size: 24, weight: .bold))
                            .coffeePrimaryText()
                            .multilineTextAlignment(.center)
                        
                        // LinkedIn Button
                        Link(destination: URL(string: linkedInURL)!) {
                            HStack {
                                Image(systemName: "link.circle.fill")
                                    .font(.system(size: 24))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("View LinkedIn Profile")
                                        .font(.system(size: 17, weight: .semibold))
                                    Text("Learn more about their experience")
                                        .font(.system(size: 14))
                                        .opacity(0.8)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(20)
                            .background(AppTheme.coffeeBrown)
                            .cornerRadius(16)
                            .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(AppTheme.textSecondary.opacity(0.3))
                                .frame(height: 1)
                            Text("OR")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.textSecondary)
                                .padding(.horizontal, 12)
                            Rectangle()
                                .fill(AppTheme.textSecondary.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 40)
                        
                        // Share LinkedIn
                        VStack(spacing: 16) {
                            Text("Would you like to share your LinkedIn so \(studentName) can connect?")
                                .font(.system(size: 16, weight: .medium))
                                .coffeePrimaryText()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            Button(action: {
                                showShareLinkedIn = true
                            }) {
                                HStack {
                                    Image(systemName: "person.badge.plus")
                                        .font(.system(size: 20))
                                    Text("Share My LinkedIn")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(AppTheme.coffeeBrown)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppTheme.latteBrown)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.coffeeBrown)
                }
            }
        }
        .alert("Share LinkedIn", isPresented: $showShareLinkedIn) {
            Button("Cancel", role: .cancel) { }
            Button("Share") {
                // Handle sharing LinkedIn
            }
        } message: {
            Text("This will share your LinkedIn profile with \(studentName) so they can connect with you.")
        }
    }
}

// MARK: - Refer Confirmation Sheet

struct ReferConfirmationSheet: View {
    @Environment(\.dismiss) var dismiss
    let studentName: String
    let role: String
    let onConfirm: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.lightGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Icon
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.system(size: 70))
                                .foregroundColor(AppTheme.coffeeBrown)
                                .padding(.top, 40)
                            
                            // Title
                            Text("Please Refer \(studentName)")
                                .font(.system(size: 26, weight: .bold))
                                .coffeePrimaryText()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            // Message
                            VStack(spacing: 16) {
                                Text("Our student is relying on you! 🙏")
                                    .font(.system(size: 18, weight: .semibold))
                                    .coffeePrimaryText()
                                    .multilineTextAlignment(.center)
                                
                                Text("By referring them for the \(role), you're helping them take the next step in their career journey.")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 30)
                            
                            // Info Card
                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppTheme.coffeeBrown)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("What happens next?")
                                            .font(.system(size: 16, weight: .semibold))
                                            .coffeePrimaryText()
                                        Text("Submit their referral through your company's portal")
                                            .font(.system(size: 14))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    Spacer()
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppTheme.coffeeBrown)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Stay Updated")
                                            .font(.system(size: 16, weight: .semibold))
                                            .coffeePrimaryText()
                                        Text("We'll notify you of any updates")
                                            .font(.system(size: 14))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(20)
                            .background(AppTheme.creamWhite)
                            .cornerRadius(16)
                            .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    
                    // Confirm Button (Fixed at bottom)
                    VStack(spacing: 0) {
                        Divider()
                            .background(AppTheme.textSecondary.opacity(0.2))
                        
                        Button(action: onConfirm) {
                            Text("Confirm Referral")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppTheme.coffeeBrown)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(AppTheme.creamWhite)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.coffeeBrown)
                }
            }
        }
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button {
            // Action
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
            }
            .foregroundColor(color)
            .padding(16)
            .background(AppTheme.creamWhite)
            .cornerRadius(12)
            .shadow(color: AppTheme.shadow, radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    ReferrerHomeView()
}

