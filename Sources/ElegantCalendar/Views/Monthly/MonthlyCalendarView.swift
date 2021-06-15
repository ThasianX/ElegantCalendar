// Kevin Li - 2:26 PM - 6/14/20

import ElegantPages
import SwiftUI

public struct MonthlyCalendarView<HeaderView: View>: View, MonthlyCalendarManagerDirectAccess {

    let headerView: () -> HeaderView
    var theme: CalendarTheme = .default
    public var axis: Axis = .vertical

    @ObservedObject public var calendarManager: MonthlyCalendarManager

    private var isTodayWithinDateRange: Bool {
        Date() >= calendar.startOfDay(for: startDate) &&
            calendar.startOfDay(for: Date()) <= endDate
    }

    private var isCurrentMonthYearSameAsTodayMonthYear: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    public init(calendarManager: MonthlyCalendarManager,
                @ViewBuilder headerView: @escaping () -> HeaderView) {
        self.headerView = headerView
        self.calendarManager = calendarManager
    }

    public var body: some View {
        GeometryReader { geometry in
            self.content(geometry: geometry)
        }
    }

    private func content(geometry: GeometryProxy) -> some View {
        CalendarConstants.Monthly.cellWidth = geometry.size.width

        return ZStack(alignment: .top) {
            VStack {
                monthsList
                Spacer()
            }
            if isTodayWithinDateRange && !isCurrentMonthYearSameAsTodayMonthYear {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.Monthly.outerHorizontalPadding)
                    .offset(y: CalendarConstants.Monthly.topPadding + 3)
                    .transition(.opacity)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var monthsList: some View {
        Group {
            if axis == .vertical {
                ElegantVList(manager: listManager,
                             pageTurnType: .monthlyEarlyCutoff,
                             viewForPage: monthView)
                    .onPageChanged(configureNewMonth)
                    .frame(width: CalendarConstants.Monthly.cellWidth)
            } else {
                ElegantHList(manager: listManager,
                             pageTurnType: .monthlyEarlyCutoff,
                             viewForPage: monthView)
                    .onPageChanged(configureNewMonth)
                    .frame(width: CalendarConstants.Monthly.cellWidth)
            }
        }
    }

    private func monthView(for page: Int) -> AnyView {
        return AnyView(VStack(spacing: 0) {
            MonthView(calendarManager: calendarManager, month: months[page], headerView: headerView)
                .environment(\.calendarTheme, theme)
                .erased
        })
    }

    private var leftAlignedScrollBackToTodayButton: some View {
        HStack {
            Spacer()
            ScrollBackToTodayButton(scrollBackToToday: scrollBackToToday,
                                    color: theme.primary)
        }
    }

}

private extension PageTurnType {

    static var monthlyEarlyCutoff: PageTurnType = .earlyCutoff(config: .monthlyConfig)

}

public extension EarlyCutOffConfiguration {

    static let monthlyConfig = EarlyCutOffConfiguration(
        scrollResistanceCutOff: 40,
        pageTurnCutOff: 80,
        pageTurnAnimation: .spring(response: 0.3, dampingFraction: 0.95))

}

extension MonthlyCalendarView where HeaderView == EmptyView {
    init(calendarManager: MonthlyCalendarManager) {
        self.init(calendarManager: calendarManager, headerView: { EmptyView() })
    }
}
