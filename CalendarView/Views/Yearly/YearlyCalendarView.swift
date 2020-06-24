// Kevin Li - 9:22 PM - 6/13/20

import SwiftUI

struct YearlyCalendarView: View, YearlyCalendarManagerDirectAccess {

    @ObservedObject var calendarManager: YearlyCalendarManager

    private var isTodayWithinDateRange: Bool {
        Date() >= startDate && Date() <= endDate
    }

    private var isCurrentYearSameAsTodayYear: Bool {
        calendar.isDate(currentYear, equalTo: Date(), toGranularities: [.year])
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            yearsList
                .zIndex(0)
            if isTodayWithinDateRange && !isCurrentYearSameAsTodayYear {
                scrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.horizontalPadding)
                    .offset(y: CalendarConstants.Yearly.topPadding)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    private var yearsList: some View {
        YearlyCalendarScrollView(calendarManager: calendarManager) {
            ForEach(self.years, id: \.self) { year in
                YearView(calendarManager: self.calendarManager, year: year)
            }
        }
        .frame(width: CalendarConstants.cellWidth,
               height: CalendarConstants.cellHeight)
    }

    private var scrollBackToTodayButton: some View {
        ScrollBackToTodayButton(scrollBackToToday: calendarManager.scrollBackToToday,
                                    color: themeColor)
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
        let offset = CalendarConstants.cellHeight * CGFloat(calendarManager.currentPage)
        DispatchQueue.main.async {
            scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        
        let parent: YearlyCalendarScrollView

        init(parent: YearlyCalendarScrollView) {
            self.parent = parent
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page = Int(scrollView.contentOffset.y / CalendarConstants.cellHeight)
            parent.calendarManager.willDisplay(page: page)
        }

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
