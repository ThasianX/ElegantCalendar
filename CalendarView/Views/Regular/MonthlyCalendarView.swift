// Kevin Li - 2:26 PM - 6/14/20

import Combine
import SwiftUI

private class UpdateUIViewControllerBugFixClass { }

struct PagedMonthsView: UIViewControllerRepresentable {

    typealias UIViewControllerType = ElegantPagerController

    // See https://stackoverflow.com/questions/58635048/in-a-uiviewcontrollerrepresentable-how-can-i-pass-an-observedobjects-value-to
    private let bugFix = UpdateUIViewControllerBugFixClass()

    @EnvironmentObject var calendarManager: MonthlyCalendarManager

    func makeUIViewController(context: Context) -> ElegantPagerController {
        ElegantPagerController(provider: calendarManager)
    }

    func updateUIViewController(_ uiViewController: ElegantPagerController, context: Context) {
        uiViewController.rearrange(provider: calendarManager) {
            self.calendarManager.resetToCenter()
        }
    }

}

protocol ElegantPagerProvider {

    var currentPage: Int { get }
    var pageCount: Int { get }
    func view(for page: Int) -> AnyView

}

class ElegantPagerController: UIViewController {

    private var controllers: [UIHostingController<AnyView>]
    private var previousPage: Int

    init(provider: ElegantPagerProvider) {
        previousPage = provider.currentPage

        let trailingPage = previousPage+2.clamped(to: 0...provider.pageCount-1)
        controllers = (previousPage...trailingPage).map { page in
            UIHostingController(rootView: provider.view(for: page))
        }
        super.init(nibName: nil, bundle: nil)

        controllers.enumerated().forEach { i, controller in
            addChild(controller)

            controller.view.frame = CGRect(x: 0, y: 0, width: CalendarConstants.cellWidth, height: CalendarConstants.cellHeight)
            controller.view.frame.origin = CGPoint(x: 0, y: CalendarConstants.cellHeight * CGFloat(i))

            view.addSubview(controller.view)
            controller.didMove(toParent: self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rearrange(provider: ElegantPagerProvider, completion: @escaping () -> Void) {
        defer {
            previousPage = provider.currentPage
        }

        // rearrange if...
        guard provider.currentPage != previousPage && // not same page
            (previousPage != 0 &&
                provider.currentPage != 0) && // not 1st or 2nd page
            (previousPage != provider.pageCount-1 &&
                provider.currentPage != provider.pageCount-1) // not last page or 2nd to last page
        else { return }

        if provider.currentPage > previousPage { // scrolled down
            controllers.append(controllers.removeFirst())
            controllers.last!.rootView = provider.view(for: provider.currentPage+1)
        } else { // scrolled up
            controllers.insert(controllers.removeLast(), at: 0)
            controllers.first!.rootView = provider.view(for: provider.currentPage-1)
        }

        resetPositions()
        completion()
    }

    func resetPositions() {
        controllers.enumerated().forEach { i, controller in
            controller.view.frame.origin = CGPoint(x: 0, y: CalendarConstants.cellHeight * CGFloat(i))
        }
    }

    func scroll(to page: Int) {

    }

}

struct MonthlyCalendarView: View, MonthlyCalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: MonthlyCalendarManager

    var initialMonth: Date? = nil

    private var isCurrentMonthYearSameAsTodayMonthYear: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        ZStack(alignment: .top) {
            monthsList
                .zIndex(0)
            if !isCurrentMonthYearSameAsTodayMonthYear {
                leftAlignedScrollBackToTodayButton
                    .padding(.trailing, CalendarConstants.Monthly.scrollButtonTrailingPadding)
                    .offset(y: CalendarConstants.Monthly.scrollButtonOffset)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    private var monthsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            PagedMonthsView()
                .frame(height: CalendarConstants.cellHeight*3)
        }
        .introspectScrollView { scrollView in
            self.calendarManager.attach(to: scrollView, with: self.initialMonth)
        }
    }

    private var leftAlignedScrollBackToTodayButton: some View {
        HStack {
            Spacer()
            ScrollBackToTodayButton(scrollBackToToday: calendarManager.scrollBackToToday,
                                    color: themeColor)
        }
    }

}

struct MonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyCalendarManagerGroup {
            DarkThemePreview {
                MonthlyCalendarView()
            }

            DarkThemePreview {
                MonthlyCalendarView(initialMonth: .daysFromToday(90))
            }
        }
    }
}
