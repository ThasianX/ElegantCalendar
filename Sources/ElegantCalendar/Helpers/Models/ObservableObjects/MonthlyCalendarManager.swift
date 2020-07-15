// Kevin Li - 5:20 PM - 6/14/20

import Combine
import ElegantPages
import SwiftUI

public class MonthlyCalendarManager: ObservableObject, ConfigurationDirectAccess {

    @Published public private(set) var currentMonth: Date
    @Published public var selectedDate: Date? = nil

    let pagerManager: ElegantListManager

    @Published public var datasource: MonthlyCalendarDataSource?
    @Published public var delegate: MonthlyCalendarDelegate?

    public var communicator: ElegantCalendarCommunicator?

    public let configuration: CalendarConfiguration
    public let months: [Date]

    var allowsHaptics: Bool = true
    private var isHapticActive: Bool = true

    var theme: CalendarTheme = .default

    private var anyCancellable: AnyCancellable?

    public init(configuration: CalendarConfiguration, initialMonth: Date? = nil) {
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

        currentMonth = months[startingPage]

        pagerManager = .init(startingPage: startingPage,
                             pageCount: months.count,
                             pageTurnType: .monthlyEarlyCutoff)

        pagerManager.datasource = self
        pagerManager.delegate = self

        anyCancellable = $delegate.sink {
            $0?.calendar(willDisplayMonth: self.currentMonth)
        }
    }

}

extension MonthlyCalendarManager: ElegantPagesDataSource {

    public func elegantPages(viewForPage page: Int) -> AnyView {
        MonthView(calendarManager: self, month: months[page])
            .environment(\.calendarTheme, theme)
            .erased
    }

}

extension MonthlyCalendarManager: ElegantPagesDelegate {

    public func elegantPages(willDisplay page: Int) {
        if months[page] != currentMonth {
            currentMonth = months[page]
            selectedDate = nil

            delegate?.calendar(willDisplayMonth: currentMonth)

            if allowsHaptics && isHapticActive {
                UIImpactFeedbackGenerator.generateSelectionHaptic()
            } else {
                isHapticActive = true
            }
        }
    }

}

extension MonthlyCalendarManager {

    @discardableResult
    public func scrollBackToToday() -> Bool {
        scrollToDay(Date())
    }

    @discardableResult
    public func scrollToDay(_ day: Date, animated: Bool = true) -> Bool {
        let didScrollToMonth = scrollToMonth(day, animated: animated)
        let canSelectDay = datasource?.calendar(canSelectDate: day) ?? true

        if canSelectDay {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                self.dayTapped(day: day, withHaptic: !didScrollToMonth)
            }
        }

        return canSelectDay
    }

    func dayTapped(day: Date, withHaptic: Bool) {
        if allowsHaptics && withHaptic {
            UIImpactFeedbackGenerator.generateSelectionHaptic()
        }

        selectedDate = day
        delegate?.calendar(didSelectDay: day)
    }

    @discardableResult
    public func scrollToMonth(_ month: Date, animated: Bool = true) -> Bool {
        isHapticActive = animated

        let needsToScroll = !calendar.isDate(currentMonth, equalTo: month, toGranularities: [.month, .year])

        if needsToScroll {
            let page = calendar.monthsBetween(referenceDate, and: month)
            pagerManager.scroll(to: page, animated: animated)
        } else {
            isHapticActive = true
        }

        return needsToScroll
    }

}

extension MonthlyCalendarManager {

    static let mock = MonthlyCalendarManager(configuration: .mock)
    static let mockWithInitialMonth = MonthlyCalendarManager(configuration: .mock, initialMonth: .daysFromToday(60))

}

protocol MonthlyCalendarManagerDirectAccess: ConfigurationDirectAccess {

    var calendarManager: MonthlyCalendarManager { get }
    var configuration: CalendarConfiguration { get }

}

extension MonthlyCalendarManagerDirectAccess {

    var configuration: CalendarConfiguration {
        calendarManager.configuration
    }

    var communicator: ElegantCalendarCommunicator? {
        calendarManager.communicator
    }

    var datasource: MonthlyCalendarDataSource? {
        calendarManager.datasource
    }

    var delegate: MonthlyCalendarDelegate? {
        calendarManager.delegate
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

private extension PageTurnType {

    static var monthlyEarlyCutoff: PageTurnType = .earlyCutoff(config: .monthlyConfig)

}

public extension EarlyCutOffConfiguration {

    static let monthlyConfig = EarlyCutOffConfiguration(
        scrollResistanceCutOff: 40,
        pageTurnCutOff: 80,
        pageTurnAnimation: .spring(response: 0.3, dampingFraction: 0.95))

}
