// Kevin Li - 10:51 PM - 6/6/20

import SwiftUI

struct CalendarConfiguration {

    let calendar: Calendar
    let startDate: Date
    let endDate: Date
    let themeColor: Color

    init(calendar: Calendar = .current, startDate: Date, endDate: Date, themeColor: Color) {
        self.calendar = calendar
        self.startDate = startDate
        self.endDate = endDate
        self.themeColor = themeColor
    }

}

extension CalendarConfiguration {

    static let mock = CalendarConfiguration(
        startDate: Date(),
        endDate: Date().addingTimeInterval(60*60*24*365*2),
        themeColor: .blackPearl)

}
