# Room8 - Chore Scheduling System

A complete Swift/SwiftUI implementation for managing chores and roommate assignments in a shared living space.

## Project Structure

```
Room8/
├── Models/
│   ├── Chore.swift              # Chore data model with frequency and priority
│   ├── Roommate.swift           # Roommate profile model
│   └── ChoreCompletion.swift    # Chore completion tracking
├── ViewModels/
│   └── ChoreScheduleViewModel.swift  # Main business logic and state management
├── Views/
│   ├── ContentView.swift        # Main tab view container
│   ├── ChoresView.swift         # Chore list with filtering options
│   ├── AddChoreView.swift       # Form to create new chores
│   ├── ChoreDetailView.swift    # Chore detail and editing
│   ├── RoommatesView.swift      # Roommate list and management
│   └── Room8App.swift           # App entry point
└── Utilities/
    └── StorageService.swift     # Local data persistence using UserDefaults
```

## Features

### Chore Management
- **Create Chores**: Add new chores with name, description, frequency, and priority
- **Frequency Options**: Daily, Weekly, Bi-weekly, Monthly, or As Needed
- **Priority Levels**: Low, Medium, High, Urgent
- **Time Estimates**: Set estimated completion time for each chore
- **Assignment**: Assign chores to specific roommates
- **Status Tracking**: Track when chores were last completed

### Chore Filtering
- **All**: View all chores
- **Overdue**: See chores that are due based on frequency
- **Due Today**: Show chores scheduled for today
- **Unassigned**: Filter chores without roommate assignment

### Roommate Management
- **Add Roommates**: Create profiles for household members
- **Email Storage**: Keep contact information
- **Color Coding**: Assign colors for visual identification
- **Chore Assignment Overview**: See which chores are assigned to each roommate

### Completion Tracking
- **Mark Complete**: Record when chores are completed
- **Last Completed Date**: Track completion history
- **Completion Notes**: Optional notes when marking chores complete

## Data Models

### Chore
```swift
struct Chore {
    let id: UUID
    var name: String
    var description: String
    var frequency: ChoreFrequency
    var estimatedMinutes: Int
    var priority: ChorePriority
    var assignedTo: UUID?
    var createdDate: Date
    var lastCompletedDate: Date?
}
```

### Roommate
```swift
struct Roommate {
    let id: UUID
    var name: String
    var email: String
    var color: String
    var joinDate: Date
    var isActive: Bool
}
```

### ChoreCompletion
```swift
struct ChoreCompletion {
    let id: UUID
    let choreId: UUID
    let completedBy: UUID
    let completedDate: Date
    var notes: String?
}
```

## MVVM Architecture

The app uses MVVM (Model-View-ViewModel) pattern:
- **Models**: Data structures (`Chore`, `Roommate`, `ChoreCompletion`)
- **ViewModels**: Business logic in `ChoreScheduleViewModel`
- **Views**: SwiftUI components for UI

## Key ViewModel Methods

### Chore Management
```swift
func addChore(_ chore: Chore)
func updateChore(_ chore: Chore)
func deleteChore(_ choreId: UUID)
func getChoresAssignedTo(_ roommateId: UUID) -> [Chore]
func getOverdueChores() -> [Chore]
func getChoresDueToday() -> [Chore]
```

### Roommate Management
```swift
func addRoommate(_ roommate: Roommate)
func updateRoommate(_ roommate: Roommate)
func deleteRoommate(_ roommateId: UUID)
```

### Chore Assignment
```swift
func assignChore(_ choreId: UUID, to roommateId: UUID)
func unassignChore(_ choreId: UUID)
func completeChore(_ choreId: UUID, by roommateId: UUID, notes: String?)
```

## Storage

The app uses `UserDefaults` via `StorageService` for local data persistence:
- Chores are stored and loaded from UserDefaults
- Roommates data is persisted
- Chore completion history is tracked

## Getting Started

1. **Open in Xcode**: Click "Room8.xcodeproj" to open the project
2. **Build**: Product → Build (⌘B)
3. **Run**: Product → Run (⌘R) or use the play button
4. **Add Roommates**: Go to the "Roommates" tab and add household members
5. **Create Chores**: Go to the "Chores" tab and start adding chores
6. **Assign Chores**: Select a chore and assign it to a roommate
7. **Track Completion**: Mark chores complete when done

## Google Calendar Integration

The app is set up to integrate with Google Calendar API. The infrastructure is in place and ready for implementation:

### Current Setup
- **GoogleCalendarService** - Service layer with protocol-based interface
- **CalendarConverter** - Utility to convert Room8 chores to calendar events
- **Sync UI** - "Sync with Google Calendar" button in ChoresView
- **ViewModel Methods** - Calendar sync, auth, and update methods ready

### How to Complete Integration
1. Merge the `google-calendar-api` branch (when ready)
2. Implement the `GoogleCalendarService` with actual API calls
3. Configure Google Cloud Console credentials
4. Update `Info.plist` with Google Sign-In setup
5. Install required Google Calendar SDK

**See GOOGLE_CALENDAR_INTEGRATION.md for detailed integration steps**

### Features Once Integrated
- ✅ Authorize with Google Calendar
- ✅ Sync all chores to calendar automatically
- ✅ Create recurring events based on chore frequency
- ✅ Update calendar events when chores change
- ✅ Delete calendar events when chores are deleted
- ✅ Auto-add roommate emails as attendees
- ✅ Set reminders for chore due dates

## Future Enhancements

Consider adding:
- Push notifications for due chores
- Two-way calendar sync (pull events back from Google Calendar)
- Chore rotation/auto-assignment logic
- Statistics and completion reports
- Cloud sync using CloudKit or Firebase
- Penalty/reward system
- Chore history and analytics
- Integration with finances/shared expenses
- Calendar conflict detection
