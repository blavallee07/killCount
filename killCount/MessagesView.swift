//
//  MessagesView.swift
//  killCount
//
//  Created by Benjamin Lavallee on 2026-01-16.
//

import SwiftUI

struct MessagesView: View {
    @State private var searchText = ""
    @State private var conversations: [Conversation] = Conversation.sampleConversations
    
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return conversations
        }
        return conversations.filter { $0.user.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.kcBackground.ignoresSafeArea()
                
                if conversations.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredConversations) { conversation in
                                NavigationLink {
                                    ChatView(conversation: conversation)
                                } label: {
                                    ConversationRow(conversation: conversation)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Search messages")
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "message.badge.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No messages yet")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
            
            Text("Match with someone to start chatting")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Conversation Model
struct Conversation: Identifiable {
    let id = UUID()
    let user: User
    var messages: [Message]
    var lastMessageTime: Date
    var unreadCount: Int
    
    var lastMessage: String {
        messages.last?.text ?? ""
    }
    
    static let sampleConversations: [Conversation] = [
        Conversation(
            user: User.sampleUsers[0],
            messages: [
                Message(text: "Hey! I noticed we matched 🎯", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600)),
                Message(text: "Hi Sarah! Yeah, I saw your profile - you seem cool", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3500)),
                Message(text: "Thanks! What are you up to this weekend?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3400))
            ],
            lastMessageTime: Date().addingTimeInterval(-3400),
            unreadCount: 1
        ),
        Conversation(
            user: User.sampleUsers[1],
            messages: [
                Message(text: "Tacos sound amazing actually", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-86400))
            ],
            lastMessageTime: Date().addingTimeInterval(-86400),
            unreadCount: 0
        )
    ]
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date
}

// MARK: - Conversation Row
struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar with Kill Count indicator
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.kcCardBackground)
                    .frame(width: 60, height: 60)
                
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(.gray.opacity(0.5))
                
                // Mini kill count badge
                Text("\(conversation.user.killCount)")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(killCountColor(conversation.user.killCount))
                    .clipShape(Circle())
                    .offset(x: 4, y: 4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.user.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if conversation.user.verificationStatus == .idVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    Text(timeAgo(conversation.lastMessageTime))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text(conversation.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color.kcRed)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.kcBackground)
    }
    
    private func killCountColor(_ count: Int) -> Color {
        switch count {
        case 0...3: return .green
        case 4...7: return .yellow
        case 8...15: return .orange
        default: return .red
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Chat View
struct ChatView: View {
    let conversation: Conversation
    @State private var messageText = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            Color.kcBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Messages
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Kill Count info card at top
                        KillCountInfoCard(user: conversation.user)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        ForEach(conversation.messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.bottom)
                }
                
                // Input bar
                HStack(spacing: 12) {
                    Button { } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.kcRed)
                    }
                    
                    TextField("Type a message...", text: $messageText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.kcCardBackground)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .focused($isInputFocused)
                    
                    Button {
                        // Send message
                        messageText = ""
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundColor(messageText.isEmpty ? .gray : .kcRed)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color.kcBackground)
            }
        }
        .navigationTitle(conversation.user.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { } label: {
                    Image(systemName: "video.fill")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Kill Count Info Card (in chat)
struct KillCountInfoCard: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "target")
                .font(.title3.weight(.bold))
                .foregroundColor(killCountColor(user.killCount))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(user.name)'s Kill Count: \(user.killCount)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                
                Text("Longest relationship: \(user.relationshipHistory.longestRelationship)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VerificationBadge(status: user.verificationStatus)
        }
        .padding()
        .background(Color.kcCardBackground)
        .cornerRadius(12)
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

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer() }
            
            Text(message.text)
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(message.isFromCurrentUser ? Color.kcRed : Color.kcCardBackground)
                .cornerRadius(20)
            
            if !message.isFromCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MessagesView()
}
