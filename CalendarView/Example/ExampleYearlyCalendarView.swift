// Kevin Li - 4:49 PM - 6/14/20

import SwiftUI

struct ExampleYearlyCalendarView: View {

    @ObservedObject private var calendarManager: YearlyCalendarManager

    let visitsByDay: [Date: [Visit]]

    init(ascVisits: [Visit]) {
        let configuration = CalendarConfiguration(calendar: calendar,
                                                  startDate: ascVisits.first!.arrivalDate,
                                                  endDate: ascVisits.last!.arrivalDate,
                                                  themeColor: .blackPearl)
        calendarManager = YearlyCalendarManager(configuration: configuration)
        visitsByDay = Dictionary(grouping: ascVisits, by: { calendar.startOfDay(for: $0.arrivalDate) })
    }

    var body: some View {
        YearlyCalendarView()
            .environmentObject(calendarManager)
    }

}

struct ExampleYearlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleYearlyCalendarView(ascVisits: Visit.mocks(start: .daysFromToday(-365*2), end: .daysFromToday(365*2)))
    }
}
