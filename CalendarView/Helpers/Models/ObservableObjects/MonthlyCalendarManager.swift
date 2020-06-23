// Kevin Li - 5:20 PM - 6/14/20

import SwiftUI

class MonthlyCalendarManager: ObservableObject, ConfigurationDirectAccess, ElegantCalendarDirectAccess {

    @Published public private(set) var currentMonth: Date
    @Published public var selectedDate: Date? = nil

    let pagerManager: ElegantPagerManager

    weak var parent: ElegantCalendarManager?

    public let configuration: CalendarConfiguration
    let months: [Date]

    init(configuration: CalendarConfiguration, initialMonth: Date? = nil) {
        self.configuration = configuration

        months = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryMonth)

        var startingPage: Int = 0
        if let initialMonth = initialMonth {
            startingPage = configuration.calendar.monthsBetween(configuration.startDate, and: initialMonth)
        }

        currentMonth = months[startingPage]

        pagerManager = .init(startingPage: startingPage,
                             configuration: .init(pageCount: months.count,
                                                  pageTurnType: .earlyCutOffDefault))
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

            delegate?.calendar(willDisplayMonth: currentMonth)
        }
    }

}

extension MonthlyCalendarManager {

    public func scrollBackToToday() {
        scrollToMonth(Date())
        if datasource?.calendar(canSelectDate: Date()) ?? true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                self.dayTapped(day: Date())
            }
        }
    }

    func dayTapped(day: Date) {
        selectedDate = day
        delegate?.calendar(didSelectDate: day)
    }

    public func scrollToMonth(_ month: Date) {
        if !calendar.isDate(currentMonth, equalTo: month, toGranularities: [.month, .year]) {
            let page = calendar.monthsBetween(startDate, and: month)
            pagerManager.scroll(to: page)
        }
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

private extension Calendar {

    func monthsBetween(_ date1: Date, and date2: Date) -> Int {
        let startOfMonthForDate1 = startOfMonth(for: date1)
        let startOfMonthForDate2 = startOfMonth(for: date2)
        return dateComponents([.month],
                              from: startOfMonthForDate1,
                              to: startOfMonthForDate2).month!
    }

}
