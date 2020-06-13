// Kevin Li - 10:53 PM - 6/6/20

import SwiftUI

fileprivate let daysOfWeekInitials = ["S", "M", "T", "W", "T", "F", "S"]

struct MonthView: View, CalendarManagerDirectAccess {
    
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

    private var isWithinSameMonthAndYearAsToday: Bool {
        calendar.isDate(month, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        VStack(spacing: 40) {
            monthYearHeader
                .padding(.leading, CalendarConstants.horizontalPadding)
            weeksViewWithDaysOfWeekHeader
            Spacer()
        }
        .padding(.top, CalendarConstants.topPadding)
        .frame(width: CalendarConstants.cellWidth, height: CalendarConstants.cellHeight)
    }

}

private extension MonthView {

    var monthYearHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                monthText
                yearText
            }
            Spacer()
        }
    }

    var monthText: some View {
        Text(month.fullMonth.uppercased())
            .font(.title)
            .bold()
            .tracking(6)
            .foregroundColor(isWithinSameMonthAndYearAsToday ? themeColor : .white)
    }

    var yearText: some View {
        Text(month.year)
            .font(.caption)
            .tracking(2)
            .foregroundColor(isWithinSameMonthAndYearAsToday ? themeColor : .gray)
            .opacity(0.8)
    }

}

private extension MonthView {

    var weeksViewWithDaysOfWeekHeader: some View {
        VStack(spacing: 32) {
            daysOfWeekHeader
            weeksViewStack
        }
    }

    var daysOfWeekHeader: some View {
        HStack(spacing: CalendarConstants.gridSpacing) {
            ForEach(daysOfWeekInitials, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(.caption)
                    .frame(width: CalendarConstants.dayWidth)
                    .foregroundColor(.gray)
            }
        }
    }

    var weeksViewStack: some View {
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
