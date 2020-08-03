// Kevin Li - 6:19 PM - 6/6/20

import ElegantPages
import SwiftUI

public struct ElegantCalendarView: View {

    var theme: CalendarTheme = .default

    public let calendarManager: ElegantCalendarManager

    public init(calendarManager: ElegantCalendarManager) {
        self.calendarManager = calendarManager
    }

    public var body: some View {
        getCalendar(with: calendarManager.configuration.orientation)
    }

    private var yearlyCalendarView: some View {
        YearlyCalendarView(calendarManager: calendarManager.yearlyManager)
            .theme(theme)
    }

    private var monthlyCalendarView: some View {
        MonthlyCalendarView(calendarManager: calendarManager.monthlyManager)
            .theme(theme)
    }
    
    private func getCalendar(with orientation: CalendarOrientation) -> AnyView {
        if orientation == .vertical {
            return ElegantHPages(manager: calendarManager.pagesManager) {
                yearlyCalendarView
                monthlyCalendarView
            }
            .onPageChanged(calendarManager.scrollToYearIfOnYearlyView)
            .erased
        }
        
        return ElegantVPages(manager: calendarManager.pagesManager) {
            yearlyCalendarView
            monthlyCalendarView
        }
        .onPageChanged(calendarManager.scrollToYearIfOnYearlyView)
        .erased
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
