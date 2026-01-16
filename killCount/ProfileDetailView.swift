//
//  Profiledetailview.swift
//  killCount
//
//  Created by Benjamin Lavallee on 2026-01-16.
//

import SwiftUI

struct ProfileDetailView: View {
    let user: User
    @Environment(\.dismiss) var dismiss
    @State private var currentImageIndex = 0
    
    var body: some View {
        ZStack {
            Color.kcBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header Image Area
                    ZStack(alignment: .top) {
                        // Placeholder image
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.25, green: 0.25, blue: 0.3), Color(red: 0.15, green: 0.15, blue: 0.2)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 450)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 150))
                            .foregroundColor(.gray.opacity(0.2))
                            .offset(y: 120)
                        
                        // Top controls
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.down")
                                    .font(.title2.weight(.semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Button { } label: {
                                Image(systemName: "ellipsis")
                                    .font(.title2.weight(.semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 60)
                        
                        // Bottom gradient
                        VStack {
                            Spacer()
                            LinearGradient(
                                colors: [.clear, Color.kcBackground],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 100)
                        }
                        .frame(height: 450)
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 24) {
                        // Name, Age, Verification
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .bottom, spacing: 8) {
                                    Text(user.name)
                                        .font(.system(size: 34, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("\(user.age)")
                                        .font(.system(size: 26, weight: .regular))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                VerificationBadge(status: user.verificationStatus)
                            }
                            
                            Spacer()
                        }
                        
                        // KILL COUNT - Main Feature Section
                        KillCountCard(count: user.killCount)
                        
                        // Bio
                        VStack(alignment: .leading, spacing: 8) {
                            SectionHeader(title: "About")
                            Text(user.bio)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.85))
                        }
                        
                        // Relationship History
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Relationship History")
                            
                            InfoRow(icon: "clock.fill", label: "Longest Relationship", value: user.relationshipHistory.longestRelationship)
                            InfoRow(icon: "magnifyingglass", label: "Looking For", value: user.relationshipHistory.lookingFor)
                        }
                        
                        // Values
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Values")
                            
                            FlowLayout(spacing: 8) {
                                ForEach(user.relationshipHistory.values, id: \.self) { value in
                                    TagPill(text: value, color: .kcRed)
                                }
                            }
                        }
                        
                        // Dealbreakers
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Dealbreakers")
                            
                            FlowLayout(spacing: 8) {
                                ForEach(user.relationshipHistory.dealbreakers, id: \.self) { dealbreaker in
                                    TagPill(text: dealbreaker, color: .gray)
                                }
                            }
                        }
                        
                        // Joined date
                        HStack {
                            Spacer()
                            Text("Joined \(user.joinDate.formatted(.dateTime.month().year()))")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // Bottom Action Bar
            VStack {
                Spacer()
                
                HStack(spacing: 20) {
                    ActionButton(icon: "xmark", color: .gray, size: .large) { }
                    ActionButton(icon: "star.fill", color: .yellow, size: .medium) { }
                    ActionButton(icon: "heart.fill", color: .kcRed, size: .large) { }
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [Color.kcBackground.opacity(0), Color.kcBackground],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
            }
        }
    }
}

// MARK: - Kill Count Card
struct KillCountCard: View {
    let count: Int
    
    var color: Color {
        switch count {
        case 0...3: return .green
        case 4...7: return .yellow
        case 8...15: return .orange
        default: return .red
        }
    }
    
    var label: String {
        switch count {
        case 0...3: return "Low"
        case 4...7: return "Moderate"
        case 8...15: return "High"
        default: return "Very High"
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "target")
                    .font(.title2.weight(.bold))
                    .foregroundColor(color)
                
                Text("Kill Count")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .cornerRadius(8)
            }
            
            // Big number display
            HStack(alignment: .bottom, spacing: 4) {
                Text("\(count)")
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundColor(color)
                
                Text("previous partners")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 16)
            }
            
            // Meter
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 12)
                    
                    // Filled portion
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [.green, .yellow, .orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: min(CGFloat(count) / 20 * geo.size.width, geo.size.width), height: 12)
                }
            }
            .frame(height: 12)
            
            // Scale labels
            HStack {
                Text("0")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                Text("20+")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
        .background(Color.kcCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.kcRed)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.white)
        }
        .padding(12)
        .background(Color.kcCardBackground)
        .cornerRadius(10)
    }
}

// MARK: - Tag Pill
struct TagPill: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(color.opacity(0.3))
            .cornerRadius(20)
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }
    
    private func computeLayout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        let maxContainerWidth = proposal.width ?? .infinity
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxContainerWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxWidth = max(maxWidth, currentX)
        }
        
        return (CGSize(width: maxWidth, height: currentY + lineHeight), positions)
    }
}

#Preview {
    ProfileDetailView(user: User.sampleUsers[0])
}
