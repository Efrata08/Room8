# Quick Build Guide for Room8

## Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later deployment target
- macOS 12.0 or later

## Option 1: Create New iOS Project in Xcode (Recommended)

### Step 1: Create New Project
1. Open **Xcode**
2. Click **File** → **New** → **Project**
3. Select **iOS** → **App**
4. Configure:
   - **Product Name**: `Room8`
   - **Team**: Your Apple Team (or None)
   - **Organization Identifier**: `com.yourcompany` (e.g., `com.room8`)
   - **Bundle Identifier**: auto-fills as `com.yourcompany.Room8`
   - **Interface**: **SwiftUI**
   - **Lifecycle**: **SwiftUI App**
   - **Language**: **Swift**
   - **☐ Use Core Data** (leave unchecked)
   - **☐ Include Tests** (optional)
5. Select location: `c:\Users\fatma\Documents\Room8`
6. Click **Create**

### Step 2: Copy Swift Files
1. Delete the auto-generated `ContentView.swift` and `Room8App.swift`
2. Copy all Swift files from this repository to your Xcode project:
   - **Models/** (Chore.swift, Roommate.swift, ChoreCompletion.swift)
   - **ViewModels/** (ChoreScheduleViewModel.swift)
   - **Views/** (ContentView.swift, ChoresView.swift, AddChoreView.swift, ChoreDetailView.swift, RoommatesView.swift)
   - **Utilities/** (StorageService.swift, GoogleCalendarService.swift, CalendarConverter.swift)
   - **Room8App.swift**

### Step 3: Copy Info.plist
Replace your auto-generated Info.plist with the one provided:
- `Info.plist` (in Room8/Room8 folder)

### Step 4: Build & Run
1. Select a simulator:
   - **Product** → **Destination** → Pick iPhone 15 Pro or any iOS device
2. Build: **⌘B** (Command+B)
3. Run: **⌘R** (Command+R) or click the play button

---

## Option 2: Use XCProj (If you want to automate)

If you want to create the project programmatically:

```bash
cd c:\Users\fatma\Documents\Room8
xcdgen  # If using rules_apple (Bazel)
```

---

## Project Structure in Xcode

After setup, your Xcode project should look like:

```
Room8/ (project root)
├── Room8.xcodeproj
├── Room8/
│   ├── Room8App.swift
│   ├── Models/
│   │   ├── Chore.swift
│   │   ├── Roommate.swift
│   │   └── ChoreCompletion.swift
│   ├── ViewModels/
│   │   └── ChoreScheduleViewModel.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── ChoresView.swift
│   │   ├── AddChoreView.swift
│   │   ├── ChoreDetailView.swift
│   │   └── RoommatesView.swift
│   ├── Utilities/
│   │   ├── StorageService.swift
│   │   ├── GoogleCalendarService.swift
│   │   └── CalendarConverter.swift
│   ├── Info.plist
│   └── Assets.xcassets
└── Room8Tests/ (optional)
```

---

## First Build Checklist

- [ ] Xcode 14.0+ installed
- [ ] All Swift files copied to correct folders
- [ ] Info.plist in place
- [ ] **Build Settings** → Deployment Target set to iOS 15.0+
- [ ] **Build Phases** → All Swift files in "Compile Sources"
- [ ] No red build errors (warnings are OK)
- [ ] Simulator selected (not "Any iOS Device")
- [ ] Project builds successfully (**⌘B**)
- [ ] App runs in simulator (**⌘R**)

---

## Troubleshooting

### "Module not found" errors
- Make sure all Swift files are in the correct folder structure
- Check that files are added to the Build Target:
  - Select file
  - **File Inspector** (⌘⌥1) 
  - Check **Room8** under "Target Membership"

### Build fails with syntax errors
- Ensure you're using Swift 5.5+ (Xcode 14+)
- Check that all imported modules exist (Foundation, SwiftUI)

### SwiftUI previews not working
- Click **Editor** → **Canvas** in Xcode
- Select **Resume** if showing "Loading..."

### App crashes on startup
- Check Console output (**View** → **Debug Area** → **Show Console**)
- Verify `Room8App.swift` has `@main` attribute

---

## Next Steps After Building

1. **Run on Simulator**: Test all chore features
2. **Add Test Data**: Create roommates, then chores
3. **Test Filtering**: Try All/Overdue/Due Today/Unassigned
4. **Mark Chores Complete**: Test completion tracking
5. **Prepare for Google Calendar**: See `GOOGLE_CALENDAR_INTEGRATION.md`

---

## Build Commands (from Terminal)

```bash
# Build for simulator
xcodebuild -scheme Room8 -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Run tests
xcodebuild test -scheme Room8

# Archive for distribution
xcodebuild -scheme Room8 -configuration Release archive
```

---

## Additional Resources

- **SwiftUI Documentation**: https://developer.apple.com/tutorials/swiftui
- **Apple Frameworks**: Foundation, SwiftUI (already included)
- **Google Calendar API**: See `GOOGLE_CALENDAR_INTEGRATION.md`

Good luck building! 🚀
