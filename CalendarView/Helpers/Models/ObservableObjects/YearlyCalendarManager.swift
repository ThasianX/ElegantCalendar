// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

class YearlyCalendarManager: ObservableObject, ConfigurationDirectAccess {

    @Published var currentYear: Date

    weak var parent: ElegantCalendarManager?

    let configuration: CalendarConfiguration
    let years: [Date]

    private var scrollTracker: YearlyCalendarScrollTracker!

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration

        years = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryYear)

        currentYear = years.first!
    }
}

extension YearlyCalendarManager {

    func attach(toSmallCalendar scrollView: UIScrollView) {
        if scrollTracker == nil {
            scrollTracker = YearlyCalendarScrollTracker(delegate: self,
                                                        scrollView: scrollView.withPagination)
        }
    }

    func scrollBackToToday() {
        scrollToYear(Date())
    }

    public func scrollToYear(_ year: Date) {
        let startOfYearForStartDate = calendar.startOfYear(for: startDate)
        let startOfYearForToBeCurrentYear = calendar.startOfYear(for: year)
        let yearsInBetween = calendar.dateComponents([.year],
                                                                    from: startOfYearForStartDate,
                                                                    to: startOfYearForToBeCurrentYear).year!
        if yearsInBetween != 0 {
            scrollTracker.scroll(to: yearsInBetween)
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
