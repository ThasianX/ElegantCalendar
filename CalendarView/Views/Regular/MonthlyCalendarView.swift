// Kevin Li - 2:26 PM - 6/14/20

import SwiftUI

struct MonthlyCalendarView: View, MonthlyCalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: MonthlyCalendarManager

    var initialMonth: Date? = nil

    private var isCurrentMonthYearSameAsTodayMonthYear: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        ZStack(alignment: .top) {
            monthsList
                .zIndex(0)
            if !isCurrentMonthYearSameAsTodayMonthYear {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.Monthly.scrollButtonTrailingPadding)
                    .offset(y: CalendarConstants.Monthly.scrollButtonOffset)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    private var monthsList: some View {
        ElegantPagedScrollView(provider: calendarManager)
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
        MonthlyCalendarManagerGroup {
            DarkThemePreview {
                MonthlyCalendarView()
            }

            DarkThemePreview {
                MonthlyCalendarView(initialMonth: .daysFromToday(90))
            }
        }
    }
}
