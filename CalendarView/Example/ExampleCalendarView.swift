// Kevin Li - 11:47 AM - 6/13/20

import SwiftUI

let calendar = Calendar.current

struct ExampleCalendarView: View {

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
        calendarManager.delegate = self
    }

    var body: some View {
        ElegantCalendarView(calendarManager: calendarManager,
                     initialMonth: Date().addingTimeInterval(60*60*24*90))
    }
    
}

extension ExampleCalendarView: ElegantCalendarDataSource {

    func elegantCalendar(_ calendarManager: ElegantCalendarManager, colorOpacityForDay day: Date) -> Double {
        let startOfDay = calendar.startOfDay(for: day)
        return Double((visitsByDay[startOfDay]?.count ?? 0) + 3) / 15.0
    }

    func elegantCalendar(_ calendarManager: ElegantCalendarManager, viewForSelectedDay day: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = calendar.startOfDay(for: day)
        return VisitsListView(visits: visitsByDay[startOfDay] ?? [], height: size.height).erased
    }
    
}

extension ExampleCalendarView: ElegantCalendarDelegate {

//    func elegantCalendar(_ calendarManager: ElegantCalendarManager, didSelectDate date: Date) {
//
//    }
//
//    func elegantCalendar(_ calendarManager: ElegantCalendarManager, willDisplay month: Date) {
//
//    }

}

struct ExampleCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleCalendarView(ascVisits: Visit.mocks)
    }
}
