// Kevin Li - 10:53 AM - 6/22/20

import Foundation
// TODO: Prob wanna find a way to remove this and use id or equatable for child views 
protocol YearlyCalendarAccessible {

    var configuration: CalendarConfiguration { get }
    func monthTapped(_ month: Date)

}

protocol YearlyCalendarAccessibleDirectAccess: ConfigurationDirectAccess {

    var calendarAccessible: YearlyCalendarAccessible { get }
    var configuration: CalendarConfiguration { get }

}

extension YearlyCalendarAccessibleDirectAccess {

    var configuration: CalendarConfiguration {
        calendarAccessible.configuration
    }

}
