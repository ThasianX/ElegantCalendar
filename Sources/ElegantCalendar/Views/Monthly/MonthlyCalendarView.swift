// Kevin Li - 2:26 PM - 6/14/20

import ElegantPages
import SwiftUI

public struct MonthlyCalendarView: View, MonthlyCalendarManagerDirectAccess {

    @ObservedObject public var calendarManager: MonthlyCalendarManager

    private var isTodayWithinDateRange: Bool {
        Date() >= calendar.startOfDay(for: startDate) &&
            calendar.startOfDay(for: Date()) <= endDate
    }

    private var isCurrentMonthYearSameAsTodayMonthYear: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    public init(calendarManager: MonthlyCalendarManager) {
        self.calendarManager = calendarManager
    }

    public var body: some View {
        ZStack(alignment: .top) {
            monthsList
                .zIndex(0)
            if isTodayWithinDateRange && !isCurrentMonthYearSameAsTodayMonthYear {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.Monthly.outerHorizontalPadding)
                    .offset(y: CalendarConstants.Monthly.topPadding + 3)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    private var monthsList: some View {
        ElegantVList(manager: calendarManager.pagerManager)
    }

    private var leftAlignedScrollBackToTodayButton: some View {
        HStack {
            Spacer()
            ScrollBackToTodayButton(scrollBackToToday: calendarManager.scrollBackToToday,
                                    color: themeColor)
        }
    }

}

struct MonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        LightDarkThemePreview {
            MonthlyCalendarView(calendarManager: .mock)

            MonthlyCalendarView(calendarManager: .mockWithInitialMonth)
        }
    }
}
