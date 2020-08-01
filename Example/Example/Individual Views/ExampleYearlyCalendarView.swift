// Kevin Li - 4:49 PM - 6/14/20

import ElegantCalendar
import SwiftUI

struct ExampleYearlyCalendarView: View {

    @ObservedObject private var calendarManager: YearlyCalendarManager

    let visitsByDay: [Date: [Visit]]

    @State private var calendarTheme: CalendarTheme = .royalBlue

    init(ascVisits: [Visit], initialYear: Date?) {
        let configuration = CalendarConfiguration(calendar: currentCalendar,
                                                  startDate: ascVisits.first!.arrivalDate,
                                                  endDate: ascVisits.last!.arrivalDate)
        calendarManager = YearlyCalendarManager(configuration: configuration,
                                                 initialYear: initialYear)
        visitsByDay = Dictionary(grouping: ascVisits, by: { currentCalendar.startOfDay(for: $0.arrivalDate) })

        calendarManager.delegate = self
    }

    var body: some View {
        ZStack {
            YearlyCalendarView(calendarManager: calendarManager)
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

extension ExampleYearlyCalendarView: YearlyCalendarDelegate {

    func calendar(didSelectMonth date: Date) {
        print("Selected month: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Will show year: \(date)")
    }

}

struct ExampleYearlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleYearlyCalendarView(ascVisits: Visit.mocks(start: .daysFromToday(-365*2), end: .daysFromToday(365*2)), initialYear: nil)
    }
}
