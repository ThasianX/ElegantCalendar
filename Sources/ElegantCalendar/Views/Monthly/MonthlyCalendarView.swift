// Kevin Li - 2:26 PM - 6/14/20

import ElegantPages
import SwiftUI

public struct MonthlyCalendarView: View, MonthlyCalendarManagerDirectAccess {

    var theme: CalendarTheme = .brilliantViolet

    @ObservedObject public var calendarManager: MonthlyCalendarManager

    private var isTodayWithinDateRange: Bool {
        Date() >= calendar.startOfDay(for: startDate) &&
            calendar.startOfDay(for: Date()) <= endDate
    }

    private var isCurrentMonthYearSameAsTodayMonthYear: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    public init(theme: CalendarTheme = .brilliantViolet, calendarManager: MonthlyCalendarManager) {
        self.theme = theme
        self.calendarManager = calendarManager
        calendarManager.pagerManager.datasource = self
    }

    var nice: Bool = true

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
            .id(theme)
    }

    private var leftAlignedScrollBackToTodayButton: some View {
        HStack {
            Spacer()
            ScrollBackToTodayButton(scrollBackToToday: { self.calendarManager.scrollBackToToday() },
                                    color: theme.primary)
        }
    }

}

extension MonthlyCalendarView: ElegantPagesDataSource {

    public func elegantPages(viewForPage page: Int) -> AnyView {
        MonthView(calendarManager: calendarManager, month: calendarManager.months[page])
            .environment(\.calendarTheme, theme)
            .erased
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
