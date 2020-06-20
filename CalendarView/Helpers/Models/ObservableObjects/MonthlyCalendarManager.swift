// Kevin Li - 5:20 PM - 6/14/20

import SwiftUI

class MonthlyCalendarManager: ObservableObject, ConfigurationDirectAccess, ElegantCalendarDirectAccess {

    @Published var currentMonthIndex: Int = 0
    @Published public var selectedDate: Date? = nil

    weak var parent: ElegantCalendarManager?

    private var scrollTracker: CalendarScrollTracker!

    let configuration: CalendarConfiguration
    let months: [Date]

    public var currentMonth: Date {
        months[currentMonthIndex]
    }

    var currentMonthsRange: [Date] {
        if currentMonthIndex == 0 {
            return Array(months[0...2])
        }

        if currentMonthIndex == months.count-1 {
            return Array(months[months.count-3...months.count-1])
        }

        return Array(months[currentMonthIndex-1...currentMonthIndex+1])
    }

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration

        months = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryMonth)
    }

}

extension MonthlyCalendarManager: ListPaginationDelegate {

    func willDisplay(page: Int) {
        if page == 1 {
            if currentMonthIndex == 0 {
                // just scrolled from first page to second page
                currentMonthIndex += 1
            } else if currentMonthIndex == months.count-1 {
                // just scrolled from last page to second to last page
                currentMonthIndex -= 1
            } else {
                return
            }
        } else {
            if page == 0 {
                guard currentMonthIndex != 0 else { return }
                // case where you're on the first page and you drag and stay on the first page
                currentMonthIndex -= 1
            } else if page == 2 {
                guard currentMonthIndex != months.count-1 else { return }
                // case where you're on the first page and you drag and stay on the first page
                currentMonthIndex += 1
            }
        }

        selectedDate = nil

        parent?.willDisplay(month: currentMonth)
    }

    func resetToCenterIfNecessary() {
        if currentMonthIndex >= 1 && currentMonthIndex <= months.count-2 {
            scrollTracker.resetToCenter()
        }
    }

}

extension MonthlyCalendarManager {

    func attach(to scrollView: UIScrollView, with initialMonth: Date?) {
        if scrollTracker == nil {
            scrollTracker = CalendarScrollTracker(delegate: self,
                                                  scrollView: scrollView.withPagination)
//            if let initialMonth = initialMonth {
//                scrollToMonth(initialMonth)
//            }
        }
    }

    func scrollBackToToday() {
        scrollToMonth(Date())
        dayTapped(day: Date())
    }

    func dayTapped(day: Date) {
        selectedDate = day
        delegate?.elegantCalendar(didSelectDate: day)
    }

    // TODO: Fix this
    public func scrollToMonth(_ month: Date) {
        let startOfMonthForStartDate = calendar.startOfMonth(for: startDate)
        let startOfMonthForToBeCurrentMonth = calendar.startOfMonth(for: month)
        let monthsInBetween = calendar.dateComponents([.month],
                                                                    from: startOfMonthForStartDate,
                                                                    to: startOfMonthForToBeCurrentMonth).month!
//        scrollTracker.scroll(to: monthsInBetween)
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

    var currentMonthsRange: [Date] {
        calendarManager.currentMonthsRange
    }

}
