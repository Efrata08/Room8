import SwiftUI

// MARK: - Add Chore View
struct AddChoreView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var description = ""
    @State private var frequency: ChoreFrequency = .weekly
    @State private var estimatedMinutes = 30
    @State private var priority: ChorePriority = .medium
    @State private var selectedRoommateId: UUID?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Chore Details")) {
                    TextField("Chore Name", text: $name)
                    TextField("Description", text: $description)
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(ChoreFrequency.allCases, id: \.self) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }
                    
                    Stepper(value: $estimatedMinutes, in: 5...180, step: 5) {
                        HStack {
                            Text("Estimated Time")
                            Spacer()
                            Text("\(estimatedMinutes) minutes")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(ChorePriority.allCases, id: \.self) { prio in
                            Text(prio.rawValue).tag(prio)
                        }
                    }
                }
                
                Section(header: Text("Assignment")) {
                    Picker("Assign To", selection: $selectedRoommateId) {
                        Text("Unassigned").tag(UUID?(nil))
                        
                        ForEach(viewModel.roommates) { roommate in
                            Text(roommate.name).tag(UUID?(roommate.id))
                        }
                    }
                }
            }
            .navigationTitle("New Chore")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChore()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveChore() {
        let chore = Chore(
            name: name,
            description: description,
            frequency: frequency,
            estimatedMinutes: estimatedMinutes,
            priority: priority,
            assignedTo: selectedRoommateId
        )
        viewModel.addChore(chore)
        isPresented = false
    }
}
