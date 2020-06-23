// Kevin Li - 5:51 PM - 6/14/20

import SwiftUI

struct ExampleMonthlyCalendarView: View {

    @ObservedObject private var calendarManager: ElegantCalendarManager

    let visitsByDay: [Date: [Visit]]

    init(ascVisits: [Visit]) {
        let configuration = CalendarConfiguration(calendar: currentCalendar,
                                                  startDate: ascVisits.first!.arrivalDate,
                                                  endDate: ascVisits.last!.arrivalDate,
                                                  themeColor: .blackPearl)
        calendarManager = ElegantCalendarManager(configuration: configuration,
                                                 initialMonth: .daysFromToday(30))
        visitsByDay = Dictionary(grouping: ascVisits, by: { currentCalendar.startOfDay(for: $0.arrivalDate) })
        calendarManager.datasource = self
    }

    var body: some View {
        MonthlyCalendarView()
            .environmentObject(calendarManager.monthlyManager)
    }

}

extension ExampleMonthlyCalendarView: ElegantCalendarDataSource {

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

struct ExampleMonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleYearlyCalendarView(ascVisits: Visit.mocks(start: .daysFromToday(-365*2), end: .daysFromToday(365*2)))
    }
}
