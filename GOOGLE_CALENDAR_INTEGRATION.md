# Google Calendar API Integration Guide

This document explains how to complete the Google Calendar integration when the API work branch is ready.

## Architecture Overview

The integration is built using a **service protocol pattern** that allows for flexible implementation:

```
UILayer (ChoresView) 
    ↓
ViewModel (ChoreScheduleViewModel) 
    ↓
Service Protocol (GoogleCalendarServiceProtocol)
    ↓
Implementation (GoogleCalendarService - placeholder)
```

## Current Setup

### Files Created

1. **GoogleCalendarService.swift** - Service interface and placeholder implementation
2. **CalendarConverter.swift** - Utility to convert Room8 models to Google Calendar events
3. **Updated ChoreScheduleViewModel** - Added calendar sync methods
4. **Updated ChoresView** - Added sync UI and button

### Key Components

#### GoogleCalendarServiceProtocol
Defines the interface for all calendar operations:
- `authorize()` - Handle Google Sign-In and Calendar API auth
- `createEvent()` - Create calendar events
- `updateEvent()` - Update existing events
- `deleteEvent()` - Remove events
- `fetchEvents()` - Retrieve calendar events
- `isAuthorized()` - Check auth status

#### CalendarEvent Model
Represents a calendar event with Room8 metadata:
```swift
struct CalendarEvent {
    let id: String?
    var title: String
    var description: String?
    var startDate: Date
    var endDate: Date
    var reminder: Int?
    var attendees: [String]?
    var recurrence: CalendarRecurrence?
    var choreId: UUID?  // Link back to Room8 chore
    var roommateId: UUID?  // Link to roommate
}
```

#### CalendarConverter Utility
Converts Room8 data to calendar format:
- `choreToCalendarEvent()` - Single chore to event
- `choreToRecurrence()` - Map chore frequency to calendar recurrence
- `choresToCalendarEvents()` - Batch conversion

### ViewModel Integration Methods

New methods added to `ChoreScheduleViewModel`:

```swift
// Authorization
func authorizeGoogleCalendar(completion: @escaping (Bool) -> Void)
func isGoogleCalendarAuthorized() -> Bool

// Syncing
func syncChoresToCalendar(completion: @escaping (Bool) -> Void)
func updateChoreInCalendar(_ chore: Chore, completion: @escaping (Bool) -> Void)
func removeChoreFromCalendar(_ choreId: UUID, completion: @escaping (Bool) -> Void)
func markChoreCompleteAndUpdateCalendar(_ choreId: UUID, by roommateId: UUID, notes: String?)

// Published properties for UI
@Published var isCalendarSynced: Bool
@Published var calendarsyncInProgress: Bool
```

## Integration Steps (When API Branch is Ready)

### Step 1: Merge API Branch
```bash
git merge google-calendar-api
```

### Step 2: Install Google Calendar SDK
Add to your Xcode project:
```
CocoaPods: pod 'GoogleAPIClientForREST/Calendar'
SPM: GoogleAPIClientForSwift package
```

### Step 3: Implement GoogleCalendarService
Update `GoogleCalendarService.swift`:

```swift
class GoogleCalendarService: GoogleCalendarServiceProtocol {
    private var calendarService: GTLRCalendarService?
    
    func authorize(completion: @escaping (Bool, Error?) -> Void) {
        // Use GIDSignIn.sharedInstance to authorize
        // Set calendarService scopes
        completion(success, error)
    }
    
    func createEvent(_ event: CalendarEvent, completion: @escaping (Bool, String?, Error?) -> Void) {
        // Convert CalendarEvent to GTLRCalendar_Event
        // Call calendarService.executeQuery()
        // Parse response and get event ID
        completion(success, eventId, error)
    }
    
    // Implement remaining methods similarly...
}
```

### Step 4: Add GoogleSignIn Configuration
In your `Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

### Step 5: Update Room8App to Initialize Auth
```swift
@main
struct Room8App: App {
    init() {
        // Initialize Google Sign-In
        GIDSignIn.sharedInstance.restorePreviousSignIn()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Step 6: Store Calendar Event IDs
Consider extending the `Chore` model to store Google Calendar event IDs:

```swift
struct Chore: Identifiable, Codable {
    // ... existing fields
    var googleCalendarEventId: String?  // Add this
}
```

This allows for easier updates and deletion of events later.

## Data Flow

### Creating a Chore and Syncing
1. User creates chore in ChoresView
2. `addChore()` saves to local storage
3. If calendar synced, optionally auto-sync or show sync prompt
4. `syncChoresToCalendar()` converts chore to CalendarEvent
5. GoogleCalendarService creates event in user's Google Calendar
6. Event ID stored in Room8 (optional)

### Updating a Chore
1. User edits chore details
2. `updateChore()` updates local storage
3. `updateChoreInCalendar()` updates Google Calendar event
4. If frequency changed, recurrence updated

### Completing a Chore
1. User marks chore complete
2. `completeChore()` records completion
3. Auto-update calendar event status (optional)
4. Event marked as complete or reminder cleared

### Deleting a Chore
1. User deletes chore
2. `deleteChore()` removes from storage
3. `removeChoreFromCalendar()` deletes Google Calendar event

## Important Considerations

### Authentication
- Handle token refresh automatically
- Use secure storage for tokens
- Implement graceful fallback if disconnected

### Recurrence Mapping
Current mapping in CalendarConverter:
- Room8 "Daily" → Google Calendar "DAILY"
- Room8 "Weekly" → Google Calendar "WEEKLY"
- Room8 "Bi-weekly" → Google Calendar "WEEKLY" (count=2)
- Room8 "Monthly" → Google Calendar "MONTHLY"
- Room8 "As Needed" → No recurrence

### Error Handling
The ViewModel publishes `errorMessage` for UI:
```swift
@Published var errorMessage: String?
```

Display errors in GoogleCalendarSyncView via:
```swift
if let error = viewModel.errorMessage {
    // Show error message
}
```

### Permissions
Required Google Calendar API scopes:
- `https://www.googleapis.com/auth/calendar` - Full calendar access

## Testing

### Mock Implementation
GoogleCalendarService currently logs operations:
```swift
print("Creating calendar event: \(event.title)")
```

### Unit Tests
Consider testing:
- Chore to CalendarEvent conversion
- Recurrence mapping
- Error handling
- Authorization flow

### Integration Tests
Once implemented:
- Test creating events in Google Calendar
- Test updating events
- Test authorization flow
- Test offline scenarios

## Troubleshooting

### "Not authorized with Google Calendar"
- User must tap "Authorize Google Calendar" button
- Check Google Sign-In configuration
- Verify API credentials in Google Cloud Console

### Events not appearing in calendar
- Check calendar API enabled in Google Cloud Console
- Verify scopes include calendar.insert
- Check date/time formatting

### Recurrence not working
- Verify RecurrenceType enum matches Google Calendar RRULE format
- Check until/count dates are valid
- Timezone handling may affect dates

## Future Enhancements

1. **Two-way sync** - Pull events from calendar back to Room8
2. **Calendar selection** - Let users choose which calendar to sync to
3. **Conflict detection** - Warn if time slots conflict
4. **Event templates** - Predefined event types (cleaning supply, laundry, etc.)
5. **Smart reminders** - Integration with mobile notifications
6. **Analytics** - Track completion rates over time
7. **Sharing** - Share calendar with other roommates

## Branch Merge Checklist

- [ ] API branch code reviewed
- [ ] GoogleCalendarService implementation complete
- [ ] Google Cloud Console credentials configured
- [ ] Info.plist updated with Google URL scheme
- [ ] Pods/packages installed
- [ ] Authorization flow tested
- [ ] Create/update/delete events tested
- [ ] Error handling verified
- [ ] UI integrated and tested
