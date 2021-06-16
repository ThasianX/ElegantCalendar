// Kevin Li - 10:53 PM - 6/6/20

import SwiftUI

struct MonthView<HeaderView: View>: View, MonthlyCalendarManagerDirectAccess {

    @Environment(\.calendarTheme) var theme: CalendarTheme

    @ObservedObject var calendarManager: MonthlyCalendarManager

    let month: Date
    let headerView: () -> HeaderView

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

    var body: some View {
        VStack(spacing: 0) {            
            VStack {
                headerView()
                monthYearHeader
                    .padding(.leading, CalendarConstants.Monthly.outerHorizontalPadding)
                    .onTapGesture { self.communicator?.showYearlyView() }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                weeksViewWithDaysOfWeekHeader
            }
            
            if selectedDate != nil {
                calenderAccessoryView
                    .padding(.leading, CalendarConstants.Monthly.outerHorizontalPadding)
                    .id(selectedDate!)
            }
            Spacer()
        }
        .frame(width: CalendarConstants.Monthly.cellWidth, height: CalendarConstants.cellHeight)
        .background(Color.gray)
    }

}

private extension MonthView {
    
    var monthYearHeader: some View {
        HStack {
            monthText
            yearText
            Image(systemName: "chevron.down")
        }
        .font(.system(size: 26))
        .opacity(isWithinSameMonthAndYearAsToday ? 1 : 0.5)
    }
    
    var monthText: some View {
        Text(month.fullMonth.uppercased())
            .bold()
    }
    
    var yearText: some View {
        Text(month.year)
            .bold()
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
            ForEach(calendar.dayOfWeekInitials, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(.caption)
                    .bold()
                    .frame(width: CalendarConstants.Monthly.dayWidth)
                    .foregroundColor(.black)
            }
        }
    }

    var weeksViewStack: some View {
        VStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(weeks, id: \.self) { week in
                WeekView(calendarManager: self.calendarManager, week: week)
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
                self.datasource?.calendar(viewForSelectedDate: self.selectedDate!,
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
