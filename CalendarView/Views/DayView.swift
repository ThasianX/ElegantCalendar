// Kevin Li - 11:30 PM - 6/6/20

import SwiftUI

struct DayView: View {

    @Environment(\.appTheme) var appTheme: AppTheme
    @EnvironmentObject var dayManager: DayCalendarManager

    var body: some View {
        Text(dayManager.day)
            .font(.subheadline)
            .foregroundColor(foregroundColor)
            .frame(width: CalendarConstants.dayWidth, height: CalendarConstants.dayWidth)
            .background(backgroundColor)
            .clipShape(Circle())
            .opacity(opacity)
    }

    private var backgroundColor: Color {
        if dayManager.isInToday {
            return .white
        } else if dayManager.isWithinDateRange && dayManager.isWithinCurrentMonth {
            return appTheme.primary
        } else {
            return .clear
        }
    }

    var foregroundColor: Color {
        if dayManager.isInToday {
            return .black
        } else {
            return .white
        }
    }

    // TOOD: Add visits later on and base the background color opacity off that
    private var opacity: Double {
        dayManager.isWithinDateRange && dayManager.isWithinCurrentMonth ? 1 : 0.15
    }

}

class DayCalendarManager: ObservableObject, CalendarConfigurationDirectAccess {

    let configuration: CalendarConfiguration
    let week: Date
    let date: Date

    init(configuration: CalendarConfiguration, week: Date, date: Date) {
        self.configuration = configuration
        self.week = week
        self.date = date
    }

    var day: String {
        String(calendar.component(.day, from: date))
    }

    var isWithinDateRange: Bool {
        date >= calendar.startOfDay(for: startDate) && date <= endDate
    }

    var isWithinCurrentMonth: Bool {
        calendar.isDate(week, equalTo: date, toGranularity: .month)
    }

    var isInToday: Bool {
        calendar.isDateInToday(date)
    }

}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DarkThemePreview {
                DayView()
                    .environmentObject(
                        DayCalendarManager(
                            configuration: .mock,
                            week: Date(),
                            date: Date()
                        )
                    )
            }

            DarkThemePreview {
                DayView()
                    .environmentObject(
                        DayCalendarManager(
                            configuration: .mock,
                            week: Date(),
                            date: Date().addingTimeInterval(60*60*24*3)
                        )
                    )
            }
        }
    }
}
