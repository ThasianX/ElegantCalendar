// Kevin Li - 6:19 PM - 6/6/20

import Introspect
import SwiftUI

fileprivate let scrollDampingFactor: CGFloat = 0.66

struct ElegantCalendarView: View, PagerStateDirectAccess {

    @ObservedObject var calendarManager: ElegantCalendarManager

    var pagerState: PagerState {
        calendarManager.pagerState
    }

    var initialMonth: Date? = nil

    init(calendarManager: ElegantCalendarManager, initialMonth: Date? = nil) {
        self.calendarManager = calendarManager
        self.initialMonth = initialMonth
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
            .animation(.interpolatingSpring(mass: 0.1, stiffness: 20, damping: 2, initialVelocity: 0))
            .simultaneousGesture(
                DragGesture(minimumDistance: 1, coordinateSpace: .local)
                    .onChanged { value in
                        self.pagerState.translation = value.translation.width
                    }
                    .onEnded { value in
                        let velocityDiff = (value.predictedEndTranslation.width - self.translation) * scrollDampingFactor
                        let newPageIndex = self.indexPageForOffset(self.currentScrollOffset + velocityDiff)

                        self.pagerState.translation = .zero
                        self.pagerState.activeIndex = min(max(newPageIndex, 0), 1)
                    }
        )
    }

    private func indexPageForOffset(_ offset : CGFloat) -> Int {
        let pageTurnDelta = translation / pagerWidth
        let turnCutOff: CGFloat = (pageTurnDelta < 0) ? 0.3 : -0.3
        return Int((CGFloat(activeIndex) - pageTurnDelta + turnCutOff).rounded())
    }

    private var pagerHorizontalStack: some View {
        HStack(alignment: .center, spacing: 0) {
            yearlyCalendarView
                .frame(width: CalendarConstants.cellWidth)
            monthlyCalendarView
                .frame(width: CalendarConstants.cellWidth)
        }
    }

    private var yearlyCalendarView: some View {
        YearlyCalendarView()
            .environmentObject(calendarManager.yearlyManager)
    }

    private var monthlyCalendarView: some View {
        MonthlyCalendarView(initialMonth: initialMonth)
            .environmentObject(calendarManager.monthlyManager)
    }

}


struct ElegantCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DarkThemePreview {
            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock))
            
            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock),
                                initialMonth: .daysFromToday(90))
        }
    }
}
