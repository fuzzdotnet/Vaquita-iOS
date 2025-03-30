import Foundation

enum FactCategory: String, Codable, CaseIterable {
    case biology = "Biology"
    case conservation = "Conservation"
    case habitat = "Habitat"
    case threats = "Threats"
    case history = "History"
    case action = "Take Action"
}

struct VaquitaFact: Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var imageAsset: String?
    var category: FactCategory
    var date: Date?
    
    // Optional URL for "Learn More"
    var learnMoreURL: URL?
    
    init(id: String, title: String, content: String, imageAsset: String? = nil, 
         category: FactCategory, date: Date? = nil, learnMoreURL: URL? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.imageAsset = imageAsset
        self.category = category
        self.date = date
        self.learnMoreURL = learnMoreURL
    }
} 