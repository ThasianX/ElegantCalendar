// Kevin Li - 6:19 PM - 6/6/20

import Introspect
import SwiftUI

fileprivate let scrollInsets: CGFloat = {
    // check to see if device is iphone x and above, without a home button
    if let keyWindow = window, keyWindow.safeAreaInsets.bottom > 0 {
        return 35
    }
    return 15 // This will allow the `scrollBackToToday` button to be aligned with the header
}()

struct CalendarView: View, CalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: CalendarManager

    private var isCurrentMonthSameAsTodayMonth: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        ZStack(alignment: .top) {
            monthsList
            if !isCurrentMonthSameAsTodayMonth {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.horizontalPadding + CalendarConstants.dayWidth/2)
                    .offset(y: CalendarConstants.topPadding - scrollInsets)
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
            self.calendarManager.attach(to: tableView.withPagination)
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
        contentInset = UIEdgeInsets(top: -scrollInsets, left: 0, bottom: -scrollInsets, right: 0)

        isPagingEnabled = true
        decelerationRate = .fast
        rowHeight = CalendarConstants.cellHeight // This is crucial for pagination

        return self
    }

}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        DarkThemePreview {
            CalendarView()
                .environmentObject(CalendarManager(configuration: .mock))
        }
    }
}
