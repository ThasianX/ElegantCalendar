// Kevin Li - 6:19 PM - 6/6/20

import Introspect
import SwiftUI

struct ElegantCalendarView: View, CalendarManagerDirectAccess {

    @ObservedObject var calendarManager: ElegantCalendarManager

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
                    .environmentObject(self.calendarManager)
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

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        DarkThemePreview {
            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock))
            
            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock),
                                initialMonth: .daysFromToday(90))
        }
    }
}
