// Kevin Li - 1:58 PM - 6/13/20

import Foundation

extension Calendar {

    var firstDayOfEveryWeek: DateComponents {
        DateComponents(hour: 0, minute: 0, second: 0, weekday: firstWeekday)
    }

}

extension DateComponents {

    static var everyDay: DateComponents {
        DateComponents(hour: 0, minute: 0, second: 0)
    }

    static var firstDayOfEveryMonth: DateComponents {
        DateComponents(day: 1, hour: 0, minute: 0, second: 0)
    }

    static var firstDayOfEveryYear: DateComponents {
        DateComponents(month: 1, day: 1, hour: 0, minute: 0, second: 0)
    }

}
