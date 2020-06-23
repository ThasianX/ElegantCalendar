// Kevin Li - 5:25 PM - 6/10/20

import Combine
import SwiftUI

class PagerState: ObservableObject {

    @Published var activeIndex: Int = 1
    @Published var translation: CGFloat = .zero

    let pagerWidth: CGFloat

    init(pagerWidth: CGFloat) {
        self.pagerWidth = pagerWidth
    }

}

protocol PagerStateDirectAccess {

    var pagerState: PagerState { get }

}

extension PagerStateDirectAccess {

    var pagerWidth: CGFloat {
        pagerState.pagerWidth
    }

    var activeIndex: Int {
        pagerState.activeIndex
    }

    var translation: CGFloat {
        pagerState.translation
    }

}

public class ElegantCalendarManager: ObservableObject {

    public var currentMonth: Date {
        monthlyManager.currentMonth
    }

    public var selectedDate: Date? {
        monthlyManager.selectedDate
    }

    public var datasource: ElegantCalendarDataSource?
    public var delegate: ElegantCalendarDelegate?

    public let configuration: CalendarConfiguration

    @Published var yearlyManager: YearlyCalendarManager
    @Published var monthlyManager: MonthlyCalendarManager

    let pagerManager: ElegantSimplePagerManager

    private var anyCancellable = Set<AnyCancellable>()

    init(configuration: CalendarConfiguration, initialMonth: Date? = nil) {
        self.configuration = configuration

        yearlyManager = YearlyCalendarManager(configuration: configuration,
                                              initialYear: initialMonth)
        monthlyManager = MonthlyCalendarManager(configuration: configuration,
                                                initialMonth: initialMonth)

        pagerManager = ElegantSimplePagerManager(startingPage: 1,
                                                 pageTurnType: .calendarEarlySwipe)
        pagerManager.delegate = self

        yearlyManager.parent = self
        monthlyManager.parent = self

        yearlyManager.objectWillChange.sink {
            self.objectWillChange.send()
        }.store(in: &anyCancellable)

        monthlyManager.objectWillChange.sink {
            self.objectWillChange.send()
        }.store(in: &anyCancellable)
    }

    public func scrollToMonth(_ month: Date) {
        monthlyManager.scrollToMonth(month)
    }

}

extension ElegantCalendarManager: ElegantPagerDelegate {

    // accounts for both when the user scrolls to the yearly calendar view and the
    // user presses the month text to scroll to the yearly calendar view
    public func willDisplay(page: Int) {
        if page == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.yearlyManager.scrollToYear(self.currentMonth)
            }
        }
    }

}

extension ElegantCalendarManager {

    func scrollToMonthAndShowMonthlyView(_ month: Date) {
        pagerManager.scroll(to: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.scrollToMonth(month)
        }
    }

    func showYearlyView() {
        pagerManager.scroll(to: 0)
    }

}

protocol ElegantCalendarDirectAccess {

    var parent: ElegantCalendarManager? { get }

}

extension ElegantCalendarDirectAccess {

    var datasource: ElegantCalendarDataSource? {
        parent?.datasource
    }

    var delegate: ElegantCalendarDelegate? {
        parent?.delegate
    }

}

private extension ElegantPageTurnType {

    static let calendarEarlySwipe: ElegantPageTurnType = .earlyCutoff(
        config: .init(scrollResistanceCutOff: 40,
                      pageTurnCutOff: 90,
                      pageTurnAnimation: .interactiveSpring(response: 0.35, dampingFraction: 0.86, blendDuration: 0.25)))

}
