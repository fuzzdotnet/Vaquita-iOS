import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var currentFact: VaquitaFact? = nil
    @Published var userVaquita: VaquitaAvatar = VaquitaAvatar() {
        didSet {
            saveState()
        }
    }
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
        
        // Listen for notification to show adoption certificate
        NotificationCenter.default.addObserver(self, selector: #selector(showAdoptionCertificate), name: Notification.Name("ShowAdoptionCertificate"), object: nil)
    }
    
    func loadSavedState() {
        if let savedVaquitaData = UserDefaults.standard.data(forKey: "userVaquita") {
            let decoder = JSONDecoder()
            if let loadedVaquita = try? decoder.decode(VaquitaAvatar.self, from: savedVaquitaData) {
                self.userVaquita = loadedVaquita
            }
        }
        
        self.completedChallenges = UserDefaults.standard.dictionary(forKey: "completedChallenges") as? [String: Bool] ?? [:]
        self.checkInStreak = UserDefaults.standard.integer(forKey: "checkInStreak")
        
        if let lastCheckInTimeInterval = UserDefaults.standard.object(forKey: "lastCheckIn") as? TimeInterval {
            self.lastCheckIn = Date(timeIntervalSince1970: lastCheckInTimeInterval)
        }
    }
    
    func saveState() {
        let encoder = JSONEncoder()
        if let encodedVaquita = try? encoder.encode(userVaquita) {
            UserDefaults.standard.set(encodedVaquita, forKey: "userVaquita")
        }
        
        UserDefaults.standard.set(completedChallenges, forKey: "completedChallenges")
        UserDefaults.standard.set(checkInStreak, forKey: "checkInStreak")
        
        if let lastCheckIn = lastCheckIn {
            UserDefaults.standard.set(lastCheckIn.timeIntervalSince1970, forKey: "lastCheckIn")
        } else {
            UserDefaults.standard.removeObject(forKey: "lastCheckIn")
        }
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
    
    @objc func showAdoptionCertificate() {
        NotificationCenter.default.post(name: Notification.Name("ShowVaquitaCertificate"), object: nil)
    }
    
    // Helper function to unlock a premium item with IAP
    func unlockPremiumItem(itemId: String) {
        // In a real app, this would verify the purchase receipt
        var updatedVaquita = userVaquita
        updatedVaquita.unlockPremiumItem(itemId)
        userVaquita = updatedVaquita
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