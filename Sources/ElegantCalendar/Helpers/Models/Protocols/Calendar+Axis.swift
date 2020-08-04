// Kevin Li - 12:43 PM - 8/4/20

import SwiftUI

public protocol AxisModifiable: Buildable {

    var axis: Axis { get set }

}

extension AxisModifiable {

    /// Sets the axis of the calendar to vertical
    public func vertical() -> Self {
        axis(.vertical)
    }

    /// Sets the axis of the calendar to vertical
    public func horizontal() -> Self {
        axis(.horizontal)
    }

    /// Sets the axis of the calendar
    ///
    /// - Parameter axis: the intended axis of the calendar
    public func axis(_ axis: Axis) -> Self {
        mutating(keyPath: \.axis, value: axis)
    }

}

extension MonthlyCalendarView: AxisModifiable { }
extension YearlyCalendarView: AxisModifiable { }
extension ElegantCalendarView: AxisModifiable { }
