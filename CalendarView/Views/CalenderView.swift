// Kevin Li - 6:19 PM - 6/6/20

import Introspect
import SwiftUI

let screen = UIScreen.main.bounds

struct CalendarView: View {

    @EnvironmentObject var calendarManager: CalendarManager
    @ObservedObject private var scrollManager = CalendarScrollTracker()

    var body: some View {
        // TODO: This should be a ZStack with a button to go back to current month
        // layered on top of the list. Should be on the top right of the screen
        monthsList
    }

    private var monthsList: some View {
        List {
            ForEach(calendarManager.months, id: \.self) { month in
                MonthView()
                    .frame(height: CalendarConstants.cellHeight)
                    .environmentObject(self.calendarManager.createMonthManager(for: month))
            }
            .listRowInsets(EdgeInsets())
        }
        .introspectTableView { tableView in
            self.scrollManager.initialiaze(with: tableView.withPagination)
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

private extension UITableView {

    var withPagination: UITableView {
        allowsSelection = false
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .none

        isPagingEnabled = true
        decelerationRate = .fast
        rowHeight = CalendarConstants.cellHeight // This is crucial for pagination

        return self
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
