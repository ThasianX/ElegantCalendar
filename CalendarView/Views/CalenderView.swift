// Kevin Li - 6:19 PM - 6/6/20

import Introspect
import SwiftUI

fileprivate let scrollInsets: CGFloat = {
    // check to see if device is iphone x and above, without a home button
    if let keyWindow = window, keyWindow.safeAreaInsets.bottom > 0 {
        return 45
    }
    return 20 // This will allow the `scrollBackToToday` button to be aligned with the header for older iphones
}()

fileprivate let scrollButtonTrailingPadding = CalendarConstants.horizontalPadding + CalendarConstants.dayWidth/2
fileprivate let scrollButtonOffset = CalendarConstants.topPadding - statusBarHeight+10

struct ElegantCalendarView: View, CalendarManagerDirectAccess {

    @ObservedObject var calendarManager: ElegantCalendarManager

    var initialMonth: Date? = nil

    private var isCurrentMonthSameAsTodayMonth: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        ZStack(alignment: .top) {
            monthsList
            if !isCurrentMonthSameAsTodayMonth {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, scrollButtonTrailingPadding)
                    .offset(y: scrollButtonOffset)
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

private extension UITableView {

    var withPagination: UITableView {
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .none
        allowsSelection = false

        // gets rid of scroll insets
        contentInset = UIEdgeInsets(top: -scrollInsets,
                                    left: 0,
                                    bottom: -scrollInsets,
                                    right: 0)

        isPagingEnabled = true
        decelerationRate = .fast
        rowHeight = CalendarConstants.cellHeight // This is crucial for pagination

        return self
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
