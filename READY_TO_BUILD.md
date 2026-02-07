# Room8 Build Checklist ✅

## Project Files Status

All required files are in place and ready to build!

### ✅ Models (3 files)
- [Chore.swift](Room8/Models/Chore.swift) - Core chore data model with frequency and priority
- [Roommate.swift](Room8/Models/Roommate.swift) - Roommate profiles
- [ChoreCompletion.swift](Room8/Models/ChoreCompletion.swift) - Completion tracking

### ✅ ViewModels (1 file)
- [ChoreScheduleViewModel.swift](Room8/ViewModels/ChoreScheduleViewModel.swift) - Business logic and state management (with Google Calendar integration)

### ✅ Views (5 files)
- [ContentView.swift](Room8/Views/ContentView.swift) - Main app container with tabs
- [ChoresView.swift](Room8/Views/ChoresView.swift) - Chore list with filtering and sync button
- [AddChoreView.swift](Room8/Views/AddChoreView.swift) - Create new chores
- [ChoreDetailView.swift](Room8/Views/ChoreDetailView.swift) - View, edit, and delete chores
- [RoommatesView.swift](Room8/Views/RoommatesView.swift) - Manage roommates

### ✅ Utilities (3 files)
- [StorageService.swift](Room8/Utilities/StorageService.swift) - Local data persistence
- [GoogleCalendarService.swift](Room8/Utilities/GoogleCalendarService.swift) - Calendar API integration layer
- [CalendarConverter.swift](Room8/Utilities/CalendarConverter.swift) - Model conversion utilities

### ✅ App Entry Point (1 file)
- [Room8App.swift](Room8/Room8App.swift) - SwiftUI app delegate

### ✅ Configuration Files
- [Info.plist](Room8/Info.plist) - iOS app configuration
- [README.md](README.md) - Project overview
- [CHORE_SCHEDULING_GUIDE.md](CHORE_SCHEDULING_GUIDE.md) - Feature documentation
- [GOOGLE_CALENDAR_INTEGRATION.md](GOOGLE_CALENDAR_INTEGRATION.md) - Calendar integration guide
- [BUILD_GUIDE.md](BUILD_GUIDE.md) - Detailed build instructions

---

## Quick Start (Pick Your Path)

### 🔵 Path A: GUI (Recommended for Most)

1. **Open Xcode** on your Mac
2. **File** → **New** → **Project**
3. Choose **iOS** → **App**
4. Configure:
   - Product Name: `Room8`
   - Interface: **SwiftUI**
   - Lifecycle: **SwiftUI App**
5. **Create** at `c:\Users\fatma\Documents\Room8`
6. Delete auto-generated Swift files (keep Info.plist)
7. Drag all Swift files from this folder into Xcode
8. **Build** (⌘B) then **Run** (⌘R)

### 🟢 Path B: Terminal

From Windows PowerShell or Command Prompt:

```bash
cd c:\Users\fatma\Documents\Room8
xcodebuild -scheme Room8 -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
```

### 🟡 Path C: Swift Playgrounds (Learning/Testing Only)

1. Open Swift Playgrounds on iPad or Mac
2. Create new App
3. Copy code files into the project
4. Press **Run** to test

---

## Pre-Build Checklist

Before you build, verify:

- [ ] **Xcode 14.0+** installed (check **Xcode** → **About Xcode**)
- [ ] **iOS SDK 15.0+** available (in Xcode → Preferences → Platforms)
- [ ] **Internet connection** (downloads might be needed)
- [ ] **At least 5GB free space** on Mac
- [ ] **Swift version 5.5+** (automatic with Xcode 14+)

---

## Build Steps

### Step 1: Create Project (One-Time Setup)
```
File → New → Project
→ iOS → App
→ Configure (see above)
→ Create
```

### Step 2: Add Swift Files
1. In Xcode, right-click empty project area
2. "Add Files to Room8..."
3. Navigate to `Room8/Models`, `Room8/Views`, etc.
4. Select all `.swift` files
5. **Copy items if needed** (checked)
6. **Add to targets** (Room8 checked)
7. Click **Add**

### Step 3: Verify Build Target

For each Swift file:
1. Select file in Xcode
2. **Inspectors** (right panel)
3. Under "Target Membership" → check **Room8**

### Step 4: Build
- Press **⌘B** (or **Product** → **Build**)
- Wait for completion (first build takes longer)
- Check for **red errors** (fix them), **yellow warnings** (can ignore)

### Step 5: Run
- Select simulator: **Room8** → dropdown → pick **iPhone 15 Pro** (or any device)
- Press **⌘R** (or **Product** → **Run**)
- App launches in simulator

---

## Features Ready to Test

Once you build and run:

✅ **Create Chores**
- Tap **+** button
- Fill in name, frequency, priority, time estimate
- Assign to roommate
- Tap **Save**

✅ **Manage Roommates**
- Go to **Roommates** tab
- Tap **+** to add
- See how many chores assigned

✅ **View & Filter Chores**
- **All** - See all chores
- **Overdue** - Show past-due chores
- **Due Today** - Show today's chores
- **Unassigned** - Show chores needing assignment

✅ **Edit & Delete**
- Tap a chore to view details
- **Edit Button** to modify
- **Delete** to remove

✅ **Mark Complete**
- Open chore details
- **Mark as Complete** button
- Tracks when finished

✅ **Google Calendar Setup** (UI ready, API pending)
- Tap **Setup** button in Chores view
- **Authorize Google Calendar** (waits for API implementation)
- **Sync** button appears when authorized

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| **"Module 'SwiftUI' not found"** | Select valid iOS simulator (not "Any iOS Device") |
| **"File not in build target"** | Select file → Inspectors (⌘⌥1) → Check "Room8" under Target Membership |
| **Build fails with syntax errors** | Check Xcode version is 14.0+, update if needed |
| **Previews not showing** | Click **Editor** → **Canvas** |
| **"Cannot find 'View' in scope"** | Make sure `import SwiftUI` is at top of each file |
| **Build hangs or freezes** | Stop (⌘.) and try again, or restart Xcode |

---

## After First Build

### Test the App
1. Add 2-3 roommates in **Roommates** tab
2. Add 5-10 sample chores in **Chores** tab
3. Assign chores to roommates
4. Mark some complete
5. Filter by Due Today, Overdue, Unassigned

### Connect Google Calendar (When Ready)
1. Follow [GOOGLE_CALENDAR_INTEGRATION.md](GOOGLE_CALENDAR_INTEGRATION.md)
2. Merge your `google-calendar-api` branch
3. Implement `GoogleCalendarService` with real API calls
4. Test full sync flow

### Next Features (Optional)
- Push notifications for due chores
- Chore statistics & charts
- Cloud backup (Firebase/CloudKit)
- Recurring chore rotation
- Financial tracking integration

---

## Common Commands

```bash
# Build only (no run)
xcodebuild -scheme Room8 build

# Build and run on simulator
xcodebuild -scheme Room8 build run

# Run specific simulator
xcodebuild -scheme Room8 -destination 'platform=iOS Simulator,name=iPhone 15 Pro' run

# Clean build folder
xcodebuild clean

# Show build settings
xcodebuild -showBuildSettings
```

---

## Ask for Help If:

- ❌ Build fails with errors you don't understand
- ❌ App crashes on startup
- ❌ Can't see SwiftUI Preview
- ❌ Need special configuration (team signing, etc.)
- ❌ Want to add additional features

---

**Ready to build? Follow Path A (GUI) above and you should be running in 5-10 minutes!** 🚀

---

Last Updated: February 7, 2026
Room8 Version: 1.0
