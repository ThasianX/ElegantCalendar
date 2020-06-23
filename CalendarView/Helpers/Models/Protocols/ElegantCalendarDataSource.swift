// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

public protocol ElegantCalendarDataSource {

    func calendar(backgroundColorOpacityForDay day: Date) -> Double
    func calendar(canSelectDay day: Date) -> Bool

    func calendar(viewForSelectedDay day: Date, dimensions size: CGSize) -> AnyView

}

public extension ElegantCalendarDataSource {

    func calendar(backgroundColorOpacityForDay day: Date) -> Double {
        1
    }

    func calendar(canSelectDay day: Date) -> Bool {
        true
    }

    func calendar(viewForSelectedDay day: Date, dimensions size: CGSize) -> AnyView {
        EmptyView().erased
    }

}
