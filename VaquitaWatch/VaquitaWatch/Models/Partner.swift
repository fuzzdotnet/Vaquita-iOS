import Foundation

struct Partner: Identifiable, Codable {
    var id: String
    var name: String
    var tagline: String
    var description: String
    var logoAsset: String
    var websiteURL: URL?
    var impactSummary: String
    var focusAreas: [String]
    
    // For map display
    var latitude: Double?
    var longitude: Double?
} 