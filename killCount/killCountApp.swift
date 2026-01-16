//
//  killCountApp.swift
//  killCount
//
//  Created by Benjamin Lavallee on 2026-01-15.
//

import SwiftUI

@main
struct KillCountApp: App {
    @StateObject private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Auth Manager
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
}

// MARK: - Models
struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var age: Int
    var bio: String
    var profileImageName: String
    var killCount: Int
    var relationshipHistory: RelationshipHistory
    var verificationStatus: VerificationStatus
    var joinDate: Date
    
    enum VerificationStatus: String, Codable, CaseIterable {
        case unverified = "Unverified"
        case phoneVerified = "Phone Verified"
        case idVerified = "ID Verified"
    }
}

struct RelationshipHistory: Codable {
    var longestRelationship: String
    var lookingFor: String
    var dealbreakers: [String]
    var values: [String]
}

// MARK: - Sample Data
extension User {
    static let sampleUsers: [User] = [
        User(
            id: UUID(),
            name: "Sarah",
            age: 24,
            bio: "Coffee enthusiast ☕ Dog mom 🐕 Looking for something real.",
            profileImageName: "person.circle.fill",
            killCount: 3,
            relationshipHistory: RelationshipHistory(
                longestRelationship: "2 years",
                lookingFor: "Long-term relationship",
                dealbreakers: ["Smoking", "No ambition"],
                values: ["Honesty", "Family", "Adventure"]
            ),
            verificationStatus: .idVerified,
            joinDate: Date().addingTimeInterval(-86400 * 30)
        ),
        User(
            id: UUID(),
            name: "Emma",
            age: 26,
            bio: "Nurse by day, foodie by night 🍕 Let's grab tacos.",
            profileImageName: "person.circle.fill",
            killCount: 8,
            relationshipHistory: RelationshipHistory(
                longestRelationship: "3 years",
                lookingFor: "Serious relationship",
                dealbreakers: ["Dishonesty", "Poor communication"],
                values: ["Trust", "Growth", "Humor"]
            ),
            verificationStatus: .phoneVerified,
            joinDate: Date().addingTimeInterval(-86400 * 60)
        ),
        User(
            id: UUID(),
            name: "Jessica",
            age: 23,
            bio: "Grad student 📚 Yoga lover 🧘‍♀️ Book recs welcome.",
            profileImageName: "person.circle.fill",
            killCount: 2,
            relationshipHistory: RelationshipHistory(
                longestRelationship: "1.5 years",
                lookingFor: "Taking it slow",
                dealbreakers: ["Rudeness", "Closed-minded"],
                values: ["Intelligence", "Kindness", "Curiosity"]
            ),
            verificationStatus: .unverified,
            joinDate: Date().addingTimeInterval(-86400 * 10)
        ),
        User(
            id: UUID(),
            name: "Ashley",
            age: 25,
            bio: "Marketing @ tech startup 💼 Weekend hiker 🏔️",
            profileImageName: "person.circle.fill",
            killCount: 12,
            relationshipHistory: RelationshipHistory(
                longestRelationship: "4 years",
                lookingFor: "Something serious",
                dealbreakers: ["Jealousy", "Laziness"],
                values: ["Ambition", "Loyalty", "Fun"]
            ),
            verificationStatus: .idVerified,
            joinDate: Date().addingTimeInterval(-86400 * 90)
        ),
        User(
            id: UUID(),
            name: "Mia",
            age: 22,
            bio: "Just moved here! Show me around? 🗺️",
            profileImageName: "person.circle.fill",
            killCount: 5,
            relationshipHistory: RelationshipHistory(
                longestRelationship: "1 year",
                lookingFor: "Open to anything",
                dealbreakers: ["Ghosting"],
                values: ["Spontaneity", "Communication"]
            ),
            verificationStatus: .phoneVerified,
            joinDate: Date().addingTimeInterval(-86400 * 5)
        )
    ]
}

// MARK: - Color Theme
extension Color {
    static let kcRed = Color(red: 0.9, green: 0.1, blue: 0.15)
    static let kcDarkRed = Color(red: 0.6, green: 0.0, blue: 0.05)
    static let kcBackground = Color(red: 0.08, green: 0.08, blue: 0.1)
    static let kcCardBackground = Color(red: 0.12, green: 0.12, blue: 0.15)
}
