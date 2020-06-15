// Kevin Li - 5:20 PM - 6/14/20

import SwiftUI

class MonthlyCalendarManager: ObservableObject {

    @Published public var currentMonth: Date
    @Published public var selectedDate: Date? = nil

    weak var parent: ElegantCalendarManager?

    private var scrollTracker: CalendarScrollTracker!

    let configuration: CalendarConfiguration
    let months: [Date]

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration

        months = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryMonth)

        currentMonth = months.first!
    }

}

extension MonthlyCalendarManager: ListPaginationDelegate {

    func willDisplay(page: Int) {
        if currentMonth != months[page] {
            currentMonth = months[page]
            selectedDate = nil
            parent?.delegate?.elegantCalendar(willDisplay: currentMonth)
        }
    }

}

extension MonthlyCalendarManager {

    func attach(to tableView: UITableView, with initialMonth: Date?) {
        if scrollTracker == nil {
            scrollTracker = CalendarScrollTracker(delegate: self,
                                                  tableView: tableView.withPaginationAndNoSeparators)
            if let initialMonth = initialMonth {
                scrollToMonth(initialMonth)
            }
        }
    }

    func scrollBackToToday() {
        scrollToMonth(Date())
        dayTapped(day: Date())
    }

    func dayTapped(day: Date) {
        selectedDate = day
        parent?.delegate?.elegantCalendar(didSelectDate: day)
    }

    public func scrollToMonth(_ month: Date) {
        let startOfMonthForStartDate = calendar.startOfMonth(for: configuration.startDate)
        let startOfMonthForToBeCurrentMonth = calendar.startOfMonth(for: month)
        let monthsInBetween = configuration.calendar.dateComponents([.month],
                                                                    from: startOfMonthForStartDate,
                                                                    to: startOfMonthForToBeCurrentMonth).month!
        scrollTracker.scroll(to: monthsInBetween)
    }

}

protocol MonthlyCalendarManagerDirectAccess: ConfigurationDirectAccess, ElegantCalendarDirectAccess {

    var calendarManager: MonthlyCalendarManager { get }
    var configuration: CalendarConfiguration { get }
    var parent: ElegantCalendarManager? { get }

}

extension MonthlyCalendarManagerDirectAccess {

    var configuration: CalendarConfiguration {
        calendarManager.configuration
    }

    var parent: ElegantCalendarManager? {
        calendarManager.parent
    }

    var currentMonth: Date {
        calendarManager.currentMonth
    }

    var selectedDate: Date? {
        calendarManager.selectedDate
    }

}
