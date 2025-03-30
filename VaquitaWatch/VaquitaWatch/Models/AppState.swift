import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var currentFact: VaquitaFact? = nil
    @Published var userVaquita: VaquitaAvatar = VaquitaAvatar()
    @Published var completedChallenges: [String: Bool] = [:]
    @Published var isSubscriber: Bool = false
    @Published var unlockedItems: Set<String> = []
    
    // Current week's challenge
    @Published var currentChallenge: Challenge? = nil
    
    // Track user's streak and engagement
    @Published var checkInStreak: Int = 0
    @Published var lastCheckIn: Date? = nil
    
    init() {
        // Load any saved data from UserDefaults
        loadSavedState()
        
        // Set today's fact when app starts
        setDailyFact()
    }
    
    func loadSavedState() {
        // TODO: Load user data from UserDefaults or other persistent storage
    }
    
    func saveState() {
        // TODO: Save user data to UserDefaults or other persistent storage
    }
    
    func setDailyFact() {
        // For now, use a placeholder fact
        currentFact = VaquitaFact(
            id: "fact1",
            title: "Smallest Marine Mammal",
            content: "The vaquita is the smallest cetacean, reaching lengths of only 4-5 feet (1.2-1.5 m) and weighing up to 120 pounds (55 kg).",
            imageAsset: "vaquita_size_comparison",
            category: .biology
        )
    }
    
    func checkIn() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastCheckIn = lastCheckIn {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            
            if Calendar.current.isDate(lastCheckIn, inSameDayAs: yesterday) {
                // User checked in yesterday, increment streak
                checkInStreak += 1
            } else if !Calendar.current.isDate(lastCheckIn, inSameDayAs: today) {
                // User missed a day, reset streak
                checkInStreak = 1
            }
        } else {
            // First check-in
            checkInStreak = 1
        }
        
        lastCheckIn = today
        saveState()
    }
    
    func completeChallenge(id: String) {
        completedChallenges[id] = true
        saveState()
    }
    
    func unlockItem(id: String) {
        unlockedItems.insert(id)
        saveState()
    }
} 