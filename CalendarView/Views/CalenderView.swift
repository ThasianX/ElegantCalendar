// Kevin Li - 6:19 PM - 6/6/20

import Introspect
import SwiftUI

let screen = UIScreen.main.bounds

fileprivate let topPadding: CGFloat = 70
fileprivate let scrollInsets: CGFloat = 35

struct CalendarView: View {

    @Environment(\.appTheme) var appTheme: AppTheme

    @EnvironmentObject var calendarManager: CalendarManager
    @ObservedObject private var scrollManager = CalendarScrollTracker()

    var body: some View {
        ZStack(alignment: .top) {
            monthsList
                .padding(.horizontal, CalendarConstants.horizontalPadding)
            if !calendarManager.isCurrentMonthSameAsTodayMonth {
                HStack {
                    Spacer()
                    Button(action: {
                        self.scrollManager.scrollBackToToday()
                    }) {
                        Image(systemName: "arrow.uturn.left")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(appTheme.primary)
                    }
                    .transition(.opacity)
                }
                .padding(.trailing, CalendarConstants.horizontalPadding + CalendarConstants.dayWidth/2)
                .offset(y: topPadding - scrollInsets)
            }
        }
    }

    private var monthsList: some View {
        List {
            ForEach(calendarManager.months, id: \.self) { month in
                MonthView()
                    .padding(.top, topPadding)
                    .frame(height: CalendarConstants.cellHeight)
                    .environmentObject(self.calendarManager.createMonthManager(for: month))
                    .environmentObject(self.scrollManager)
                    .buttonStyle(PlainButtonStyle())
            }
            .listRowInsets(EdgeInsets())
        }
        .introspectTableView { tableView in
            self.scrollManager.initialiaze(with: tableView.withPagination,
                                           calendarManager: self.calendarManager)
        }
    }

}

protocol ElegantCalendarDelegate {

    func currentMonthDidChange(_ month: Date)

}

class CalendarManager: ObservableObject, CalendarConfigurationDirectAccess {

    @Published var currentMonth: Date!
    @Published var selectedDate: Date?

    var delegate: ElegantCalendarDelegate?

    let configuration: CalendarConfiguration

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration
    }

    lazy var months: [Date] = {
        let months = generateDates(
            inside: DateInterval(start: startDate, end: endDate),
            matching: .firstDayOfEveryMonth)
        currentMonth = months.first!
        return months
    }()

    lazy var todayMonthIndex: Int? = {
        let todayMonthYearComponents = calendar.monthYearComponents(for: Date())
        return months.firstIndex(where: { 
            calendar.monthYearComponents(for: $0) == todayMonthYearComponents
        })
    }()

    func createMonthManager(for month: Date) -> MonthCalendarManager {
        MonthCalendarManager(configuration: configuration, month: month)
    }

}

extension CalendarManager {

    var isCurrentMonthSameAsTodayMonth: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularity: .month)
    }

}

extension CalendarManager {

    func monthDidChange(newIndex: Int) {
        currentMonth = months[newIndex] 
        delegate?.currentMonthDidChange(months[newIndex])
    }

}

private extension Calendar {

    func monthYearComponents(for date: Date) -> DateComponents {
        dateComponents([.year, .month], from: date)
    }

}

private extension DateComponents {

    static var firstDayOfEveryMonth: DateComponents {
        DateComponents(day: 1, hour: 0, minute: 0, second: 0)
    }

}

private extension UITableView {

    var withPagination: UITableView {
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .none

        contentInset = UIEdgeInsets(top: -scrollInsets, left: 0, bottom: 0, right: 0)

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
