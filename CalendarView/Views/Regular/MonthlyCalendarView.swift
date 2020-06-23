// Kevin Li - 2:26 PM - 6/14/20

import SwiftUI

struct MonthlyCalendarView: View, MonthlyCalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: MonthlyCalendarManager

    private var isTodayWithinDateRange: Bool {
        Date() >= startDate && Date() <= endDate
    }

    private var isCurrentMonthYearSameAsTodayMonthYear: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        ZStack(alignment: .top) {
            monthsList
                .zIndex(0)
            if isTodayWithinDateRange && !isCurrentMonthYearSameAsTodayMonthYear {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.horizontalPadding)
                    .offset(y: CalendarConstants.Monthly.topPadding)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    private var monthsList: some View {
        ElegantPagedScrollView(pagerManager: calendarManager.pagerManager)
            .frame(width: CalendarConstants.cellWidth,
                   height: CalendarConstants.cellHeight)
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
        Group {

            LightThemePreview {
                MonthlyCalendarView()
                    .environmentObject(MonthlyCalendarManager(configuration: .mock))

                MonthlyCalendarView()
                    .environmentObject(MonthlyCalendarManager(configuration: .mock, initialMonth: .daysFromToday(60)))
            }

            DarkThemePreview {
                MonthlyCalendarView()
                    .environmentObject(MonthlyCalendarManager(configuration: .mock))

                MonthlyCalendarView()
                    .environmentObject(MonthlyCalendarManager(configuration: .mock, initialMonth: .daysFromToday(60)))
            }
            
        }
    }
}
