// Kevin Li - 5:51 PM - 6/14/20

import ElegantCalendar
import SwiftUI

struct ExampleMonthlyCalendarView: View {

    @ObservedObject private var calendarManager: MonthlyCalendarManager

    let visitsByDay: [Date: [Visit]]

    @State private var calendarTheme: CalendarTheme = .royalBlue

    init(ascVisits: [Visit], initialMonth: Date?) {
        let configuration = CalendarConfiguration(calendar: currentCalendar,
                                                  startDate: ascVisits.first!.arrivalDate,
                                                  endDate: ascVisits.last!.arrivalDate)
        calendarManager = MonthlyCalendarManager(configuration: configuration,
                                                 initialMonth: initialMonth)
        visitsByDay = Dictionary(grouping: ascVisits, by: { currentCalendar.startOfDay(for: $0.arrivalDate) })
        
        calendarManager.datasource = self
        calendarManager.delegate = self
    }

    var body: some View {
        ZStack {
            MonthlyCalendarView(calendarManager: calendarManager)
                .theme(calendarTheme)
            VStack {
                Spacer()
                changeThemeButton
                    .padding(.bottom, 50)
            }
        }
    }

    private var changeThemeButton: some View {
        ChangeThemeButton(calendarTheme: $calendarTheme)
    }

}

extension ExampleMonthlyCalendarView: MonthlyCalendarDataSource {

    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return Double((visitsByDay[startOfDay]?.count ?? 0) + 3) / 15.0
    }

    func calendar(canSelectDate date: Date) -> Bool {
        let day = currentCalendar.dateComponents([.day], from: date).day!
        return day != 4
    }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return VisitsListView(visits: visitsByDay[startOfDay] ?? [], height: size.height).erased
    }

}

extension ExampleMonthlyCalendarView: MonthlyCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        print("Selected date: \(date)")
    }

    func calendar(willDisplayMonth date: Date) {
        print("Will show month: \(date)")
    }

}

struct ExampleMonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleMonthlyCalendarView(ascVisits: Visit.mocks(start: .daysFromToday(-365*2), end: .daysFromToday(365*2)), initialMonth: nil)
    }
}
