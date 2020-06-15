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
            if !isCurrentMonthYearSameAsTodayMonthYear {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.Monthly.scrollButtonTrailingPadding)
                    .offset(y: CalendarConstants.Monthly.scrollButtonOffset)
            }
        }
    }

    private var monthsList: some View {
        List {
            ForEach(calendarManager.months, id: \.self) { month in
                MonthView(month: month)
            }
            .listRowInsets(EdgeInsets())
        }
        .introspectTableView { tableView in
            self.calendarManager.attach(to: tableView.withPagination,
                                        with: self.initialMonth)
        }
    }

    private var leftAlignedScrollBackToTodayButton: some View {
        HStack {
            Spacer()
            Button(action: calendarManager.scrollBackToToday) {
                Image(systemName: "arrow.uturn.left")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(themeColor)
            }
            .transition(.opacity)
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
