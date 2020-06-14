// Kevin Li - 6:56 PM - 6/13/20

import SwiftUI

struct YearView: View, CalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: ElegantCalendarManager
    
    let year: Date

    private var months: [Date] {
        guard let yearInterval = calendar.dateInterval(of: .year, for: year) else {
            return []
        }
        return generateDates(
            inside: yearInterval,
            matching: .firstDayOfEveryMonth)
    }

    private var isYearSameAsTodayYear: Bool {
        calendar.isDate(year, equalTo: Date(), toGranularities: [.year])
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            yearText
            monthsStack
            Spacer()
        }
        .padding(.top, CalendarConstants.Yearly.topPadding)
        .frame(width: CalendarConstants.cellWidth, height: CalendarConstants.cellHeight)
    }

    private var yearText: some View {
        Text(year.year)
            .font(.system(size: 38, weight: .thin, design: .rounded))
            .foregroundColor(isYearSameAsTodayYear ? themeColor : .white)
    }

    private var monthsStack: some View {
        VStack(spacing: CalendarConstants.Yearly.monthsGridSpacing) {
            ForEach(0..<CalendarConstants.Yearly.monthsInColumn, id: \.self) { row in
                HStack(spacing: CalendarConstants.Yearly.monthsGridSpacing) {
                    ForEach(0..<CalendarConstants.Yearly.monthsInRow, id: \.self) { col in
                        SmallMonthView(month: self.month(at: row, col: col))
                            .listRowInsets(EdgeInsets())
                    }
                }
            }
        }
    }

    private func month(at row: Int, col: Int) -> Date {
        months[row*CalendarConstants.Yearly.monthsInRow + col]
    }
    
}

struct YearView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarManagerGroup {
            DarkThemePreview {
                YearView(year: Date())
            }

            DarkThemePreview {
                YearView(year: .daysFromToday(365*3))
            }
        }

    }
}
