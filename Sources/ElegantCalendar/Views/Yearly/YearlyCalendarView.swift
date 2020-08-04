// Kevin Li - 9:22 PM - 6/13/20

import SwiftUI

public struct YearlyCalendarView: View, YearlyCalendarManagerDirectAccess {

    var theme: CalendarTheme = .default
    public var axis: Axis = .vertical

    @ObservedObject public var calendarManager: YearlyCalendarManager

    private var isTodayWithinDateRange: Bool {
        Date() >= calendar.startOfDay(for: startDate) &&
            calendar.startOfDay(for: Date()) <= endDate
    }

    private var isCurrentYearSameAsTodayYear: Bool {
        calendar.isDate(currentYear, equalTo: Date(), toGranularities: [.year])
    }

    public init(calendarManager: YearlyCalendarManager) {
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
        YearlyCalendarScrollView(axis, calendarManager: calendarManager) {
            self.yearsStack
        }
        .frame(width: CalendarConstants.Yearly.cellWidth,
               height: CalendarConstants.cellHeight)
    }

    private var yearsStack: some View {
        Group {
            if axis == .vertical {
                VStack(spacing: 0) {
                    calendarContent
                }
            } else {
                HStack(spacing: 0) {
                    calendarContent
                }
            }
        }
    }

    private var calendarContent: some View {
        ForEach(self.years, id: \.self) { year in
            YearView(calendarManager: self.calendarManager, year: year)
                .environment(\.calendarTheme, self.theme)
        }
    }

    private var scrollBackToTodayButton: some View {
        ScrollBackToTodayButton(scrollBackToToday: calendarManager.scrollBackToToday,
                                color: theme.primary)
    }

}

private struct YearlyCalendarScrollView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UIScrollViewViewController

    @ObservedObject var calendarManager: YearlyCalendarManager

    let axis: Axis
    let content: AnyView

    var pageLength: CGFloat {
        (axis == .vertical) ? CalendarConstants.cellHeight : CalendarConstants.Yearly.cellWidth
    }

    var destinationOffset: CGFloat {
        pageLength * CGFloat(calendarManager.currentPage.index)
    }

    init<Content: View>(_ axis: Axis, calendarManager: YearlyCalendarManager, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.calendarManager = calendarManager
        self.content = AnyView(content())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIScrollViewViewController {
        UIScrollViewViewController(axis, content: content, delegate: context.coordinator)
    }

    func updateUIViewController(_ viewController: UIScrollViewViewController, context: Context) {
        viewController.hosting.rootView = content

        switch calendarManager.currentPage.state {
        case .scroll:
            let destinationPoint: CGPoint
            if axis == .vertical {
                destinationPoint = CGPoint(x: 0, y: destinationOffset)
            } else {
                destinationPoint = CGPoint(x: destinationOffset, y: 0)
            }

            DispatchQueue.main.async {
                viewController.scrollView.setContentOffset(destinationPoint,
                                                           animated: true)
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
            let contentOffset = (parent.axis == .vertical) ? scrollView.contentOffset.y : scrollView.contentOffset.x
            let page = Int(contentOffset / parent.pageLength)
            calendarManager.willDisplay(page: page)
        }

        // Called after the `scrollToToday` or any `scrollToYear` animation finishes
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            if calendarManager.currentPage.state == .scroll {
                let page = Int(parent.destinationOffset / parent.pageLength)
                calendarManager.willDisplay(page: page)
            }
        }

    }

}

private class UIScrollViewViewController: UIViewController {

    let hosting: UIHostingController<AnyView>
    let scrollView: UIScrollView

    init(_ axis: Axis, content: AnyView, delegate: UIScrollViewDelegate) {
        hosting = UIHostingController(rootView: content)
        scrollView = UIScrollView().withPagination(delegate: delegate)
        super.init(nibName: nil, bundle: nil)

        let fittingSize: CGSize
        if axis == .vertical {
            fittingSize = CGSize(width: screen.width, height: .greatestFiniteMagnitude)
        } else {
            fittingSize = CGSize(width: .greatestFiniteMagnitude, height: screen.height)
        }

        let size = hosting.view.sizeThatFits(fittingSize)
        hosting.view.frame = CGRect(x: 0, y: 0,
                                    width: size.width,
                                    height: size.height)

        scrollView.addSubview(hosting.view)
        scrollView.contentSize = CGSize(width: size.width, height: size.height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        pinEdges(of: scrollView, to: view)

        hosting.willMove(toParent: self)
        scrollView.addSubview(hosting.view)
        pinEdges(of: hosting.view, to: scrollView)
        hosting.didMove(toParent: self)
    }

    func pinEdges(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
        ])
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
