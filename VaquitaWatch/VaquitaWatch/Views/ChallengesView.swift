import SwiftUI

struct ChallengesView: View {
    @EnvironmentObject var appState: AppState
    @State private var activeTab = 0
    
    // Sample challenges for prototype
    private let weeklyChallenges = [
        Challenge(
            id: "challenge1",
            title: "Share a Vaquita Fact",
            description: "Share today's fact with a friend or on social media to raise awareness.",
            type: .awareness,
            isExclusive: false,
            points: 50,
            rewardBadge: "badge_awareness"
        ),
        Challenge(
            id: "challenge2",
            title: "Skip Seafood Today",
            description: "Bycatch from fishing is a major threat to vaquitas. Skip seafood for a day.",
            type: .lifestyle,
            isExclusive: false,
            points: 75,
            rewardBadge: "badge_lifestyle"
        ),
        Challenge(
            id: "challenge3",
            title: "Read About Conservation",
            description: "Learn more about conservation efforts in the Gulf of California.",
            type: .conservation,
            isExclusive: false,
            points: 30,
            rewardBadge: "badge_conservation"
        ),
        Challenge(
            id: "challenge4",
            title: "Make a Micro-Donation",
            description: "Donate any amount to support vaquita conservation efforts.",
            type: .donation,
            isExclusive: false,
            points: 100,
            rewardBadge: "badge_donation"
        ),
        Challenge(
            id: "challenge5",
            title: "Learn About Fishing Nets",
            description: "Read about how ghost nets and gillnets threaten vaquitas and other marine life.",
            type: .awareness,
            isExclusive: true,
            points: 40,
            rewardBadge: "badge_nets"
        )
    ]
    
    private let rewardBadges = [
        "badge_awareness": "Awareness Ambassador",
        "badge_lifestyle": "Eco Conscious",
        "badge_conservation": "Conservation Ally",
        "badge_donation": "Vaquita Guardian",
        "badge_nets": "Net Awareness",
        "badge_social": "Social Advocate",
        "badge_streak": "7-Day Streak",
        "badge_ocean": "Ocean Defender"
    ]
    
    var body: some View {
        ZStack {
            // Background color
            Color.oceanLightBlue.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Segmented control for tabs
                Picker("View", selection: $activeTab) {
                    Text("Challenges").tag(0)
                    Text("Rewards").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Main content based on selected tab
                if activeTab == 0 {
                    // Challenges view
                    ScrollView {
                        VStack(spacing: 20) {
                            // Weekly challenge header
                            HStack {
                                Text("Weekly Challenges")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            // Weekly challenges list
                            ForEach(weeklyChallenges) { challenge in
                                if !challenge.isExclusive || appState.userVaquita.isAdopted {
                                    ChallengeCard(
                                        challenge: challenge,
                                        isCompleted: appState.completedChallenges[challenge.id] ?? false,
                                        onComplete: {
                                            appState.completeChallenge(id: challenge.id)
                                        }
                                    )
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Subscriber-only challenges section
                            if !appState.userVaquita.isAdopted {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Subscriber-Only Challenges")
                                            .font(.system(.title3, design: .rounded))
                                            .fontWeight(.bold)
                                        Spacer()
                                    }
                                    
                                    // Preview of locked challenges
                                    ForEach(weeklyChallenges.filter { $0.isExclusive }) { challenge in
                                        LockedChallengeCard(challenge: challenge)
                                    }
                                    
                                    // Unlock prompt
                                    Button(action: {
                                        // Show adoption sheet
                                    }) {
                                        HStack {
                                            Text("Adopt a Vaquita to Unlock")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            
                                            Image(systemName: "lock.open.fill")
                                                .foregroundColor(.white)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.coralAccent)
                                        .cornerRadius(12)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5)
                                .padding(.horizontal)
                            }
                            
                            // Custom challenge
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Create Your Own Challenge")
                                    .font(.headline)
                                
                                Text("Have an idea for how to help the vaquita? Create your own challenge and share it with the community.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    // Show custom challenge creator
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Color.tealAccent)
                                        Text("Create Challenge")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(Color.tealAccent)
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                        .padding(.top)
                    }
                } else {
                    // Rewards view
                    ScrollView {
                        VStack(spacing: 24) {
                            // Current points
                            HStack {
                                Text("Your Points: 275")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                            .padding(.horizontal)
                            
                            // Reward badges grid
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(Array(rewardBadges.keys.sorted()), id: \.self) { badgeId in
                                    RewardBadgeView(
                                        badgeId: badgeId,
                                        title: rewardBadges[badgeId] ?? "",
                                        isUnlocked: badgeId == "badge_awareness" || badgeId == "badge_lifestyle"
                                    )
                                }
                            }
                            .padding(.horizontal)
                            
                            // Coming soon section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Coming Soon")
                                    .font(.headline)
                                
                                Text("More badges and physical rewards will be available in future updates. Keep completing challenges to earn points!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                        .padding(.top)
                    }
                }
            }
        }
        .navigationTitle("Challenges & Rewards")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Challenge card component
struct ChallengeCard: View {
    let challenge: Challenge
    let isCompleted: Bool
    let onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Challenge type badge and points
            HStack {
                Text(challenge.type.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(typeColor(challenge.type).opacity(0.2))
                    .foregroundColor(typeColor(challenge.type))
                    .cornerRadius(8)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("\(challenge.points)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            
            // Challenge title
            Text(challenge.title)
                .font(.headline)
            
            // Challenge description
            Text(challenge.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Complete button
            Button(action: onComplete) {
                HStack {
                    Text(isCompleted ? "Completed" : "Mark as Completed")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isCompleted ? Color(.systemGray5) : Color.tealAccent.opacity(0.2))
                .foregroundColor(isCompleted ? .secondary : Color.tealAccent)
                .cornerRadius(8)
            }
            .disabled(isCompleted)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .overlay(
            // Completed overlay badge
            isCompleted ?
            VStack {
                HStack {
                    Spacer()
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                        .padding(8)
                }
                
                Spacer()
            }
            : nil
        )
    }
    
    // Return color based on challenge type
    private func typeColor(_ type: ChallengeType) -> Color {
        switch type {
        case .awareness:
            return Color.blue
        case .conservation:
            return Color.green
        case .donation:
            return Color.coralAccent
        case .lifestyle:
            return Color.purple
        case .social:
            return Color.orange
        }
    }
}

// Locked challenge card
struct LockedChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(challenge.type.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(Color.gray)
                    .cornerRadius(8)
                
                Spacer()
                
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }
            
            Text(challenge.title)
                .font(.headline)
                .foregroundColor(.gray)
            
            // Blurred description
            Text(challenge.description)
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.6))
                .redacted(reason: .placeholder)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

// Reward badge view
struct RewardBadgeView: View {
    let badgeId: String
    let title: String
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Badge image (for now just a placeholder)
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.oceanBlue.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 110, height: 110)
                
                if isUnlocked {
                    Image(systemName: badgeIcon)
                        .font(.system(size: 40))
                        .foregroundColor(Color.oceanBlue)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isUnlocked ? .primary : .gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
    
    // Return a different icon based on badge ID
    private var badgeIcon: String {
        switch badgeId {
        case "badge_awareness":
            return "megaphone.fill"
        case "badge_lifestyle":
            return "leaf.fill"
        case "badge_conservation":
            return "globe.americas.fill"
        case "badge_donation":
            return "heart.fill"
        case "badge_nets":
            return "link.circle.fill"
        case "badge_social":
            return "person.2.fill"
        case "badge_streak":
            return "flame.fill"
        case "badge_ocean":
            return "water.waves"
        default:
            return "star.fill"
        }
    }
} 