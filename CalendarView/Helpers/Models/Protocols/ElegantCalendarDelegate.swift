// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

public protocol ElegantCalendarDelegate {

    func elegantCalendar(didSelectDate date: Date)
    func elegantCalendar(willDisplay month: Date)

}

public extension ElegantCalendarDelegate {

    func elegantCalendar(didSelectDate date: Date) { }

    func elegantCalendar(willDisplay month: Date) { }

}
