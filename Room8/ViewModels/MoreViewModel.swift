import Foundation

// MARK: - More View Model
@MainActor
class MoreViewModel: ObservableObject {
    @Published var emergencyContacts: [EmergencyContact] = []
    @Published var campusSafetyNumber: String = ""
    @Published var notificationsEnabled: Bool = true

    private let storageService = StorageService.shared

    init() {
        load()
    }

    func addContact(name: String, relationship: String, phoneNumber: String, notes: String?) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedRelationship = relationship.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty, !trimmedPhone.isEmpty else { return }

        let contact = EmergencyContact(
            name: trimmedName,
            relationship: trimmedRelationship.isEmpty ? "Emergency" : trimmedRelationship,
            phoneNumber: trimmedPhone,
            notes: trimmedNotes?.isEmpty == true ? nil : trimmedNotes
        )

        emergencyContacts.insert(contact, at: 0)
        saveContacts()
    }

    func deleteContacts(at offsets: IndexSet) {
        emergencyContacts.remove(atOffsets: offsets)
        saveContacts()
    }

    func updateCampusSafetyNumber(_ number: String) {
        campusSafetyNumber = number
        storageService.saveCampusSafetyNumber(number)
    }

    func updateNotificationsEnabled(_ enabled: Bool) {
        notificationsEnabled = enabled
        storageService.saveNotificationsEnabled(enabled)
    }

    private func load() {
        emergencyContacts = storageService.loadEmergencyContacts()
        campusSafetyNumber = storageService.loadCampusSafetyNumber()
        notificationsEnabled = storageService.loadNotificationsEnabled()
    }

    private func saveContacts() {
        storageService.saveEmergencyContacts(emergencyContacts)
    }
}
