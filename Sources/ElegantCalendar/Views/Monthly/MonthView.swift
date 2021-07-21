// Kevin Li - 10:53 PM - 6/6/20

import SwiftUI

struct MonthView: View, MonthlyCalendarManagerDirectAccess {

    @Environment(\.calendarTheme) var theme: CalendarTheme

    @ObservedObject var calendarManager: MonthlyCalendarManager

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

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 25) {
                monthYearHeader
                    .onTapGesture { self.communicator?.showYearlyView() }
                weeksViewWithDaysOfWeekHeader
            }
            .padding(.top, 20)
            .padding(.bottom, 250)
            .background(Color.pampas)
            .readHeight {
                calendarManager.heightMonthCalendar = $0
            }
            
//            if selectedDate != nil {
//                calenderAccessoryView
//                    .padding(.leading, CalendarConstants.Monthly.outerHorizontalPadding)
//                    .id(selectedDate!)
//            }
            Spacer()
        }
        .padding(.top, CalendarConstants.Monthly.topPadding)
        .frame(width: CalendarConstants.Monthly.cellWidth, height: CalendarConstants.cellHeight)
    }

}

private extension MonthView {
    
    var monthYearHeader: some View {
        HStack(alignment: .center, spacing: 4) {
            Spacer()
            monthText
            yearText
            Spacer()
        }
        .font(Font.robotoBold18)
        .foregroundColor(Color.tundora)
    }
    
    var monthText: some View {
        Text(month.fullMonth)
    }
    
    var yearText: some View {
        Text(month.year)
    }

}

private extension MonthView {

    var weeksViewWithDaysOfWeekHeader: some View {
        VStack(spacing: 10) {
            daysOfWeekHeader
            weeksViewStack
        }
    }

    var daysOfWeekHeader: some View {
        HStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(calendar.dayOfWeekInitials, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(Font.robotoBold13)
                    .foregroundColor(Color.dawn)
                    .frame(width: CalendarConstants.Monthly.dayWidth)
            }
        }
    }

    var weeksViewStack: some View {
        VStack(spacing: 12) {
            ForEach(weeks, id: \.self) { week in
                WeekView(calendarManager: self.calendarManager, week: week)
            }
        }
    }

}
/*
private extension MonthView {

    var calenderAccessoryView: some View {
        CalendarAccessoryView(calendarManager: calendarManager)
    }

}
// Show Visit in selection day
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
*/
