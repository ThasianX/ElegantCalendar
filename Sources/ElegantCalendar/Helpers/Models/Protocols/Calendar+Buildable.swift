// Kevin Li - 5:36 PM - 7/14/20

import Foundation
import SwiftUI

/// Adds a helper function to mutate a properties and help implement _Builder_ pattern
public protocol Buildable { }

extension Buildable {

    /// Mutates a property of the instance
    ///
    /// - Parameter keyPath:    `WritableKeyPath` to the instance property to be modified
    /// - Parameter value:      value to overwrite the  instance property
    func mutating<T>(keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }

}

extension MonthlyCalendarView: Buildable {

    /// Changes the theme of the calendar
    ///
    /// - Parameter theme: theme of various components of the calendar
    public func theme(_ theme: CalendarTheme) -> Self {
        defer {
            calendarManager.listManager.reloadPages()
        }
        return mutating(keyPath: \.theme, value: theme)
    }

    /// Sets whether haptics  is enabled or not
    ///
    /// - Parameter value: `true` if  haptics is allowed, `false`, otherwise. Defaults to `true`
    public func allowsHaptics(_ value: Bool = true) -> Self {
        calendarManager.allowsHaptics = value
        return self
    }

}

extension ElegantCalendarView: Buildable {

    /// Changes the theme of the calendar
    ///
    /// - Parameter theme: theme of various components of the calendar
    public func theme(_ theme: CalendarTheme) -> Self {
        mutating(keyPath: \.theme, value: theme)
    }

    /// Sets whether haptics  is enabled or not
    ///
    /// - Parameter value: `true` if  haptics is allowed, `false`, otherwise. Defaults to `true`
    public func allowsHaptics(_ value: Bool = true) -> Self {
        calendarManager.monthlyManager.allowsHaptics = value
        return self
    }

}

extension YearlyCalendarView: Buildable {

    /// Changes the theme of the calendar
    ///
    /// - Parameter theme: theme of various components of the calendar
    public func theme(_ theme: CalendarTheme) -> Self {
        mutating(keyPath: \.theme, value: theme)
    }

}
