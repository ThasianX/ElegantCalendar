// Kevin Li - 11:47 AM - 6/13/20

import ElegantCalendar
import SwiftUI

struct ExampleCalendarView: View {

    @ObservedObject private var calendarManager: ElegantCalendarManager

    let visitsByDay: [Date: [Visit]]

    @State private var calendarTheme: CalendarTheme = .royalBlue

    init(ascVisits: [Visit], initialMonth: Date?) {
        let configuration = CalendarConfiguration(
            calendar: currentCalendar,
            startDate: ascVisits.first!.arrivalDate,
            endDate: ascVisits.last!.arrivalDate)

        calendarManager = ElegantCalendarManager(
            configuration: configuration,
            initialMonth: initialMonth)

        visitsByDay = Dictionary(
            grouping: ascVisits,
            by: { currentCalendar.startOfDay(for: $0.arrivalDate) })

        calendarManager.datasource = self
        calendarManager.delegate = self
    }

    var body: some View {
        ZStack {
            ElegantCalendarView(calendarManager: calendarManager)
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

extension ExampleCalendarView: ElegantCalendarDataSource {

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

extension ExampleCalendarView: ElegantCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        print("Selected date: \(date)")
    }

    func calendar(willDisplayMonth date: Date) {
        print("Month displayed: \(date)")
    }

    func calendar(didSelectMonth date: Date) {
        print("Selected month: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Year displayed: \(date)")
    }

}

struct ExampleCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleCalendarView(ascVisits: Visit.mocks(start: .daysFromToday(-365*2), end: .daysFromToday(365*2)), initialMonth: nil)
    }
}
