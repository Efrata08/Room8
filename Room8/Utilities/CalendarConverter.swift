import Foundation

// MARK: - Calendar Converter Utility
class CalendarConverter {
    
    // MARK: - Convert Chore to Calendar Event
    static func choreToCalendarEvent(
        chore: Chore,
        roommate: Roommate?
    ) -> CalendarEvent {
        let startDate = chore.lastCompletedDate ?? chore.createdDate
        let endDate = startDate.addingTimeInterval(TimeInterval(chore.estimatedMinutes * 60))
        
        let recurrence = choreToRecurrence(chore.frequency)
        
        return CalendarEvent(
            id: nil, // Will be assigned by Google Calendar
            title: chore.name,
            description: createEventDescription(chore, roommate),
            startDate: startDate,
            endDate: endDate,
            reminder: 15, // 15 minutes before
            attendees: roommate?.email.isEmpty == false ? [roommate!.email] : nil,
            recurrence: recurrence,
            choreId: chore.id,
            roommateId: roommate?.id
        )
    }
    
    // MARK: - Convert Chore Frequency to Calendar Recurrence
    static func choreToRecurrence(_ frequency: ChoreFrequency) -> CalendarRecurrence? {
        switch frequency {
        case .daily:
            return CalendarRecurrence(type: .daily, count: nil, until: nil)
        case .weekly:
            return CalendarRecurrence(type: .weekly, count: nil, until: nil)
        case .biweekly:
            return CalendarRecurrence(type: .biweekly, count: nil, until: nil)
        case .monthly:
            return CalendarRecurrence(type: .monthly, count: nil, until: nil)
        case .asNeeded:
            return nil // No recurrence for "as needed"
        }
    }
    
    // MARK: - Create Event Description
    private static func createEventDescription(
        _ chore: Chore,
        _ roommate: Roommate?
    ) -> String {
        var description = chore.description
        
        if !description.isEmpty {
            description += "\n\n"
        }
        
        description += "Priority: \(chore.priority.rawValue)\n"
        description += "Estimated Time: \(chore.estimatedMinutes) minutes\n"
        
        if let roommate = roommate {
            description += "Assigned to: \(roommate.name)"
        }
        
        return description
    }
    
    // MARK: - Batch Convert Chores to Events
    static func choresToCalendarEvents(
        chores: [Chore],
        roommates: [Roommate]
    ) -> [CalendarEvent] {
        return chores.map { chore in
            let roommate = roommates.first { $0.id == chore.assignedTo }
            return choreToCalendarEvent(chore: chore, roommate: roommate)
        }
    }
}
