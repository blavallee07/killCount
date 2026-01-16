//
//  MatchesView.swift
//  killCount
//
//  Created by Benjamin Lavallee on 2026-01-16.
//

import SwiftUI

struct MatchesView: View {
    @State private var matches: [User] = Array(User.sampleUsers.prefix(3))
    @State private var selectedUser: User?
    @State private var showingProfile = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.kcBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // New Matches Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("New Matches")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(matches) { user in
                                        NewMatchCard(user: user) {
                                            selectedUser = user
                                            showingProfile = true
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Likes You Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Likes You")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("12 people")
                                    .font(.subheadline)
                                    .foregroundColor(.kcRed)
                            }
                            .padding(.horizontal)
                            
                            // Blurred preview grid
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(0..<4) { _ in
                                    BlurredLikeCard()
                                }
                            }
                            .padding(.horizontal)
                            
                            // Upgrade prompt
                            Button {
                                // Upgrade action
                            } label: {
                                HStack {
                                    Image(systemName: "star.fill")
                                    Text("Upgrade to see who likes you")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color.kcRed, Color.kcDarkRed],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingProfile) {
                if let user = selectedUser {
                    ProfileDetailView(user: user)
                }
            }
        }
    }
}

// MARK: - New Match Card
struct NewMatchCard: View {
    let user: User
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.kcRed, Color.kcDarkRed],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 84, height: 84)
                    
                    Circle()
                        .fill(Color.kcCardBackground)
                        .frame(width: 76, height: 76)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.gray.opacity(0.5))
                }
                
                Text(user.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
                
                // Kill Count mini badge
                HStack(spacing: 4) {
                    Image(systemName: "target")
                        .font(.caption2)
                    Text("\(user.killCount)")
                        .font(.caption.weight(.bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(killCountColor(user.killCount).opacity(0.8))
                .cornerRadius(8)
            }
        }
    }
    
    private func killCountColor(_ count: Int) -> Color {
        switch count {
        case 0...3: return .green
        case 4...7: return .yellow
        case 8...15: return .orange
        default: return .red
        }
    }
}

// MARK: - Blurred Like Card
struct BlurredLikeCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.kcCardBackground)
                .aspectRatio(0.75, contentMode: .fit)
            
            Image(systemName: "person.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.3))
            
            // Blur overlay
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
            
            // Lock icon
            VStack(spacing: 8) {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.7))
                
                Text("Premium")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}

#Preview {
    MatchesView()
}
