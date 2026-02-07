import Foundation

// MARK: - Storage Service for Local Persistence
class StorageService {
    static let shared = StorageService()
    
    private let choreKey = "room8_chores"
    private let roommateKey = "room8_roommates"
    private let completionKey = "room8_completions"
    private let defaults = UserDefaults.standard
    
    // MARK: - Chore Storage
    
    func saveChores(_ chores: [Chore]) {
        if let encoded = try? JSONEncoder().encode(chores) {
            defaults.set(encoded, forKey: choreKey)
        }
    }
    
    func loadChores() -> [Chore] {
        guard let data = defaults.data(forKey: choreKey),
              let chores = try? JSONDecoder().decode([Chore].self, from: data) else {
            return []
        }
        return chores
    }
    
    // MARK: - Roommate Storage
    
    func saveRoommates(_ roommates: [Roommate]) {
        if let encoded = try? JSONEncoder().encode(roommates) {
            defaults.set(encoded, forKey: roommateKey)
        }
    }
    
    func loadRoommates() -> [Roommate] {
        guard let data = defaults.data(forKey: roommateKey),
              let roommates = try? JSONDecoder().decode([Roommate].self, from: data) else {
            return []
        }
        return roommates
    }
    
    // MARK: - Completion Storage
    
    func saveCompletions(_ completions: [ChoreCompletion]) {
        if let encoded = try? JSONEncoder().encode(completions) {
            defaults.set(encoded, forKey: completionKey)
        }
    }
    
    func loadCompletions() -> [ChoreCompletion] {
        guard let data = defaults.data(forKey: completionKey),
              let completions = try? JSONDecoder().decode([ChoreCompletion].self, from: data) else {
            return []
        }
        return completions
    }
    
    // MARK: - Clear All Data
    
    func clearAllData() {
        defaults.removeObject(forKey: choreKey)
        defaults.removeObject(forKey: roommateKey)
        defaults.removeObject(forKey: completionKey)
    }
}
