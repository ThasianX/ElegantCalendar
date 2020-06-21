// Kevin Li - 3:53 PM - 6/20/20

import SwiftUI

protocol ElegantPagerDataSource {

    func view(for page: Int) -> AnyView

}

protocol ElegantPagerDelegate {

    func willDisplay(page: Int)

}

enum PageState {

    case rearrange
    case scroll
    case completed

}

class ElegantPagerManager: ObservableObject {

    @Published var currentPage: (index: Int, state: PageState)
    let pageCount: Int

    var datasource: ElegantPagerDataSource!
    var delegate: ElegantPagerDelegate?

    init(startingPage: Int = 0, pageCount: Int) {
        currentPage = (startingPage, .completed)
        self.pageCount = pageCount
    }

    func scroll(to page: Int) {
        currentPage = (page, .scroll)
        delegate?.willDisplay(page: page)
    }

    func setUserDraggedPage(_ page: Int) {
        var currentIndex = currentPage.index

        if page == 1 {
            if currentIndex == 0 {
                // just scrolled from first page to second page
                currentIndex += 1
            } else if currentIndex == pageCount-1 {
                // just scrolled from last page to second to last page
                currentIndex -= 1
            } else {
                return
            }
        } else {
            if page == 0 {
                guard currentIndex != 0 else { return }
                // case where you're on the first page and you drag and stay on the first page
                currentIndex -= 1
            } else if page == 2 {
                guard currentIndex != pageCount-1 else { return }
                // case where you're on the first page and you drag and stay on the first page
                currentIndex += 1
            }
        }

        currentPage = (currentIndex, .rearrange)
        delegate?.willDisplay(page: currentPage.index)
    }

}

protocol ElegantPagerManagerDirectAccess {

    var pagerManager: ElegantPagerManager { get }

}

extension ElegantPagerManagerDirectAccess {

    var currentPage: (index: Int, state: PageState) {
        pagerManager.currentPage
    }

    var pageCount: Int {
        pagerManager.pageCount
    }

}

private class UpdateUIViewControllerBugFixClass { }

private enum ScrollDirection {

    case up
    case down

    var additiveFactor: Int {
        self == .up ? -1 : 1
    }

}

fileprivate let scrollResistanceCutOff: CGFloat = 40
fileprivate let pageTurnCutOff: CGFloat = 80
fileprivate let pageTurnAnimation: Animation = .interactiveSpring(response: 0.15, dampingFraction: 1.5, blendDuration: 0.25)

struct ElegantPagedScrollView: View, ElegantPagerManagerDirectAccess {

    @State private var activeIndex: Int = 0
    @State private var translation: CGFloat = .zero
    @State private var isTurningPage = false

    @ObservedObject var pagerManager: ElegantPagerManager

    private var pageOffset: CGFloat {
        return -CGFloat(activeIndex) * screen.height
    }

    private var currentScrollOffset: CGFloat {
        pageOffset + translation
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ElegantPagerView(pagerManager: pagerManager, activeIndex: $activeIndex)
                .frame(height: screen.height*3)
        }
        .frame(height: screen.height, alignment: .top)
        .offset(y: currentScrollOffset)
        .gesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    withAnimation(pageTurnAnimation) {
                        self.translation = self.resistanceTranslationForOffset(value.translation.height)
                        self.turnPageIfNeededForOffset(value.translation.height)
                    }
                }
                .onEnded { value in
                    withAnimation(pageTurnAnimation) {
                        self.translation = .zero
                        self.isTurningPage = false
                    }
                }
        )
    }

    private func resistanceTranslationForOffset(_ offset: CGFloat) -> CGFloat {
        guard !isTurningPage else { return 0 }
        return (offset / pageTurnCutOff) * scrollResistanceCutOff
    }

    private func turnPageIfNeededForOffset(_ offset: CGFloat) {
        guard !isTurningPage else { return }

        if offset > 0 && offset > pageTurnCutOff {
            guard currentPage.index != 0 else { return }

            scroll(direction: .up)
        } else if offset < 0 && offset < -pageTurnCutOff {
            guard currentPage.index != pageCount-1 else { return }

            scroll(direction: .down)
        }
    }

    private func scroll(direction: ScrollDirection) {
        isTurningPage = true // Prevents user drag from continuing
        translation = .zero
        activeIndex = (activeIndex + direction.additiveFactor).clamped(to: 0...2)

        pagerManager.setUserDraggedPage(activeIndex)
    }

}

struct ElegantPagerView: UIViewControllerRepresentable, ElegantPagerManagerDirectAccess {

    typealias UIViewControllerType = ElegantPagerController

    // See https://stackoverflow.com/questions/58635048/in-a-uiviewcontrollerrepresentable-how-can-i-pass-an-observedobjects-value-to
    private let bugFix = UpdateUIViewControllerBugFixClass()

    @ObservedObject var pagerManager: ElegantPagerManager
    @Binding var activeIndex: Int

    func makeUIViewController(context: Context) -> ElegantPagerController {
        ElegantPagerController(provider: pagerManager)
    }

    func updateUIViewController(_ controller: ElegantPagerController, context: Context) {
        DispatchQueue.main.async {
            self.setProperPage(for: controller)
        }
    }

    private func setProperPage(for controller: ElegantPagerController) {
        switch currentPage.state {
        case .rearrange:
            controller.rearrange(provider: pagerManager) {
                self.setActiveIndex(1, animated: false, complete: true) // resets to center
            }
        case .scroll:
            if currentPage.index == 0 || currentPage.index == pageCount-1 {
                let pageToTurnTo = currentPage.index == 0 ? 0 : 2
                setActiveIndex(pageToTurnTo, animated: true, complete: true)
                controller.reset(provider: pagerManager)
            } else {
                let pageToTurnTo = currentPage.index > controller.previousPage ? 2 : 0
                setActiveIndex(pageToTurnTo, animated: true, complete: false)
                controller.reset(provider: pagerManager) {
                    self.setActiveIndex(1, animated: false, complete: true)
                }
            }
        case .completed:
            ()
        }
    }

    private func setActiveIndex(_ index: Int, animated: Bool, complete: Bool) {
        withAnimation(animated ? pageTurnAnimation : nil) {
            self.activeIndex = index
        }

        if complete {
            self.pagerManager.currentPage.state = .completed
        }
    }

}

class ElegantPagerController: UIViewController {

    private var controllers: [UIHostingController<AnyView>]
    private(set) var previousPage: Int

    init(provider: ElegantPagerManager) {
        previousPage = provider.currentPage.index

        // TODO: Fix this starting page stuff
        let trailingPage = previousPage+2.clamped(to: 0...provider.pageCount-1)
        controllers = (previousPage...trailingPage).map { page in
            UIHostingController(rootView: provider.datasource.view(for: page))
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

    func rearrange(provider: ElegantPagerManager, completion: @escaping () -> Void) {
        defer {
            previousPage = provider.currentPage.index

        }

        // rearrange if...
        guard provider.currentPage.index != previousPage && // not same page
            (previousPage != 0 &&
                provider.currentPage.index != 0) && // not 1st or 2nd page
            (previousPage != provider.pageCount-1 &&
                provider.currentPage.index != provider.pageCount-1) // not last page or 2nd to last page
        else { return }

        if provider.currentPage.index > previousPage { // scrolled down
            controllers.append(controllers.removeFirst())
            controllers.last!.rootView = provider.datasource.view(for: provider.currentPage.index+1)
        } else { // scrolled up
            controllers.insert(controllers.removeLast(), at: 0)
            controllers.first!.rootView = provider.datasource.view(for: provider.currentPage.index-1)
        }

        resetPositions()
        completion()
    }

    func resetPositions() {
        controllers.enumerated().forEach { i, controller in
            controller.view.frame.origin = CGPoint(x: 0, y: CalendarConstants.cellHeight * CGFloat(i))
        }
    }

    func reset(provider: ElegantPagerManager, completion: (() -> Void)? = nil) {
        defer {
            previousPage = provider.currentPage.index
        }

        let startingPage: Int

        if provider.currentPage.index == 0 {
            startingPage = 0
        } else if provider.currentPage.index == provider.pageCount-1 {
            startingPage = provider.pageCount-3
        } else {
            startingPage = provider.currentPage.index-1
        }

        zip(controllers, (startingPage...startingPage+2)).forEach { controller, page in
            controller.rootView = provider.datasource.view(for: page)
        }

        completion?()
    }

}
