// Kevin Li - 6:19 PM - 6/6/20

import SwiftUI

fileprivate let scrollResistanceCutOff: CGFloat = 40
fileprivate let pageTurnCutOff: CGFloat = 180

struct ElegantCalendarView: View, PagerStateDirectAccess {

    @ObservedObject var calendarManager: ElegantCalendarManager

    var pagerState: PagerState {
        calendarManager.pagerState
    }

    private var pageOffset: CGFloat {
        return -CGFloat(activeIndex) * pagerWidth
    }

    private var boundedTranslation: CGFloat {
        if (activeIndex == 0 && translation > 0) ||
            (activeIndex == 1 && translation < 0) {
            return 0
        }
        return translation
    }

    private var currentScrollOffset: CGFloat {
        pageOffset + boundedTranslation
    }

    var body: some View {
        pagerHorizontalStack
            .frame(width: pagerWidth, alignment: .leading)
            .offset(x: currentScrollOffset)
            .gesture( // TODO: Fix this gesture from interfering with existing list gestures
                DragGesture(minimumDistance: 1, coordinateSpace: .local)
                    .onChanged { value in
                        withAnimation(CalendarConstants.calendarTurnAnimation) {
                            self.pagerState.translation = self.resistanceTranslationForOffset(value.translation.width)
                            self.turnPageIfNeededForOffset(value.translation.width)
                        }
                    }
                    .onEnded { value in
                        withAnimation(CalendarConstants.calendarTurnAnimation) {
                            self.pagerState.translation = .zero
                        }
                    }
            )
    }

    private var pagerHorizontalStack: some View {
        HStack(alignment: .center, spacing: 0) {
            yearlyCalendarView
                .frame(width: CalendarConstants.cellWidth,
                       height: CalendarConstants.cellHeight)
            monthlyCalendarView
                .frame(width: CalendarConstants.cellWidth,
                       height: CalendarConstants.cellHeight)
        }
    }

    private var yearlyCalendarView: some View {
        YearlyCalendarView()
            .environmentObject(calendarManager.yearlyManager)
    }

    private var monthlyCalendarView: some View {
        MonthlyCalendarView()
            .environmentObject(calendarManager.monthlyManager)
    }

    private func resistanceTranslationForOffset(_ offset: CGFloat) -> CGFloat {
        (offset / pageTurnCutOff) * scrollResistanceCutOff
    }

    private func turnPageIfNeededForOffset(_ offset: CGFloat) {
        if offset > 0 && offset > pageTurnCutOff {
            pagerState.translation = .zero
            pagerState.activeIndex = 0
        } else if offset < 0 && offset < -pageTurnCutOff {
            pagerState.translation = .zero
            pagerState.activeIndex = 1
        }
    }

}


struct ElegantCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DarkThemePreview {
            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock))

            // TODO :update models here
            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock))
        }
    }
}
