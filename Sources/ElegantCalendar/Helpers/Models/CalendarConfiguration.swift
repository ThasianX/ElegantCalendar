// Kevin Li - 10:51 PM - 6/6/20

import SwiftUI

public struct CalendarConfiguration: Equatable {

    public let calendar: Calendar
    public let ascending: Bool
    public let startDate: Date
    public let endDate: Date
    public let themeColor: Color

    public init(calendar: Calendar = .current, ascending: Bool = true, startDate: Date, endDate: Date, themeColor: Color) {
        self.calendar = calendar
        self.ascending = ascending
        self.startDate = startDate
        self.endDate = endDate
        self.themeColor = themeColor
    }

    var referenceDate: Date {
        ascending ? startDate : endDate
    }

}

extension CalendarConfiguration {

    static let mock = CalendarConfiguration(
        startDate: .daysFromToday(-365*2),
        endDate: .daysFromToday(365*2),
        themeColor: .purple)

}

protocol ConfigurationDirectAccess {

    var configuration: CalendarConfiguration { get }

}

extension ConfigurationDirectAccess {

    var calendar: Calendar {
        configuration.calendar
    }

    var startDate: Date {
        configuration.startDate
    }

    var endDate: Date {
        configuration.endDate
    }

    var themeColor: Color {
        configuration.themeColor
    }

    var referenceDate: Date {
        configuration.referenceDate
    }

}
