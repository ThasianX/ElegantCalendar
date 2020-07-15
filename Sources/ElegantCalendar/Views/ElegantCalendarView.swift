// Kevin Li - 6:19 PM - 6/6/20

import ElegantPages
import SwiftUI

public struct ElegantCalendarView: View {

    var theme: CalendarTheme = .brilliantViolet

    @ObservedObject public var calendarManager: ElegantCalendarManager

    public init(calendarManager: ElegantCalendarManager) {
        self.calendarManager = calendarManager
    }

    public var body: some View {
        ElegantHPages(manager: calendarManager.pagerManager) {
            yearlyCalendarView
            monthlyCalendarView
        }
    }

    private var yearlyCalendarView: some View {
        YearlyCalendarView(theme: theme, calendarManager: calendarManager.yearlyManager)
    }

    private var monthlyCalendarView: some View {
        MonthlyCalendarView(theme: theme, calendarManager: calendarManager.monthlyManager)
    }

}


struct ElegantCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        // Only run one calendar at a time. SwiftUI has a limit for rendering time
        Group {

//            LightThemePreview {
//                ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock))

    //            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock, initialMonth: Date()))
//            }

            DarkThemePreview {
                ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock))

    //            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock, initialMonth: Date()))
            }
            
        }
    }
}
