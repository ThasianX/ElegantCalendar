// Kevin Li - 9:22 PM - 6/13/20

import SwiftUI

struct YearlyCalendarView: View, YearlyCalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: YearlyCalendarManager

    private var isCurrentYearSameAsTodayYear: Bool {
        calendar.isDate(currentYear, equalTo: Date(), toGranularities: [.year])
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            yearsList
            scrollBackToTodayButton
                .padding(.trailing, CalendarConstants.Yearly.scrollButtonTrailingPadding)
                .offset(y: CalendarConstants.Yearly.scrollButtonOffset)
                .opacity(isCurrentYearSameAsTodayYear ? 0 : 1)
                .animation(.easeInOut)
        }
    }

    private var yearsList: some View {
        ScrollView(.vertical) {
            ForEach(years, id: \.self) { year in
                YearView(year: year)
            }
        }
        .introspectScrollView(customize: calendarManager.attach)
    }

    private var scrollBackToTodayButton: some View {
        ScrollBackToTodayButton(scrollBackToToday: calendarManager.scrollBackToToday,
                                    color: themeColor)
    }

}

struct YearlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        YearlyCalendarManagerGroup {
            DarkThemePreview {
                YearlyCalendarView()
            }
        }
    }
}
