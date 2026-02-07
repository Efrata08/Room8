import SwiftUI

// MARK: - Roommates View
struct RoommatesView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    @Binding var showingRoommates: Bool
    @State private var showingAddRoommate = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.roommates.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.2")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No roommates")
                            .font(.headline)
                        Text("Add roommates to assign chores")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    List {
                        ForEach(viewModel.roommates) { roommate in
                            NavigationLink(destination: RoommateDetailView(viewModel: viewModel, roommate: roommate)) {
                                RoommateRowView(roommate: roommate, viewModel: viewModel)
                            }
                        }
                        .onDelete(perform: deleteRoommates)
                    }
                }
            }
            .navigationTitle("Roommates")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddRoommate = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                    }
                }
            }
            .sheet(isPresented: $showingAddRoommate) {
                AddRoommateView(viewModel: viewModel, isPresented: $showingAddRoommate)
            }
        }
    }
    
    private func deleteRoommates(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteRoommate(viewModel.roommates[index].id)
        }
    }
}

// MARK: - Roommate Row View
struct RoommateRowView: View {
    let roommate: Roommate
    @ObservedObject var viewModel: ChoreScheduleViewModel
    
    var assignedChoreCount: Int {
        viewModel.getChoresAssignedTo(roommate.id).count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(roommate.name)
                        .font(.headline)
                    
                    Text(roommate.email)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text("\(assignedChoreCount) chores")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Add Roommate View
struct AddRoommateView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var email = ""
    @State private var selectedColor = "Blue"
    
    let colors = ["Blue", "Green", "Red", "Purple", "Orange", "Yellow"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Roommate Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    
                    Picker("Color", selection: $selectedColor) {
                        ForEach(colors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }
                }
            }
            .navigationTitle("New Roommate")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRoommate()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || 
                             email.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveRoommate() {
        let roommate = Roommate(
            name: name,
            email: email,
            color: selectedColor
        )
        viewModel.addRoommate(roommate)
        isPresented = false
    }
}

// MARK: - Roommate Detail View
struct RoommateDetailView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    let roommate: Roommate
    
    @State private var isEditing = false
    @Environment(\.presentationMode) var presentationMode
    
    var assignedChores: [Chore] {
        viewModel.getChoresAssignedTo(roommate.id)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Information")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(roommate.name)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text(roommate.email)
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text("Member Since")
                    Spacer()
                    Text(roommate.joinDate.formatted(date: .abbreviated, time: .omitted))
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Assigned Chores (\(assignedChores.count))")) {
                if assignedChores.isEmpty {
                    Text("No chores assigned")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(assignedChores) { chore in
                        HStack {
                            Text(chore.name)
                            Spacer()
                            Text(chore.frequency.rawValue)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Section {
                Button(action: { isEditing = true }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit Roommate")
                    }
                }
            }
        }
        .navigationTitle("Roommate Details")
        .sheet(isPresented: $isEditing) {
            EditRoommateView(viewModel: viewModel, roommate: roommate, isPresented: $isEditing)
        }
    }
}

// MARK: - Edit Roommate View
struct EditRoommateView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    let roommate: Roommate
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var selectedColor: String = "Blue"
    
    let colors = ["Blue", "Green", "Red", "Purple", "Orange", "Yellow"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Roommate Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    
                    Picker("Color", selection: $selectedColor) {
                        ForEach(colors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }
                }
                
                Section {
                    Button("Delete Roommate", role: .destructive) {
                        viewModel.deleteRoommate(roommate.id)
                        isPresented = false
                    }
                }
            }
            .navigationTitle("Edit Roommate")
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
            .onAppear(perform: loadRoommateData)
        }
    }
    
    private func loadRoommateData() {
        name = roommate.name
        email = roommate.email
        selectedColor = roommate.color
    }
    
    private func saveChanges() {
        var updatedRoommate = roommate
        updatedRoommate.name = name
        updatedRoommate.email = email
        updatedRoommate.color = selectedColor
        
        viewModel.updateRoommate(updatedRoommate)
        isPresented = false
    }
}
