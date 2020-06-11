// Kevin Li - 10:51 PM - 6/6/20

import Foundation

struct CalendarConfiguration {

    let calendar: Calendar
    let startDate: Date
    let endDate: Date

    init(calendar: Calendar = .current, startDate: Date, endDate: Date) {
        self.calendar = calendar
        self.startDate = startDate
        self.endDate = endDate
    }

}

extension CalendarConfiguration {

    static let mock = CalendarConfiguration(
        startDate: Date(),
        endDate: Date().addingTimeInterval(60*60*24*365*2))

}
