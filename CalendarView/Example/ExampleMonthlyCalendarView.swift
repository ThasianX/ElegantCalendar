// Kevin Li - 5:51 PM - 6/14/20

import SwiftUI

struct ExampleMonthlyCalendarView: View {

    @ObservedObject private var calendarManager: ElegantCalendarManager

    let visitsByDay: [Date: [Visit]]

    init(ascVisits: [Visit]) {
        let configuration = CalendarConfiguration(calendar: calendar,
                                                  startDate: ascVisits.first!.arrivalDate,
                                                  endDate: ascVisits.last!.arrivalDate,
                                                  themeColor: .blackPearl)
        calendarManager = ElegantCalendarManager(configuration: configuration)
        visitsByDay = Dictionary(grouping: ascVisits, by: { calendar.startOfDay(for: $0.arrivalDate) })
        calendarManager.datasource = self
    }

    var body: some View {
        MonthlyCalendarView()
            .environmentObject(calendarManager.monthlyManager)
    }

}

extension ExampleMonthlyCalendarView: ElegantCalendarDataSource {

    func elegantCalendar(colorOpacityForDay day: Date) -> Double {
        let startOfDay = calendar.startOfDay(for: day)
        return Double((visitsByDay[startOfDay]?.count ?? 0) + 3) / 15.0
    }

    func elegantCalendar(viewForSelectedDay day: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = calendar.startOfDay(for: day)
        return VisitsListView(visits: visitsByDay[startOfDay] ?? [], height: size.height).erased
    }

}

struct ExampleMonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleYearlyCalendarView(ascVisits: Visit.mocks(start: .daysFromToday(-365*2), end: .daysFromToday(365*2)))
    }
}
