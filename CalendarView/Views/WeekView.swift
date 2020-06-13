// Kevin Li - 10:54 PM - 6/6/20

import SwiftUI

struct WeekView: View, CalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: ElegantCalendarManager

    let week: Date

    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else {
            return []
        }
        return generateDates(
            inside: weekInterval,
            matching: .everyDay)
    }

    var body: some View {
        HStack(spacing: CalendarConstants.gridSpacing) {
            ForEach(days, id: \.self) { day in
                DayView(week: self.week, day: day)
            }
        }
    }

}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarManagerGroup {
            DarkThemePreview {
                WeekView(week: Date())
            }

            DarkThemePreview {
                WeekView(week: .daysFromToday(-7))
            }
        }
    }
}
