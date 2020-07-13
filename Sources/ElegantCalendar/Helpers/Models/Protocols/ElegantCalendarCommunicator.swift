// Kevin Li - 2:42 PM - 7/12/20

import Foundation

public protocol ElegantCalendarCommunicator {

    func scrollToMonthAndShowMonthlyView(_ month: Date)
    func showYearlyView()

}

public extension ElegantCalendarCommunicator {

    func scrollToMonthAndShowMonthlyView(_ month: Date) { }
    func showYearlyView() { }

}
