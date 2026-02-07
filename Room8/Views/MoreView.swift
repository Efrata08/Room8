import SwiftUI

// MARK: - More View
struct MoreView: View {
    @StateObject private var viewModel = MoreViewModel()
    @State private var newName = ""
    @State private var newRelationship = ""
    @State private var newPhone = ""
    @State private var newNotes = ""

    private let emergencyNumber = "911"

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Settings")) {
                    Toggle("App Notifications", isOn: Binding(
                        get: { viewModel.notificationsEnabled },
                        set: { viewModel.updateNotificationsEnabled($0) }
                    ))

                    TextField("Campus Safety Number", text: Binding(
                        get: { viewModel.campusSafetyNumber },
                        set: { viewModel.updateCampusSafetyNumber($0) }
                    ))
                    .keyboardType(.phonePad)
                }

                Section(header: Text("Quick Contacts")) {
                    quickContactRow(
                        name: "Emergency",
                        number: emergencyNumber,
                        detail: "Call 911"
                    )

                    quickContactRow(
                        name: "Campus Safety",
                        number: viewModel.campusSafetyNumber,
                        detail: viewModel.campusSafetyNumber.isEmpty ? "Add number in Settings" : "Campus safety line"
                    )
                }

                Section(header: Text("Add Emergency Contact")) {
                    TextField("Name", text: $newName)
                    TextField("Relationship (optional)", text: $newRelationship)
                    TextField("Phone Number", text: $newPhone)
                        .keyboardType(.phonePad)
                    TextField("Notes (optional)", text: $newNotes, axis: .vertical)
                        .lineLimit(2, reservesSpace: true)

                    Button("Add Contact") {
                        viewModel.addContact(
                            name: newName,
                            relationship: newRelationship,
                            phoneNumber: newPhone,
                            notes: newNotes
                        )
                        newName = ""
                        newRelationship = ""
                        newPhone = ""
                        newNotes = ""
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                              newPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                Section(header: Text("Emergency Contacts")) {
                    if viewModel.emergencyContacts.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                .font(.system(size: 32))
                                .foregroundColor(.secondary)
                            Text("No emergency contacts yet")
                                .font(.headline)
                            Text("Add someone you trust to reach quickly")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    } else {
                        ForEach(viewModel.emergencyContacts) { contact in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(contact.name)
                                        .font(.headline)
                                    Spacer()
                                    callLink(number: contact.phoneNumber)
                                }
                                Text(contact.relationship)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                if let notes = contact.notes, !notes.isEmpty {
                                    Text(notes)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Text(contact.phoneNumber)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                        .onDelete(perform: viewModel.deleteContacts)
                    }
                }

                Section(header: Text("Help Center")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Need help?")
                            .font(.headline)
                        Text("Reach out to a roommate, check the house rules, or contact emergency services when needed.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("More")
        }
    }

    private func quickContactRow(name: String, number: String, detail: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                Text(detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            callLink(number: number)
        }
        .padding(.vertical, 4)
    }

    private func callLink(number: String) -> some View {
        let trimmed = number.trimmingCharacters(in: .whitespacesAndNewlines)
        let display = trimmed.isEmpty ? "Unavailable" : "Call"

        return Group {
            if let url = phoneURL(from: trimmed) {
                Link(display, destination: url)
                    .foregroundColor(.blue)
            } else {
                Text(display)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func phoneURL(from number: String) -> URL? {
        let digits = number.filter { $0.isNumber || $0 == "+" }
        guard !digits.isEmpty else { return nil }
        return URL(string: "tel://\(digits)")
    }
}

#Preview {
    MoreView()
}
