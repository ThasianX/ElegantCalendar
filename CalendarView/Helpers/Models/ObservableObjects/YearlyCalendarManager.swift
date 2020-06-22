// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

class YearlyCalendarManager: ObservableObject, ConfigurationDirectAccess {

    @Published var currentYear: Date

    let pagerManager: ElegantPagerManager

    weak var parent: ElegantCalendarManager?

    let configuration: CalendarConfiguration
    let years: [Date]

    init(configuration: CalendarConfiguration, initialYear: Date? = nil) {
        self.configuration = configuration

        years = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryYear)

        var startingPage: Int = 0
        if let initialYear = initialYear {
            startingPage = configuration.calendar.yearsBetween(configuration.startDate, and: initialYear)
        }

        currentYear = years[startingPage]

        pagerManager = .init(startingPage: startingPage,
                             configuration: .init(pageCount: years.count,
                                                  pageTurnType: .regular))
        pagerManager.datasource = self
        pagerManager.delegate = self
    }
}

extension YearlyCalendarManager: ElegantPagerDataSource {

    func view(for page: Int) -> AnyView {
        YearView(year: years[page])
            .environmentObject(self)
            .erased
    }

}

extension YearlyCalendarManager: ElegantPagerDelegate {

    func willDisplay(page: Int) {
        if currentYear != years[page] {
            currentYear = years[page]
        }
    }

}

extension YearlyCalendarManager {

    func scrollBackToToday() {
        scrollToYear(Date())
    }

    func scrollToYear(_ year: Date) {
        if !calendar.isDate(currentYear, equalTo: year, toGranularity: .year) {
            let page = calendar.yearsBetween(startDate, and: year)
            pagerManager.scroll(to: page)
        }
    }

    func monthTapped(_ month: Date) {
        parent?.scrollToMonthAndShowMonthlyView(month)
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
