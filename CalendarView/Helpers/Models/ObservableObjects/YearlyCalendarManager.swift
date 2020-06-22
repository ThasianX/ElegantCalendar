// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

protocol YearlyCalendarAccessible {

    var configuration: CalendarConfiguration { get }
    func monthTapped(_ month: Date)

}

protocol YearlyCalendarAccessibleDirectAccess: ConfigurationDirectAccess {

    var calendarAccessible: YearlyCalendarAccessible { get }
    var configuration: CalendarConfiguration { get }

}

extension YearlyCalendarAccessibleDirectAccess {

    var configuration: CalendarConfiguration {
        calendarAccessible.configuration
    }

}

class YearlyCalendarManager: ObservableObject, ConfigurationDirectAccess {

    @Published var currentPage: Int = 0

    weak var parent: ElegantCalendarManager?

    let configuration: CalendarConfiguration
    let years: [Date]

    var currentYear: Date {
        years[currentPage]
    }

    init(configuration: CalendarConfiguration, initialYear: Date? = nil) {
        self.configuration = configuration

        years = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryYear)

        if let initialYear = initialYear {
            let page = calendar.yearsBetween(startDate, and: initialYear)
            currentPage = page
        }
    }

}

extension YearlyCalendarManager: YearlyCalendarAccessible {

    func monthTapped(_ month: Date) {
        parent?.scrollToMonthAndShowMonthlyView(month)
    }

}

extension YearlyCalendarManager {

    func scrollBackToToday() {
        scrollToYear(Date())
    }

    func scrollToYear(_ year: Date) {
        if !calendar.isDate(currentYear, equalTo: year, toGranularity: .year) {
            let page = calendar.yearsBetween(startDate, and: year)
            currentPage = page
        }
    }

    func willDisplay(page: Int) {
        if currentPage != page {
            currentPage = page
        }
    }

}

protocol YearlyCalendarManagerDirectAccess: ConfigurationDirectAccess, ElegantCalendarDirectAccess {

    var calendarManager: YearlyCalendarManager { get }
    var configuration: CalendarConfiguration { get }
    var parent: ElegantCalendarManager? { get }

}

extension YearlyCalendarManagerDirectAccess {

    var configuration: CalendarConfiguration {
        calendarManager.configuration
    }

    var parent: ElegantCalendarManager? {
        calendarManager.parent
    }

    var currentYear: Date {
        calendarManager.currentYear
    }

    var years: [Date] {
        calendarManager.years
    }

}

private extension Calendar {

    func yearsBetween(_ date1: Date, and date2: Date) -> Int {
        let startOfYearForDate1 = startOfYear(for: date1)
        let startOfYearForDate2 = startOfYear(for: date2)
        return dateComponents([.year],
                              from: startOfYearForDate1,
                              to: startOfYearForDate2).year!
    }

}
