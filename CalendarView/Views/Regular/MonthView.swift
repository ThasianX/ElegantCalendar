// Kevin Li - 10:53 PM - 6/6/20

import SwiftUI

fileprivate let daysOfWeekInitials = ["S", "M", "T", "W", "T", "F", "S"]

struct MonthView: View, MonthlyCalendarManagerDirectAccess {
    
    @EnvironmentObject var calendarManager: MonthlyCalendarManager

    let month: Date

    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        return calendar.generateDates(
            inside: monthInterval,
            matching: calendar.firstDayOfEveryWeek)
    }

    private var isWithinSameMonthAndYearAsToday: Bool {
        calendar.isDate(month, equalTo: Date(), toGranularities: [.month, .year])
    }

    private var isWithinSameMonthAndYearAsSelectedDate: Bool {
        guard let selectedDate = selectedDate else { return false }
        return calendar.isDate(month, equalTo: selectedDate, toGranularities: [.month, .year])
    }

    var body: some View {
        VStack(spacing: 40) {
            monthYearHeader
                .padding(.leading, CalendarConstants.horizontalPadding)
                .onTapGesture { self.parent?.showYearlyView() }
            weeksViewWithDaysOfWeekHeader
            if isWithinSameMonthAndYearAsSelectedDate {
                calenderAccessoryView
                    .padding(.leading, CalendarConstants.horizontalPadding)
                    .id(selectedDate!)
            }
            Spacer()
        }
        .padding(.top, CalendarConstants.Monthly.topPadding)
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
            .foregroundColor(isWithinSameMonthAndYearAsToday ? themeColor : .primary)
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
        HStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(daysOfWeekInitials, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(.caption)
                    .frame(width: CalendarConstants.Monthly.dayWidth)
                    .foregroundColor(.gray)
            }
        }
    }

    var weeksViewStack: some View {
        VStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week)
            }
        }
    }

}

private extension MonthView {

    var calenderAccessoryView: some View {
        CalendarAccessoryView(calendarManager: calendarManager)
    }

}

private struct CalendarAccessoryView: View, MonthlyCalendarManagerDirectAccess {

    let calendarManager: MonthlyCalendarManager

    @State private var isVisible = false

    private var numberOfDaysFromTodayToSelectedDate: Int {
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfSelectedDate = calendar.startOfDay(for: selectedDate!)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfSelectedDate).day!
    }

    private var isNotYesterdayTodayOrTomorrow: Bool {
        abs(numberOfDaysFromTodayToSelectedDate) > 1
    }

    var body: some View {
        VStack {
            selectedDayInformationView
            GeometryReader { geometry in
                self.datasource?.calendar(viewForSelectedDay: self.selectedDate!,
                                          dimensions: geometry.size)
            }
        }
        .onAppear(perform: makeVisible)
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.5))
    }

    private func makeVisible() {
        isVisible = true
    }

    private var selectedDayInformationView: some View {
        HStack {
            VStack(alignment: .leading) {
                dayOfWeekWithMonthAndDayText
                if isNotYesterdayTodayOrTomorrow {
                    daysFromTodayText
                }
            }
            Spacer()
        }
    }

    private var dayOfWeekWithMonthAndDayText: some View {
        let monthDayText: String
        if numberOfDaysFromTodayToSelectedDate == -1 {
            monthDayText = "Yesterday"
        } else if numberOfDaysFromTodayToSelectedDate == 0 {
            monthDayText = "Today"
        } else if numberOfDaysFromTodayToSelectedDate == 1 {
            monthDayText = "Tomorrow"
        } else {
            monthDayText = selectedDate!.dayOfWeekWithMonthAndDay
        }

        return Text(monthDayText.uppercased())
            .font(.subheadline)
            .bold()
    }

    private var daysFromTodayText: some View {
        let isBeforeToday = numberOfDaysFromTodayToSelectedDate < 0
        let daysDescription = isBeforeToday ? "DAYS AGO" : "DAYS FROM TODAY"

        return Text("\(abs(numberOfDaysFromTodayToSelectedDate)) \(daysDescription)")
            .font(.system(size: 10))
            .foregroundColor(.gray)
    }

}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyCalendarManagerGroup {
            DarkThemePreview {
                MonthView(month: Date())
            }

            DarkThemePreview {
                MonthView(month: .daysFromToday(45))
            }
        }
    }
}
