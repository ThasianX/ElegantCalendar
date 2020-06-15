// Kevin Li - 6:19 PM - 6/6/20

import Introspect
import SwiftUI

struct ElegantCalendarView: View {

    @State var activeIndex: Int = 1
    @State var translation: CGFloat = .zero

    var pagerWidth: CGFloat {
        CalendarConstants.cellWidth
    }

    @ObservedObject var calendarManager: ElegantCalendarManager

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

    var body: some View {
        pagerHorizontalStack
            .frame(width: pagerWidth, alignment: .leading)
            .offset(x: pageOffset)
            .offset(x: boundedTranslation)
            .animation(.easeInOut)
            .gesture(
                DragGesture().onChanged { value in
                    // `value` refers to the current data for the drag
                    self.translation = value.translation.width
                }.onEnded { _ in
                    self.onDragEnded()
                }
            )
            // These extra gestures to prevent bug where drag gesture isn't cancelled when it should
            .simultaneousGesture(
                MagnificationGesture().onChanged { _ in
                    self.onDragEnded()
                }.onEnded { _ in
                    self.onDragEnded()
                }
            )
            .simultaneousGesture(
                RotationGesture().onChanged { _ in
                    self.onDragEnded()
                }.onEnded { _ in
                    self.onDragEnded()
                }
            )
    }

    private func onDragEnded() {
        let pageTurnDelta = translation / pagerWidth
        // If the user has turned the page more than halfway, in which case
        // `pageTurnDelta` > .5, we want to set the page that is being
        // turned to as the new active page
        let newIndex = Int((CGFloat(activeIndex) - pageTurnDelta).rounded())
        // we don't want the index to be greater than 1 or less than 0
        activeIndex = min(max(newIndex, 0), 1)
        translation = .zero
    }

    private var pagerHorizontalStack: some View {
        HStack(alignment: .center, spacing: 0) {
            yearlyCalendarView
                .frame(width: CalendarConstants.cellWidth)
            monthlyCalendarView
                .frame(width: CalendarConstants.cellWidth)
        }
    }

    private var monthlyCalendarView: some View {
        MonthlyCalendarView(initialMonth: initialMonth)
            .environmentObject(calendarManager.monthlyManager)
    }

    private var yearlyCalendarView: some View {
        YearlyCalendarView()
            .environmentObject(calendarManager.yearlyManager)
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
