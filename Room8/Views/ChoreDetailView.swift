import SwiftUI

// MARK: - Chore Detail View
struct ChoreDetailView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    let chore: Chore
    
    @State private var isEditing = false
    @Environment(\.presentationMode) var presentationMode
    
    var assignedRoommate: Roommate? {
        viewModel.getRoommateForChore(chore)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section(header: Text("Details")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(chore.name)
                            .fontWeight(.semibold)
                    }
                    
                    if !chore.description.isEmpty {
                        HStack(alignment: .top) {
                            Text("Description")
                            Spacer()
                            Text(chore.description)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    HStack {
                        Text("Frequency")
                        Spacer()
                        Text(chore.frequency.rawValue)
                    }
                    
                    HStack {
                        Text("Estimated Time")
                        Spacer()
                        Text("\(chore.estimatedMinutes) minutes")
                    }
                    
                    HStack {
                        Text("Priority")
                        Spacer()
                        Text(chore.priority.rawValue)
                            .foregroundColor(priorityColor)
                            .fontWeight(.semibold)
                    }
                }
                
                Section(header: Text("Assignment")) {
                    if let roommate = assignedRoommate {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text(roommate.name)
                                .fontWeight(.semibold)
                        }
                    } else {
                        Text("Unassigned")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Status")) {
                    if let lastCompleted = chore.lastCompletedDate {
                        HStack {
                            Text("Last Completed")
                            Spacer()
                            Text(lastCompleted.formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        HStack {
                            Text("Last Completed")
                            Spacer()
                            Text("Never")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Created")
                        Spacer()
                        Text(chore.createdDate.formatted(date: .abbreviated, time: .omitted))
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button(action: { isEditing = true }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit Chore")
                        }
                    }
                    
                    Button(action: completeChore) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark as Complete")
                        }
                        .foregroundColor(.green)
                    }
                }
            }
        }
        .navigationTitle("Chore Details")
        .sheet(isPresented: $isEditing) {
            EditChoreView(viewModel: viewModel, chore: chore, isPresented: $isEditing)
        }
    }
    
    private func completeChore() {
        if let roommateId = chore.assignedTo {
            viewModel.completeChore(chore.id, by: roommateId)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private var priorityColor: Color {
        switch chore.priority {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .orange
        case .urgent:
            return .red
        }
    }
}

// MARK: - Edit Chore View
struct EditChoreView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    let chore: Chore
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var frequency: ChoreFrequency = .weekly
    @State private var estimatedMinutes: Int = 30
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
                
                Section {
                    Button("Delete Chore", role: .destructive) {
                        viewModel.deleteChore(chore.id)
                        isPresented = false
                    }
                }
            }
            .navigationTitle("Edit Chore")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
            .onAppear(perform: loadChoreData)
        }
    }
    
    private func loadChoreData() {
        name = chore.name
        description = chore.description
        frequency = chore.frequency
        estimatedMinutes = chore.estimatedMinutes
        priority = chore.priority
        selectedRoommateId = chore.assignedTo
    }
    
    private func saveChanges() {
        var updatedChore = chore
        updatedChore.name = name
        updatedChore.description = description
        updatedChore.frequency = frequency
        updatedChore.estimatedMinutes = estimatedMinutes
        updatedChore.priority = priority
        updatedChore.assignedTo = selectedRoommateId
        
        viewModel.updateChore(updatedChore)
        isPresented = false
    }
}
