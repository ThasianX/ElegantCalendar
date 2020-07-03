// Kevin Li - 5:20 PM - 6/14/20

import ElegantPages
import SwiftUI

class MonthlyCalendarManager: ObservableObject, ConfigurationDirectAccess, ElegantCalendarDirectAccess {

    @Published public private(set) var currentMonth: Date
    @Published public var selectedDate: Date? = nil

    let pagerManager: ElegantListManager

    weak var parent: ElegantCalendarManager?

    public let configuration: CalendarConfiguration
    let months: [Date]

    init(configuration: CalendarConfiguration, initialMonth: Date? = nil) {
        self.configuration = configuration

        let months = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryMonth)

        self.months = configuration.ascending ? months : months.reversed()

        var startingPage: Int = 0
        if let initialMonth = initialMonth {
            startingPage = configuration.calendar.monthsBetween(configuration.referenceDate, and: initialMonth)
        }

        currentMonth = self.months[startingPage]

        pagerManager = .init(startingPage: startingPage,
                             pageCount: months.count,
                             pageTurnType: .earlyCutOffDefault)
        pagerManager.datasource = self
        pagerManager.delegate = self
    }

}

extension MonthlyCalendarManager: ElegantPagesDataSource {

    func elegantPages(viewForPage page: Int) -> AnyView {
        MonthView(calendarManager: self, month: months[page])
            .erased
    }

}

extension MonthlyCalendarManager: ElegantPagesDelegate {

    func elegantPages(willDisplay page: Int) {
        if months[page] != currentMonth {
            currentMonth = months[page]
            selectedDate = nil

            delegate?.calendar(willDisplayMonth: currentMonth)
        }
    }

}

extension MonthlyCalendarManager {

    func scrollBackToToday() {
        scrollToDay(Date())
    }

    func scrollToDay(_ day: Date, animated: Bool = true) {
        scrollToMonth(day, animated: animated)
        if datasource?.calendar(canSelectDate: day) ?? true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                self.dayTapped(day: day)
            }
        }
    }

    func dayTapped(day: Date) {
        selectedDate = day
        delegate?.calendar(didSelectDate: day)
    }

    func scrollToMonth(_ month: Date, animated: Bool = true) {
        if !calendar.isDate(currentMonth, equalTo: month, toGranularities: [.month, .year]) {
            let page = calendar.monthsBetween(referenceDate, and: month)
            pagerManager.scroll(to: page, animated: animated)
        }
    }

}

extension MonthlyCalendarManager {

    static let mock = MonthlyCalendarManager(configuration: .mock)
    static let mockWithInitialMonth = MonthlyCalendarManager(configuration: .mock, initialMonth: .daysFromToday(60))

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

private extension Calendar {

    func monthsBetween(_ date1: Date, and date2: Date) -> Int {
        let startOfMonthForDate1 = startOfMonth(for: date1)
        let startOfMonthForDate2 = startOfMonth(for: date2)
        return abs(dateComponents([.month],
                              from: startOfMonthForDate1,
                              to: startOfMonthForDate2).month!)
    }

}
