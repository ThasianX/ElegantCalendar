// Kevin Li - 6:56 PM - 6/13/20

import SwiftUI

struct YearView: View, YearlyCalendarManagerDirectAccess {

    @Environment(\.calendarTheme) var theme: CalendarTheme

    let calendarManager: YearlyCalendarManager

    let year: Date

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
        .frame(width: CalendarConstants.Yearly.cellWidth, height: CalendarConstants.cellHeight)
    }

    private var yearText: some View {
        Text(year.year)
            .font(.system(size: 38, weight: .thin, design: .rounded))
            .foregroundColor(isYearSameAsTodayYear ? theme.primary : .primary)
    }

    private var monthsStack: some View {
        let months: [Date]
        if let yearInterval = calendar.dateInterval(of: .year, for: year) {
            months = calendar.generateDates(
                inside: yearInterval,
                matching: .firstDayOfEveryMonth)
        } else {
            months = []
        }

        return VStack(spacing: CalendarConstants.Yearly.monthsGridSpacing) {
            ForEach(0..<CalendarConstants.Yearly.monthsInColumn, id: \.self) { row in
                HStack(spacing: CalendarConstants.Yearly.monthsGridSpacing) {
                    ForEach(0..<CalendarConstants.Yearly.monthsInRow, id: \.self) { col in
                        SmallMonthView(calendarManager: self.calendarManager, month: months[row*CalendarConstants.Yearly.monthsInRow + col])
                    }
                }
            }
        }
    }
    
}

struct YearView_Previews: PreviewProvider {
    static var previews: some View {
        LightDarkThemePreview {
            YearView(calendarManager: .mock, year: Date())

            YearView(calendarManager: .mock, year: .daysFromToday(365))
        }
    }
}
