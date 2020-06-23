// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

public protocol ElegantCalendarDelegate {

    func calendar(didSelectDate date: Date)
    func calendar(willDisplayMonth date: Date)

}

public extension ElegantCalendarDelegate {

    func calendar(didSelectDate date: Date) { }

    func calendar(willDisplayMonth date: Date) { }

}
