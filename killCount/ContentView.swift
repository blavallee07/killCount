//
//  ContentView.swift
//  killCount
//
//  Created by Benjamin Lavallee on 2026-01-15.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var selectedTab = 0
    
    var body: some View {
        if authManager.isAuthenticated {
            MainTabView(selectedTab: $selectedTab)
        } else {
            OnboardingView()
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        
        // Custom tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.kcBackground)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverView()
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Discover")
                }
                .tag(0)
            
            MatchesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Matches")
                }
                .tag(1)
            
            MessagesView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Messages")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .tint(Color.kcRed)
    }
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.black, Color(red: 0.15, green: 0.0, blue: 0.0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.kcRed, Color.kcDarkRed],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "target")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .shadow(color: .red.opacity(0.5), radius: 20)
                    
                    Text("KillCount")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Know before you go")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Features
                VStack(spacing: 20) {
                    FeatureRow(
                        icon: "number.circle.fill",
                        title: "See Their Kill Count",
                        description: "Relationship history upfront, no surprises"
                    )
                    
                    FeatureRow(
                        icon: "checkmark.shield.fill",
                        title: "Verified Profiles",
                        description: "ID verification for authentic connections"
                    )
                    
                    FeatureRow(
                        icon: "lock.fill",
                        title: "Privacy First",
                        description: "You control what you share"
                    )
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // CTA Buttons
                VStack(spacing: 12) {
                    Button {
                        withAnimation(.spring(response: 0.4)) {
                            authManager.isAuthenticated = true
                        }
                    } label: {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color.kcRed, Color.kcDarkRed],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(14)
                    }
                    
                    Button {
                        withAnimation(.spring(response: 0.4)) {
                            authManager.isAuthenticated = true
                        }
                    } label: {
                        Text("I already have an account")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.kcRed)
                .frame(width: 44, height: 44)
                .background(Color.kcRed.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}
