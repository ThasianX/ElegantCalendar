// Kevin Li - 10:53 PM - 6/6/20

import SwiftUI

fileprivate let daysOfWeekInitials = ["S", "M", "T", "W", "T", "F", "S"]

struct MonthView: View {

    @Environment(\.appTheme) var appTheme: AppTheme
    @EnvironmentObject var monthManager: MonthCalendarManager

    var body: some View {
        VStack(spacing: 40) {
            header
                .padding(.leading, 24)
                .padding(.top, 70)
            weekViewWithHeader
            Spacer()
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(monthManager.monthString.uppercased())
                    .font(.title)
                    .bold()
                    .tracking(5)
                    .foregroundColor(monthManager.isInSameMonth ? appTheme.primary : .white)
                Text(monthManager.yearString)
                    .font(.caption)
                    .tracking(2)
                    .foregroundColor(monthManager.isInSameMonth ? appTheme.complementary : .gray)
                    .opacity(0.7)
            }
            Spacer()
        }
    }

    private var weekViewWithHeader: some View {
        VStack(spacing: 32) {
            daysOfWeekHeader
                .padding(.horizontal, CalendarConstants.horizontalPadding)
            weekViewStack
        }
    }

    private var daysOfWeekHeader: some View {
        HStack(spacing: CalendarConstants.gridSpacing) {
            ForEach(CalendarConstants.daysOfWeekInitials, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(.caption)
                    .frame(width: CalendarConstants.dayWidth)
                    .foregroundColor(.gray)
            }
        }
    }

    private var weekViewStack: some View {
        VStack(spacing: CalendarConstants.gridSpacing) {
            ForEach(monthManager.weeks, id: \.self) { week in
                WeekView()
                    .environmentObject(self.monthManager.createWeekManager(for: week))
            }
        }
    }

}

class MonthCalendarManager: ObservableObject, CalendarConfigurationDirectAccess {

    let configuration: CalendarConfiguration
    let month: Date

    init(configuration: CalendarConfiguration, month: Date) {
        self.configuration = configuration
        self.month = month
    }

    var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        return generateDates(
            inside: monthInterval,
            matching: calendar.firstDayOfEveryWeek)
    }

    func createWeekManager(for week: Date) -> WeekCalendarManager {
        WeekCalendarManager(configuration: configuration, week: week)
    }

    var monthString: String {
        month.fullMonth
    }

    var yearString: String {
        month.year
    }

    var isInSameMonth: Bool {
        calendar.isDate(month, equalTo: Date(), toGranularity: .month)
    }

}

private extension Calendar {

    var firstDayOfEveryWeek: DateComponents {
        DateComponents(hour: 0, minute: 0, second: 0, weekday: firstWeekday)
    }

}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DarkThemePreview {
                MonthView()
                    .environmentObject(
                        MonthCalendarManager(
                            configuration: .mock,
                            month: Date()
                        )
                    )
            }

            DarkThemePreview {
                MonthView()
                    .environmentObject(
                        MonthCalendarManager(
                            configuration: .mock,
                            month: Date().addingTimeInterval(60*60*24*45)
                        )
                    )
            }
        }
    }
}
