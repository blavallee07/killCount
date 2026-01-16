//
//  Discoverview.swift
//  killCount
//
//  Created by Benjamin Lavallee on 2026-01-16.
//

import SwiftUI

struct DiscoverView: View {
    @State private var users = User.sampleUsers
    @State private var currentIndex = 0
    @State private var offset = CGSize.zero
    @State private var showingProfile = false
    @State private var selectedUser: User?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.kcBackground.ignoresSafeArea()
                
                VStack {
                    if currentIndex < users.count {
                        // Card Stack
                        ZStack {
                            ForEach(Array(users.enumerated()), id: \.element.id) { index, user in
                                if index >= currentIndex && index < currentIndex + 3 {
                                    ProfileCard(
                                        user: user,
                                        isTop: index == currentIndex,
                                        onTap: {
                                            selectedUser = user
                                            showingProfile = true
                                        }
                                    )
                                    .offset(index == currentIndex ? offset : .zero)
                                    .scaleEffect(index == currentIndex ? 1 : 1 - CGFloat(index - currentIndex) * 0.05)
                                    .offset(y: CGFloat(index - currentIndex) * 8)
                                    .rotationEffect(.degrees(index == currentIndex ? Double(offset.width / 20) : 0))
                                    .gesture(
                                        index == currentIndex ?
                                        DragGesture()
                                            .onChanged { gesture in
                                                offset = gesture.translation
                                            }
                                            .onEnded { _ in
                                                withAnimation(.spring(response: 0.4)) {
                                                    if abs(offset.width) > 150 {
                                                        offset.width = offset.width > 0 ? 500 : -500
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                            currentIndex += 1
                                                            offset = .zero
                                                        }
                                                    } else {
                                                        offset = .zero
                                                    }
                                                }
                                            }
                                        : nil
                                    )
                                }
                            }
                            
                            // Swipe indicators
                            if offset.width > 50 {
                                likeIndicator
                            } else if offset.width < -50 {
                                nopeIndicator
                            }
                        }
                        .padding(.horizontal)
                        
                        // Action Buttons
                        HStack(spacing: 20) {
                            ActionButton(icon: "xmark", color: .gray, size: .large) {
                                swipeLeft()
                            }
                            
                            ActionButton(icon: "star.fill", color: .yellow, size: .medium) {
                                // Super like
                            }
                            
                            ActionButton(icon: "heart.fill", color: .kcRed, size: .large) {
                                swipeRight()
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        
                    } else {
                        emptyStateView
                    }
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                            Circle()
                                .fill(Color.kcRed)
                                .frame(width: 8, height: 8)
                                .offset(x: 2, y: -2)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                if let user = selectedUser {
                    ProfileDetailView(user: user)
                }
            }
        }
    }
    
    private var likeIndicator: some View {
        Text("LIKE")
            .font(.system(size: 40, weight: .black))
            .foregroundColor(.green)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green, lineWidth: 4)
            )
            .rotationEffect(.degrees(-20))
            .offset(x: -100, y: -200)
    }
    
    private var nopeIndicator: some View {
        Text("NOPE")
            .font(.system(size: 40, weight: .black))
            .foregroundColor(.red)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 4)
            )
            .rotationEffect(.degrees(20))
            .offset(x: 100, y: -200)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No more profiles")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
            
            Text("Check back later for new people")
                .foregroundColor(.gray)
            
            Button {
                withAnimation {
                    currentIndex = 0
                }
            } label: {
                Text("Start Over")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.kcRed)
                    .cornerRadius(25)
            }
            .padding(.top)
        }
    }
    
    private func swipeLeft() {
        withAnimation(.spring(response: 0.4)) {
            offset.width = -500
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentIndex += 1
            offset = .zero
        }
    }
    
    private func swipeRight() {
        withAnimation(.spring(response: 0.4)) {
            offset.width = 500
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentIndex += 1
            offset = .zero
        }
    }
}

// MARK: - Profile Card
struct ProfileCard: View {
    let user: User
    let isTop: Bool
    let onTap: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // Card background with gradient
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.25, green: 0.25, blue: 0.3), Color(red: 0.15, green: 0.15, blue: 0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Placeholder image
                Image(systemName: "person.fill")
                    .font(.system(size: 140))
                    .foregroundColor(.gray.opacity(0.2))
                    .offset(y: -80)
                
                // Bottom gradient overlay
                LinearGradient(
                    colors: [.clear, .clear, .black.opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(20)
                
                // Info overlay
                VStack(alignment: .leading, spacing: 12) {
                    // Top badges
                    HStack {
                        Spacer()
                        VerificationBadge(status: user.verificationStatus)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    // Bottom info
                    VStack(alignment: .leading, spacing: 12) {
                        // Name and age
                        HStack(alignment: .bottom, spacing: 8) {
                            Text(user.name)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(user.age)")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        // Kill Count badge - THE MAIN FEATURE
                        KillCountBadge(count: user.killCount)
                        
                        // Bio
                        Text(user.bio)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)
                        
                        // Quick stats
                        HStack(spacing: 16) {
                            QuickStat(icon: "clock.fill", text: user.relationshipHistory.longestRelationship)
                            QuickStat(icon: "heart.fill", text: user.relationshipHistory.lookingFor)
                        }
                        
                        // Tap for more
                        HStack {
                            Spacer()
                            Text("Tap for more info")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                            Image(systemName: "chevron.up")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                }
            }
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
            .onTapGesture {
                onTap()
            }
        }
        .aspectRatio(0.7, contentMode: .fit)
    }
}

// MARK: - Kill Count Badge
struct KillCountBadge: View {
    let count: Int
    
    var badgeColor: Color {
        switch count {
        case 0...3: return .green
        case 4...7: return .yellow
        case 8...15: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "target")
                .font(.system(size: 16, weight: .bold))
            
            Text("Kill Count:")
                .font(.system(size: 14, weight: .medium))
            
            Text("\(count)")
                .font(.system(size: 18, weight: .black))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(badgeColor.opacity(0.9))
        )
        .overlay(
            Capsule()
                .stroke(badgeColor, lineWidth: 2)
        )
    }
}

// MARK: - Quick Stat
struct QuickStat: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.kcRed)
            Text(text)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

// MARK: - Verification Badge
struct VerificationBadge: View {
    let status: User.VerificationStatus
    
    var color: Color {
        switch status {
        case .unverified: return .gray
        case .phoneVerified: return .blue
        case .idVerified: return .green
        }
    }
    
    var icon: String {
        switch status {
        case .unverified: return "questionmark.circle.fill"
        case .phoneVerified: return "phone.circle.fill"
        case .idVerified: return "checkmark.seal.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            Text(status.rawValue)
                .font(.caption.weight(.medium))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.8))
        .cornerRadius(12)
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let icon: String
    let color: Color
    var size: ButtonSize = .large
    let action: () -> Void
    
    enum ButtonSize {
        case small, medium, large
        
        var dimension: CGFloat {
            switch self {
            case .small: return 44
            case .medium: return 54
            case .large: return 64
            }
        }
        
        var iconSize: Font {
            switch self {
            case .small: return .body
            case .medium: return .title3
            case .large: return .title2
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(size.iconSize.weight(.bold))
                .foregroundColor(color)
                .frame(width: size.dimension, height: size.dimension)
                .background(Color.kcCardBackground)
                .clipShape(Circle())
                .shadow(color: color.opacity(0.3), radius: 8)
        }
    }
}

#Preview {
    DiscoverView()
}
