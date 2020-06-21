// Kevin Li - 5:20 PM - 6/14/20

import SwiftUI

class MonthlyCalendarManager: ObservableObject, ConfigurationDirectAccess, ElegantCalendarDirectAccess {

    @Published public private(set) var currentMonth: Date
    @Published public var selectedDate: Date? = nil

    let pagerManager: ElegantPagerManager

    weak var parent: ElegantCalendarManager?

    public let configuration: CalendarConfiguration
    let months: [Date]

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration

        months = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryMonth)

        currentMonth = months.first!

        pagerManager = .init(pageCount: months.count)
        pagerManager.datasource = self
        pagerManager.delegate = self
    }

}

extension MonthlyCalendarManager: ElegantPagerDataSource {

    func view(for page: Int) -> AnyView {
        MonthView(month: months[page])
            .environmentObject(self)
            .erased
    }

}

extension MonthlyCalendarManager: ElegantPagerDelegate {

    func willDisplay(page: Int) {
        if months[page] != currentMonth {
            currentMonth = months[page]
            selectedDate = nil

            parent?.willDisplay(month: currentMonth)
        }
    }

}

extension MonthlyCalendarManager {

    public func scrollBackToToday() {
        scrollToMonth(Date())
        dayTapped(day: Date())
    }

    func dayTapped(day: Date) {
        selectedDate = day
        delegate?.elegantCalendar(didSelectDate: day)
    }

    public func scrollToMonth(_ month: Date) {
        let startOfMonthForStartDate = calendar.startOfMonth(for: startDate)
        let startOfMonthForToBeCurrentMonth = calendar.startOfMonth(for: month)
        let monthsInBetween = calendar.dateComponents([.month],
                                                                    from: startOfMonthForStartDate,
                                                                    to: startOfMonthForToBeCurrentMonth).month!

        pagerManager.scroll(to: monthsInBetween)
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
