// Kevin Li - 9:22 PM - 6/13/20

import SwiftUI

public struct YearlyCalendarView: View, YearlyCalendarManagerDirectAccess {

    var theme: CalendarTheme = .brilliantViolet

    @ObservedObject public var calendarManager: YearlyCalendarManager

    private var isTodayWithinDateRange: Bool {
        Date() >= calendar.startOfDay(for: startDate) &&
            calendar.startOfDay(for: Date()) <= endDate
    }

    private var isCurrentYearSameAsTodayYear: Bool {
        calendar.isDate(currentYear, equalTo: Date(), toGranularities: [.year])
    }

    public init(theme: CalendarTheme = .brilliantViolet, calendarManager: YearlyCalendarManager) {
        self.theme = theme
        self.calendarManager = calendarManager
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            yearsList
                .zIndex(0)
            if isTodayWithinDateRange && !isCurrentYearSameAsTodayYear {
                scrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.Yearly.outerHorizontalPadding)
                    .offset(y: CalendarConstants.Yearly.topPadding + 10)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    private var yearsList: some View {
        YearlyCalendarScrollView(calendarManager: calendarManager) {
            ForEach(self.years, id: \.self) { year in
                YearView(calendarManager: self.calendarManager, year: year)
                    .environment(\.calendarTheme, self.theme)
            }
        }
        .frame(width: CalendarConstants.cellWidth,
               height: CalendarConstants.cellHeight)
    }

    private var scrollBackToTodayButton: some View {
        ScrollBackToTodayButton(scrollBackToToday: calendarManager.scrollBackToToday,
                                color: theme.primary)
    }

}

private struct YearlyCalendarScrollView: UIViewRepresentable {

    typealias UIViewType = UIScrollView

    @ObservedObject var calendarManager: YearlyCalendarManager

    let content: AnyView

    init<Content: View>(calendarManager: YearlyCalendarManager, @ViewBuilder content: @escaping () -> Content) {
        self.calendarManager = calendarManager
        self.content = AnyView(content())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let hosting = UIHostingController(rootView: content)

        let size = hosting.view.sizeThatFits(CGSize(width: screen.width, height: .greatestFiniteMagnitude))
        hosting.view.frame = CGRect(x: 0, y: 0,
                                    width: screen.width,
                                    height: size.height)

        let scrollView = UIScrollView().withPagination(delegate: context.coordinator)
        scrollView.addSubview(hosting.view)
        scrollView.contentSize = CGSize(width: screen.width, height: size.height)

        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        switch calendarManager.currentPage.state {
        case .scroll:
            DispatchQueue.main.async {
                scrollView.setContentOffset(CGPoint(x: 0, y: self.calendarManager.destinationOffset), animated: true)
            }
        case .completed:
            ()
        }
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        
        let parent: YearlyCalendarScrollView

        private var calendarManager: YearlyCalendarManager {
            parent.calendarManager
        }

        init(parent: YearlyCalendarScrollView) {
            self.parent = parent
        }

        // Called after the user manually drags from one page to another
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page = Int(scrollView.contentOffset.y / CalendarConstants.cellHeight)
            calendarManager.willDisplay(page: page)
        }

        // Called after the `scrollToToday` or any `scrollToYear` animation finishes
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            if calendarManager.currentPage.state == .scroll {
                let page = Int(calendarManager.destinationOffset / CalendarConstants.cellHeight)
                calendarManager.willDisplay(page: page)
            }
        }

    }

}

private extension YearlyCalendarManager {

    var destinationOffset: CGFloat {
        CalendarConstants.cellHeight * CGFloat(currentPage.index)
    }

}

private extension UIScrollView {

    func withPagination(delegate: UIScrollViewDelegate) -> UIScrollView {
        backgroundColor = .none
        scrollsToTop = false
        bounces = false

        contentInsetAdjustmentBehavior = .never

        isPagingEnabled = true
        decelerationRate = .fast

        self.delegate = delegate

        return self
    }

}

struct YearlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        // Only run one calendar at a time. SwiftUI has a limit for rendering time
        Group {

//            LightThemePreview {
//                YearlyCalendarView(calendarManager: .mock)
//
//                YearlyCalendarView(calendarManager: .mockWithInitialYear)
//            }

            DarkThemePreview {
//                YearlyCalendarView(calendarManager: .mock)

                YearlyCalendarView(calendarManager: .mockWithInitialYear)
            }

        }
    }
}
