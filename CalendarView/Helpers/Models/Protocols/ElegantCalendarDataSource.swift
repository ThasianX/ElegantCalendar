// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

public protocol ElegantCalendarDataSource {

    func elegantCalendar(colorOpacityForDay day: Date) -> Double
    func elegantCalendar(viewForSelectedDay day: Date, dimensions size: CGSize) -> AnyView

}

public extension ElegantCalendarDataSource {

    func elegantCalendar(colorOpacityForDay day: Date) -> Double {
        1
    }

    func elegantCalendar(viewForSelectedDay day: Date, dimensions size: CGSize) -> AnyView {
        EmptyView().erased
    }

}
