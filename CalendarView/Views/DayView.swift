// Kevin Li - 11:30 PM - 6/6/20

import SwiftUI

struct DayView: View, CalendarManagerDirectAccess {

    @Environment(\.appTheme) var appTheme: AppTheme

    @EnvironmentObject var calendarManager: CalendarManager

    let week: Date
    let day: Date

    private var isDayWithinDateRange: Bool {
        day >= calendar.startOfDay(for: startDate) && day <= endDate
    }

    private var isDayWithinWeekMonthAndYear: Bool {
        calendar.isDate(week, equalTo: day, toGranularities: [.month, .year])
    }

    private var isDayToday: Bool {
        calendar.isDateInToday(day)
    }

    var body: some View {
        Text(numericDay)
            .font(.subheadline)
            .foregroundColor(foregroundColor)
            .frame(width: CalendarConstants.dayWidth, height: CalendarConstants.dayWidth)
            .background(backgroundColor)
            .clipShape(Circle())
            .opacity(opacity)
    }

    private var numericDay: String {
        String(calendar.component(.day, from: day))
    }

    private var foregroundColor: Color {
        if isDayToday {
            return .black
        } else {
            return .white
        }
    }

    private var backgroundColor: Color {
        if isDayToday {
            return .white
        } else if isDayWithinDateRange && isDayWithinWeekMonthAndYear {
            return appTheme.primary
        } else {
            return .clear
        }
    }

    // TOOD: Add opacity configuration later on and base the background color opacity off that
    private var opacity: Double {
        isDayWithinDateRange && isDayWithinWeekMonthAndYear ? 1 : 0.15
    }

}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarManagerGroup {
            DarkThemePreview {
                DayView(week: Date(), day: Date())
            }

            DarkThemePreview {
                DayView(week: Date(), day: Date().addingTimeInterval(60*60*24*3))
            }
        }
    }
}
