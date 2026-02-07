import Foundation

// MARK: - Roommate Model
struct Roommate: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var color: String // For UI differentiation
    var joinDate: Date
    var isActive: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        color: String = "Blue",
        joinDate: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.color = color
        self.joinDate = joinDate
        self.isActive = isActive
    }
}
