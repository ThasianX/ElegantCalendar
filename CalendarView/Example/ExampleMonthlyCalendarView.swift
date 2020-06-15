// Kevin Li - 5:51 PM - 6/14/20

import SwiftUI

struct ExampleMonthlyCalendarView: View {

    @ObservedObject private var calendarManager: MonthlyCalendarManager

    let visitsByDay: [Date: [Visit]]

    init(ascVisits: [Visit]) {
        let configuration = CalendarConfiguration(calendar: calendar,
                                                  startDate: ascVisits.first!.arrivalDate,
                                                  endDate: ascVisits.last!.arrivalDate,
                                                  themeColor: .blackPearl)
        calendarManager = MonthlyCalendarManager(configuration: configuration)
        visitsByDay = Dictionary(grouping: ascVisits, by: { calendar.startOfDay(for: $0.arrivalDate) })
    }

    var body: some View {
        MonthlyCalendarView()
            .environmentObject(calendarManager)
    }

}

struct ExampleMonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleYearlyCalendarView(ascVisits: Visit.mocks(start: .daysFromToday(-365*2), end: .daysFromToday(365*2)))
    }
}
