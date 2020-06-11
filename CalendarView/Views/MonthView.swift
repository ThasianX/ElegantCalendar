// Kevin Li - 10:53 PM - 6/6/20

import SwiftUI

fileprivate let daysOfWeekInitials = ["S", "M", "T", "W", "T", "F", "S"]

struct MonthView: View, CalendarManagerDirectAccess {

    @Environment(\.appTheme) var appTheme: AppTheme
    
    @EnvironmentObject var calendarManager: CalendarManager

    let month: Date

    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        return generateDates(
            inside: monthInterval,
            matching: calendar.firstDayOfEveryWeek)
    }

    var monthString: String {
        month.fullMonth
    }

    var yearString: String {
        month.year
    }

    var isWithinSameMonthAndYearAsToday: Bool {
        calendar.isDate(month, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        VStack(spacing: 40) {
            header
                .padding(.leading, CalendarConstants.horizontalPadding)
            weekViewWithHeader
            Spacer()
        }
        .padding(.top, CalendarConstants.topPadding)
        .frame(height: CalendarConstants.cellHeight)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(monthString.uppercased())
                    .font(.title)
                    .bold()
                    .tracking(5)
                    .foregroundColor(isWithinSameMonthAndYearAsToday ? appTheme.primary : .white)
                Text(yearString)
                    .font(.caption)
                    .tracking(2)
                    .foregroundColor(isWithinSameMonthAndYearAsToday ? appTheme.complementary : .gray)
                    .opacity(0.7)
            }
            Spacer()
        }
    }

    private var weekViewWithHeader: some View {
        VStack(spacing: 32) {
            daysOfWeekHeader
            weekViewStack
        }
    }

    private var daysOfWeekHeader: some View {
        HStack(spacing: CalendarConstants.gridSpacing) {
            ForEach(daysOfWeekInitials, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(.caption)
                    .frame(width: CalendarConstants.dayWidth)
                    .foregroundColor(.gray)
            }
        }
    }

    private var weekViewStack: some View {
        VStack(spacing: CalendarConstants.gridSpacing) {
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week)
            }
        }
    }

}

private extension Calendar {

    var firstDayOfEveryWeek: DateComponents {
        DateComponents(hour: 0, minute: 0, second: 0, weekday: firstWeekday)
    }

}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarManagerGroup {
            DarkThemePreview {
                MonthView(month: Date())
            }

            DarkThemePreview {
                MonthView(month: Date().addingTimeInterval(60*60*24*45))
            }
        }
    }
}
