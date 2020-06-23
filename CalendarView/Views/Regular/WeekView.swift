// Kevin Li - 10:54 PM - 6/6/20

import SwiftUI

struct WeekView: View, MonthlyCalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: MonthlyCalendarManager

    let week: Date

    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else {
            return []
        }
        return calendar.generateDates(
            inside: weekInterval,
            matching: .everyDay)
    }

    var body: some View {
        HStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(days, id: \.self) { day in
                DayView(week: self.week, day: day)
            }
        }
    }

}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyCalendarManagerGroup {

            LightThemePreview {
                WeekView(week: Date())

                WeekView(week: .daysFromToday(-7))
            }

            DarkThemePreview {
                WeekView(week: Date())

                WeekView(week: .daysFromToday(-7))
            }

        }
    }
}
