// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

class YearlyCalendarManager: ObservableObject, ConfigurationDirectAccess {

    @Published var currentYear: Date

    weak var parent: ElegantCalendarManager?

    let configuration: CalendarConfiguration
    let years: [Date]

    private var scrollTracker: YearlyCalendarScrollTracker!

    init(configuration: CalendarConfiguration, initialYear: Date? = nil) {
        self.configuration = configuration

        years = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryYear)

        if let initialYear = initialYear {
            currentYear = initialYear
        } else {
            currentYear = years.first!
        }
    }
}

extension YearlyCalendarManager {

    func attach(toSmallCalendar scrollView: UIScrollView) {
        if scrollTracker == nil {
            scrollTracker = YearlyCalendarScrollTracker(delegate: self,
                                                        scrollView: scrollView.withPagination)
            scrollToYear(currentYear) // accounts for initial year if any. TODO: Don't know why but this isn't working
        }
    }

    func scrollBackToToday() {
        scrollToYear(Date())
    }

    func scrollToYear(_ year: Date) {
        if !calendar.isDate(currentYear, equalTo: year, toGranularity: .year) {
            let page = calendar.yearsBetween(startDate, and: year)
            scrollTracker.scroll(to: page)
        }
    }

    func monthTapped(_ month: Date) {
        parent?.scrollToMonthAndShowMonthlyView(month)
    }

}

extension YearlyCalendarManager: ListPaginationDelegate {

    func willDisplay(page: Int) {
        if currentYear != years[page] {
            currentYear = years[page]
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
