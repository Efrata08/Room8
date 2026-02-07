# Room8 iOS App - Setup Guide

## How to Run the App

### Option 1: Create Xcode Project (Recommended)

1. **Open Xcode**
2. **File → New → Project**
3. Choose **iOS → App**
4. Settings:
   - Product Name: `Room8`
   - Team: (your Apple ID)
   - Organization Identifier: `com.yourname.room8`
   - Interface: **SwiftUI**
   - Language: **Swift**
5. Save it in `/Users/kashafbatool/Room8/`
6. **Drag these folders** into your Xcode project:
   - `Room8App/Models`
   - `Room8App/Services`
   - `Room8App/ViewModels`
   - `Room8App/Views`
   - `Room8App/MockData`
7. **Replace** the auto-generated `Room8App.swift` with `Room8App/Room8App.swift`
8. **Build and Run!** (⌘R)

### Option 2: Quick Command Line Setup

```bash
# Install Xcode command line tools first
xcode-select --install

# Then I can help you generate the .xcodeproj file
```

---

## What You Built

### ✅ Complete Expense Tracking Feature

**Views:**
- **ExpenseListView** - Main list of all expenses with totals
- **AddExpenseView** - Form to add new expenses
- **BalanceView** - See who owes who money
- **ExpenseDetailView** - Detailed view of each expense

**Features:**
- ✅ Add/Edit/Delete expenses
- ✅ Split bills between roommates
- ✅ Calculate who owes who
- ✅ Category tracking (groceries, utilities, rent, etc.)
- ✅ Running totals and balances
- ✅ Beautiful UI with icons and colors

**Mock Data:**
- 4 sample roommates (You, Sarah, Mike, Emma)
- 8 sample expenses
- Realistic household scenario

---

## Demo Flow

1. **Launch app** → See expense list with totals
2. **Tap "View Balances"** → See who owes money
3. **Tap "+"** → Add a new expense
4. **Tap any expense** → See details and delete

---

## Next Steps

### When API is Ready:
1. Change `useMockData: true` to `useMockData: false` in ExpenseListView.swift
2. Update `baseURL` in APIClient.swift to your friend's API endpoint
3. Done! The app will switch from mock data to real API

### To Add More Features:
- Chore tracking views (use same pattern as expenses)
- Calendar/schedule views
- User profile & authentication screens
- Push notifications when roommates add expenses

---

## Project Structure

```
Room8App/
├── Room8App.swift          # Main app entry point
├── Models/                 # Data structures
│   ├── User.swift
│   ├── Household.swift
│   ├── Expense.swift
│   ├── Chore.swift
│   └── ScheduleEvent.swift
├── Services/               # API layer (ready for backend)
│   ├── APIClient.swift
│   ├── AuthService.swift
│   ├── ExpenseService.swift
│   ├── ChoreService.swift
│   └── HouseholdService.swift
├── ViewModels/             # Business logic
│   └── ExpenseViewModel.swift
├── Views/                  # UI screens
│   ├── ExpenseListView.swift
│   ├── AddExpenseView.swift
│   ├── BalanceView.swift
│   └── ExpenseDetailView.swift
└── MockData/               # Test data
    └── MockData.swift
```

---

## Tips

- The app uses **mock data** by default, so you can demo it without the backend
- All the **API service code is ready** - just needs your friend's endpoints
- **SwiftUI previews** work for all views (click the preview button in Xcode)
- To test on your phone, connect it and select it as the run destination

---

Happy coding! 🚀
