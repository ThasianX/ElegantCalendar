// Kevin Li - 5:25 PM - 6/10/20

import Combine
import SwiftUI

public class ElegantCalendarManager: ObservableObject {

    public var currentMonth: Date {
        monthlyManager.currentMonth
    }

    public var selectedDate: Date? {
        monthlyManager.selectedDate
    }

    public var datasource: ElegantCalendarDataSource?
    public var delegate: ElegantCalendarDelegate?

    let configuration: CalendarConfiguration

    @Published var yearlyManager: YearlyCalendarManager
    @Published var monthlyManager: MonthlyCalendarManager

    private var anyCancellable = Set<AnyCancellable>()

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration

        yearlyManager = YearlyCalendarManager(configuration: configuration)
        monthlyManager = MonthlyCalendarManager(configuration: configuration)

        yearlyManager.parent = self
        monthlyManager.parent = self

        yearlyManager.objectWillChange.sink {
            self.objectWillChange.send()
        }.store(in: &anyCancellable)

        monthlyManager.objectWillChange.sink {
            self.objectWillChange.send()
        }.store(in: &anyCancellable)
    }

    func scrollToMonth(_ month: Date) {
        monthlyManager.scrollToMonth(month)
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
