// Kevin Li - 9:22 PM - 6/13/20

import SwiftUI

struct YearlyCalendarView: View, YearlyCalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: YearlyCalendarManager

    private var isCurrentYearSameAsTodayYear: Bool {
        calendar.isDate(currentYear, equalTo: Date(), toGranularities: [.year])
    }

    var body: some View {
        ZStack(alignment: .top) {
            yearsList
            if !isCurrentYearSameAsTodayYear {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.Yearly.scrollButtonTrailingPadding)
                    .offset(y: CalendarConstants.Yearly.scrollButtonOffset)
            }
        }
    }

    private var yearsList: some View {
        List {
            ForEach(years, id: \.self) { year in
                YearView(year: year)
            }
            .listRowInsets(EdgeInsets())
        }
        .introspectTableView { tableView in
            self.calendarManager.attach(toSmallCalendar: tableView.withPagination)
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

struct YearlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        YearlyCalendarManagerGroup {
            DarkThemePreview {
                YearlyCalendarView()
            }
        }
    }
}
