//
//  ProfileView.swift
//  killCount
//
//  Created by Benjamin Lavallee on 2026-01-16.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    // Mock current user data
    @State private var currentUser = User(
        id: UUID(),
        name: "Alex",
        age: 25,
        bio: "Software dev by day, amateur chef by night 👨‍🍳",
        profileImageName: "person.circle.fill",
        killCount: 6,
        relationshipHistory: RelationshipHistory(
            longestRelationship: "2.5 years",
            lookingFor: "Long-term relationship",
            dealbreakers: ["Dishonesty", "No sense of humor"],
            values: ["Ambition", "Kindness", "Adventure"]
        ),
        verificationStatus: .phoneVerified,
        joinDate: Date().addingTimeInterval(-86400 * 180)
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.kcBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.kcRed, Color.kcDarkRed],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 124, height: 124)
                                
                                Circle()
                                    .fill(Color.kcCardBackground)
                                    .frame(width: 116, height: 116)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                // Edit button
                                Button {
                                    showingEditProfile = true
                                } label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.kcRed)
                                        .background(Circle().fill(Color.white))
                                }
                                .offset(x: 44, y: 44)
                            }
                            
                            // Name and verification
                            VStack(spacing: 4) {
                                HStack(spacing: 8) {
                                    Text("\(currentUser.name), \(currentUser.age)")
                                        .font(.title.weight(.bold))
                                        .foregroundColor(.white)
                                }
                                
                                VerificationBadge(status: currentUser.verificationStatus)
                            }
                        }
                        .padding(.top)
                        
                        // Your Kill Count Card
                        YourKillCountCard(count: currentUser.killCount)
                            .padding(.horizontal)
                        
                        // Profile Completion
                        ProfileCompletionCard(completion: 75)
                            .padding(.horizontal)
                        
                        // Quick Actions
                        VStack(spacing: 12) {
                            ProfileActionRow(icon: "pencil", title: "Edit Profile") {
                                showingEditProfile = true
                            }
                            
                            ProfileActionRow(icon: "photo.stack", title: "Manage Photos") { }
                            
                            ProfileActionRow(icon: "checkmark.shield", title: "Verify Your Profile") { }
                            
                            ProfileActionRow(icon: "slider.horizontal.3", title: "Dating Preferences") { }
                        }
                        .padding(.horizontal)
                        
                        // Settings Section
                        VStack(spacing: 12) {
                            Text("Settings")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            ProfileActionRow(icon: "bell", title: "Notifications") { }
                            ProfileActionRow(icon: "lock.shield", title: "Privacy") { }
                            ProfileActionRow(icon: "questionmark.circle", title: "Help & Support") { }
                            
                            ProfileActionRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", isDestructive: true) {
                                withAnimation {
                                    authManager.isAuthenticated = false
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // App version
                        Text("KillCount v1.0.0")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: $currentUser)
            }
        }
    }
}

// MARK: - Your Kill Count Card
struct YourKillCountCard: View {
    let count: Int
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "target")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.kcRed)
                
                Text("Your Kill Count")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    isEditing = true
                } label: {
                    Text("Edit")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.kcRed)
                }
            }
            
            HStack {
                Text("\(count)")
                    .font(.system(size: 56, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Visible to matches")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Toggle("", isOn: .constant(true))
                        .labelsHidden()
                        .tint(.kcRed)
                }
            }
            
            Text("Be honest - verified users can report inaccurate counts")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(Color.kcCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Profile Completion Card
struct ProfileCompletionCard: View {
    let completion: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Profile Completion")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(completion)%")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.kcRed)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.kcRed)
                        .frame(width: geo.size.width * CGFloat(completion) / 100, height: 8)
                }
            }
            .frame(height: 8)
            
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
                
                Text("Add more photos to get 3x more matches")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.kcCardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Profile Action Row
struct ProfileActionRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(isDestructive ? .red : .kcRed)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(isDestructive ? .red : .white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.kcCardBackground)
            .cornerRadius(12)
        }
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var bio: String = ""
    @State private var killCount: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.kcBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Photo section
                        VStack(spacing: 12) {
                            Text("Photos")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                // Main photo
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.kcCardBackground)
                                        .aspectRatio(0.75, contentMode: .fit)
                                    
                                    Image(systemName: "person.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                                
                                // Add photo placeholders
                                ForEach(0..<5) { _ in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8]))
                                            .aspectRatio(0.75, contentMode: .fit)
                                        
                                        Image(systemName: "plus")
                                            .font(.title2)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Basic Info
                        VStack(spacing: 16) {
                            Text("Basic Info")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            EditField(label: "Name", text: $name)
                            EditField(label: "Bio", text: $bio, isMultiline: true)
                            
                            // Kill Count stepper
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Kill Count")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Button {
                                        if killCount > 0 { killCount -= 1 }
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.kcRed)
                                    }
                                    
                                    Text("\(killCount)")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(width: 80)
                                    
                                    Button {
                                        killCount += 1
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.kcRed)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.kcCardBackground)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        user.name = name
                        user.bio = bio
                        user.killCount = killCount
                        dismiss()
                    }
                    .foregroundColor(.kcRed)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                name = user.name
                bio = user.bio
                killCount = user.killCount
            }
        }
    }
}

// MARK: - Edit Field
struct EditField: View {
    let label: String
    @Binding var text: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if isMultiline {
                TextEditor(text: $text)
                    .frame(height: 100)
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(Color.kcCardBackground)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            } else {
                TextField("", text: $text)
                    .padding(16)
                    .background(Color.kcCardBackground)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
