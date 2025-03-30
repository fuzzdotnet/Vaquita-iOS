import Foundation

enum ChallengeType: String, Codable, CaseIterable {
    case awareness = "Awareness"
    case conservation = "Conservation"
    case donation = "Donation"
    case lifestyle = "Lifestyle"
    case social = "Social"
}

struct Challenge: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var type: ChallengeType
    var isExclusive: Bool // If true, only available to subscribers
    var points: Int
    var rewardBadge: String? // Image asset name for badge
    
    // Date range when this challenge is active
    var startDate: Date?
    var endDate: Date?
    
    // Track user's progress for multi-step challenges (optional)
    var totalSteps: Int = 1
    var completedSteps: Int = 0
    
    var isCompleted: Bool {
        return completedSteps >= totalSteps
    }
    
    var isActive: Bool {
        let now = Date()
        let isAfterStart = startDate == nil || now >= startDate!
        let isBeforeEnd = endDate == nil || now <= endDate!
        return isAfterStart && isBeforeEnd
    }
} 