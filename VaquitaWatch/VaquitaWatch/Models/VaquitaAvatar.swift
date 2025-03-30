import SwiftUI

// Available avatar customization options
enum VaquitaSkin: String, CaseIterable, Identifiable {
    case classic = "Classic"
    case explorer = "Explorer"
    case night = "Night Glow"
    case coral = "Coral Reef"
    case golden = "Golden Sunset"
    
    var id: String { self.rawValue }
    var imageName: String { "vaquita_skin_\(self.rawValue.lowercased().replacingOccurrences(of: " ", with: "_"))" }
}

enum VaquitaAccessory: String, CaseIterable, Identifiable {
    case none = "None"
    case bubbles = "Bubble Trail"
    case heartBand = "Heart Headband"
    case starfish = "Starfish Friend"
    case glowEffect = "Ocean Glow"
    case coral = "Coral Companion"
    
    var id: String { self.rawValue }
    var imageName: String { 
        self == .none ? "" : "vaquita_accessory_\(self.rawValue.lowercased().replacingOccurrences(of: " ", with: "_"))" 
    }
}

enum VaquitaBackground: String, CaseIterable, Identifiable {
    case oceanic = "Oceanic Blue"
    case reef = "Coral Reef"
    case deepSea = "Deep Sea"
    case nightOcean = "Night Ocean"
    case abstract = "Abstract Waves"
    
    var id: String { self.rawValue }
    var imageName: String { "vaquita_bg_\(self.rawValue.lowercased().replacingOccurrences(of: " ", with: "_"))" }
}

struct VaquitaAvatar: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String = "Vaquita"
    var skin: String = VaquitaSkin.classic.rawValue
    var accessory: String = VaquitaAccessory.none.rawValue
    var background: String = VaquitaBackground.oceanic.rawValue
    var isAdopted: Bool = false
    var adoptionDate: Date? = nil
    var happinessLevel: Int = 5 // Scale of 1-10
    var lastInteraction: Date = Date()
    var unlockedPremiumItems: Set<String> = []
    
    // Increase happiness when user interacts with the avatar
    mutating func interact() {
        happinessLevel = min(10, happinessLevel + 1)
        lastInteraction = Date()
    }
    
    // Decrease happiness over time
    mutating func updateHappiness() {
        let daysSinceLastInteraction = Calendar.current.dateComponents([.day], from: lastInteraction, to: Date()).day ?? 0
        
        if daysSinceLastInteraction > 0 {
            happinessLevel = max(1, happinessLevel - min(daysSinceLastInteraction, happinessLevel - 1))
        }
    }
    
    // Check if a premium item is unlocked
    func isPremiumItemUnlocked(_ itemId: String) -> Bool {
        return unlockedPremiumItems.contains(itemId)
    }
    
    // Unlock a premium item
    mutating func unlockPremiumItem(_ itemId: String) {
        unlockedPremiumItems.insert(itemId)
    }
} 