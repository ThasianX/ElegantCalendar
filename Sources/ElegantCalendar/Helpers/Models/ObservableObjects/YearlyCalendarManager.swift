// Kevin Li - 5:19 PM - 6/14/20

import Combine
import SwiftUI

public class YearlyCalendarManager: ObservableObject, ConfigurationDirectAccess {

    enum PageState {
        case scroll
        case completed
    }

    @Published var currentPage: (index: Int, state: PageState) = (0, .completed)

    public var currentYear: Date {
        years[currentPage.index]
    }

    @Published public var datasource: YearlyCalendarDataSource?
    @Published public var delegate: YearlyCalendarDelegate?

    public var communicator: ElegantCalendarCommunicator?

    public let configuration: CalendarConfiguration
    public let years: [Date]

    private var anyCancellable: AnyCancellable?

    public init(configuration: CalendarConfiguration, initialYear: Date? = nil) {
        self.configuration = configuration

        let years = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryYear)

        self.years = configuration.ascending ? years : years.reversed()

        if let initialYear = initialYear {
            let page = calendar.yearsBetween(referenceDate, and: initialYear)
            currentPage = (page, .scroll)
        } else {
            anyCancellable = $delegate.sink {
                $0?.calendar(willDisplayYear: self.currentYear)
            }
        }
    }

}

extension YearlyCalendarManager {

    public func scrollBackToToday() {
        scrollToYear(Date())
    }

    public func scrollToYear(_ year: Date) {
        if !calendar.isDate(currentYear, equalTo: year, toGranularity: .year) {
            let page = calendar.yearsBetween(referenceDate, and: year)
            currentPage = (page, .scroll)
        }
    }

    func willDisplay(page: Int) {
        if currentPage.index != page || currentPage.state == .scroll {
            currentPage = (page, .completed)
            delegate?.calendar(willDisplayYear: currentYear)
        }
    }

    func monthTapped(_ month: Date) {
        delegate?.calendar(didSelectMonth: month)
        communicator?.scrollToMonthAndShowMonthlyView(month)
    }

}

extension YearlyCalendarManager {

    static let mock = YearlyCalendarManager(configuration: .mock)
    static let mockWithInitialYear = YearlyCalendarManager(configuration: .mock, initialYear: .daysFromToday(365))

}

protocol YearlyCalendarManagerDirectAccess: ConfigurationDirectAccess {

    var calendarManager: YearlyCalendarManager { get }
    var configuration: CalendarConfiguration { get }

}

extension YearlyCalendarManagerDirectAccess {

    var configuration: CalendarConfiguration {
        calendarManager.configuration
    }

    var communicator: ElegantCalendarCommunicator? {
        calendarManager.communicator
    }

    var datasource: YearlyCalendarDataSource? {
        calendarManager.datasource
    }

    var delegate: YearlyCalendarDelegate? {
        calendarManager.delegate
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
        return abs(dateComponents([.year],
                              from: startOfYearForDate1,
                              to: startOfYearForDate2).year!)
    }

}
