// Kevin Li - 10:54 PM - 6/6/20

import SwiftUI

struct WeekView: View {

    @EnvironmentObject var weekManager: WeekCalendarManager

    var body: some View {
        HStack(spacing: CalendarConstants.gridSpacing) {
            ForEach(weekManager.days, id: \.self) { day in
                DayView()
                    .environmentObject(self.weekManager.createDayManager(for: day))
            }
        }
    }

}

class WeekCalendarManager: ObservableObject, CalendarConfigurationDirectAccess {

    let configuration: CalendarConfiguration
    let week: Date

    init(configuration: CalendarConfiguration, week: Date) {
        self.configuration = configuration
        self.week = week
    }

    var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else {
            return []
        }
        return generateDates(
            inside: weekInterval,
            matching: .everyDay)
    }

    func createDayManager(for day: Date) -> DayCalendarManager {
        DayCalendarManager(configuration: configuration, week: week, date: day)
    }

}

private extension DateComponents {

    static var everyDay: DateComponents {
        DateComponents(hour: 0, minute: 0, second: 0)
    }

}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DarkThemePreview {
                WeekView()
                    .environmentObject(
                        WeekCalendarManager(
                            configuration: .mock,
                            week: Date().addingTimeInterval(-60*60*24*7)
                        )
                    )
            }

            DarkThemePreview {
                WeekView()
                    .environmentObject(
                        WeekCalendarManager(
                            configuration: .mock,
                            week: Date()
                        )
                    )
            }
        }
    }
}
