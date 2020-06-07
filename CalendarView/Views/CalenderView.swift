// Kevin Li - 6:19 PM - 6/6/20

import SwiftUI

let screen = UIScreen.main.bounds

struct CalendarView: View {

    @EnvironmentObject var calendarManager: CalendarManager

    var body: some View {
        monthsList
            .edgesIgnoringSafeArea(.all)
    }

    private var monthsList: some View {
        List {
            ForEach(calendarManager.months, id: \.self) { month in
                MonthView()
                    .frame(height: screen.height)
                    .environmentObject(self.calendarManager.createMonthManager(for: month))
            }
            .listRowInsets(EdgeInsets())
        }
    }

}

class CalendarManager: ObservableObject, CalendarConfigurationDirectAccess {

    let configuration: CalendarConfiguration

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration
    }

    var months: [Date] {
        generateDates(
            inside: DateInterval(start: startDate, end: endDate),
            matching: .firstDayOfEveryMonth)
    }

    func createMonthManager(for month: Date) -> MonthCalendarManager {
        MonthCalendarManager(configuration: configuration, month: month)
    }

}

private extension DateComponents {

    static var firstDayOfEveryMonth: DateComponents {
        DateComponents(day: 1, hour: 0, minute: 0, second: 0)
    }

}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        DarkThemePreview {
            CalendarView()
                .environmentObject(CalendarManager(configuration: .mock))
        }
    }
}
