import Foundation

// MARK: - Chore Completion Record
struct ChoreCompletion: Identifiable, Codable {
    let id: UUID
    let choreId: UUID
    let completedBy: UUID
    let completedDate: Date
    var notes: String?
    
    init(
        id: UUID = UUID(),
        choreId: UUID,
        completedBy: UUID,
        completedDate: Date = Date(),
        notes: String? = nil
    ) {
        self.id = id
        self.choreId = choreId
        self.completedBy = completedBy
        self.completedDate = completedDate
        self.notes = notes
    }
}
