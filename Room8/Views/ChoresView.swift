import SwiftUI

// MARK: - Chores View
struct ChoresView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    @Binding var showingAddChore: Bool
    @State private var selectedFilter: ChoreFilter = .all
    @State private var showingCalendarSync = false
    
    var filteredChores: [Chore] {
        switch selectedFilter {
        case .all:
            return viewModel.chores
        case .overdue:
            return viewModel.getOverdueChores()
        case .dueToday:
            return viewModel.getChoresDueToday()
        case .unassigned:
            return viewModel.chores.filter { $0.assignedTo == nil }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Google Calendar Sync Status
                if !viewModel.isCalendarSynced {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Sync with Google Calendar")
                        Spacer()
                        Button("Setup") {
                            showingCalendarSync = true
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                }
                
                // Filter Picker
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(ChoreFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Chores List
                if filteredChores.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checklist")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No chores")
                            .font(.headline)
                        Text("Add your first chore to get started")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    List {
                        ForEach(filteredChores) { chore in
                            NavigationLink(destination: ChoreDetailView(viewModel: viewModel, chore: chore)) {
                                ChoreRowView(viewModel: viewModel, chore: chore)
                            }
                        }
                        .onDelete(perform: deleteChores)
                    }
                }
            }
            .navigationTitle("Chores")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddChore = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                    }
                }
            }
            .sheet(isPresented: $showingAddChore) {
                AddChoreView(viewModel: viewModel, isPresented: $showingAddChore)
            }
            .sheet(isPresented: $showingCalendarSync) {
                GoogleCalendarSyncView(viewModel: viewModel, isPresented: $showingCalendarSync)
            }
        }
    }
    
    private func deleteChores(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteChore(filteredChores[index].id)
        }
    }
}

// MARK: - Chore Row View
struct ChoreRowView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    let chore: Chore
    
    var assignedRoommate: Roommate? {
        viewModel.getRoommateForChore(chore)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(chore.name)
                        .font(.headline)
                    
                    HStack(spacing: 8) {
                        Label(chore.frequency.rawValue, systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Label("\(chore.estimatedMinutes) min", systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    priorityBadge
                    
                    if let roommate = assignedRoommate {
                        Text(roommate.name)
                            .font(.caption)
                            .padding(4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var priorityBadge: some View {
        Text(chore.priority.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priorityColor.opacity(0.2))
            .foregroundColor(priorityColor)
            .cornerRadius(4)
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

// MARK: - Chore Filter
enum ChoreFilter: String, CaseIterable {
    case all = "All"
    case overdue = "Overdue"
    case dueToday = "Due Today"
    case unassigned = "Unassigned"
}

// MARK: - Google Calendar Sync View
struct GoogleCalendarSyncView: View {
    @ObservedObject var viewModel: ChoreScheduleViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.calendarsyncInProgress {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Syncing chores with Google Calendar...")
                        .foregroundColor(.secondary)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        
                        Text("Google Calendar Integration")
                            .font(.headline)
                        
                        Text("Connect Room8 with Google Calendar to automatically add all chores to your calendar.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        if let error = viewModel.errorMessage {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(error)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 12) {
                            Button(action: authorizeCalendar) {
                                HStack {
                                    Image(systemName: viewModel.isGoogleCalendarAuthorized() ? "checkmark.circle.fill" : "circle")
                                    Text("Authorize Google Calendar")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.isGoogleCalendarAuthorized())
                            
                            if viewModel.isGoogleCalendarAuthorized() {
                                Button(action: syncChores) {
                                    HStack {
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                        Text("Sync \(viewModel.chores.count) Chores")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Calendar Sync")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func authorizeCalendar() {
        viewModel.authorizeGoogleCalendar { success in
            if !success {
                // Error is shown in the view via viewModel.errorMessage
            }
        }
    }
    
    private func syncChores() {
        viewModel.syncChoresToCalendar { success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    ChoresView(viewModel: ChoreScheduleViewModel(), showingAddChore: .constant(false))
}