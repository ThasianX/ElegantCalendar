// Kevin Li - 3:53 PM - 6/20/20

import SwiftUI

protocol ElegantPagerProvider: ObservableObject {

    var currentPage: Int { get }
    var pageCount: Int { get }
    func view(for page: Int) -> AnyView

    func willDisplay(page: Int)

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
fileprivate let pageTurnCutOff: CGFloat = 120
fileprivate let pageTurnAnimation: Animation = .interactiveSpring(response: 0.15, dampingFraction: 1.5, blendDuration: 0.25)

struct ElegantPagedScrollView<Provider>: View where Provider: ElegantPagerProvider {

    @State private var activeIndex: Int = 0
    @State private var translation: CGFloat = .zero
    @State private var isTurningPage = false
    @ObservedObject var provider: Provider

    private var pageOffset: CGFloat {
        return -CGFloat(activeIndex) * screen.height
    }

    private var currentScrollOffset: CGFloat {
        pageOffset + translation
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ElegantPagerView(provider: provider, activeIndex: $activeIndex)
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
            guard provider.currentPage != 0 else { return }

            scroll(direction: .up)
        } else if offset < 0 && offset < -pageTurnCutOff {
            guard provider.currentPage != provider.pageCount-1 else { return }

            scroll(direction: .down)
        }
    }

    private func scroll(direction: ScrollDirection) {
        isTurningPage = true // Prevents user drag from continuing
        translation = .zero
        activeIndex = (activeIndex + direction.additiveFactor).clamped(to: 0...2)

        provider.willDisplay(page: activeIndex)
    }

}

struct ElegantPagerView<Provider>: UIViewControllerRepresentable where Provider: ElegantPagerProvider {

    fileprivate typealias UIViewControllerType = ElegantPagerController

    // See https://stackoverflow.com/questions/58635048/in-a-uiviewcontrollerrepresentable-how-can-i-pass-an-observedobjects-value-to
    private let bugFix = UpdateUIViewControllerBugFixClass()

    @ObservedObject var provider: Provider
    @Binding var activeIndex: Int

    func makeUIViewController(context: Context) -> ElegantPagerController<Provider> {
        ElegantPagerController(provider: provider)
    }

    func updateUIViewController(_ uiViewController: ElegantPagerController<Provider>, context: Context) {
        uiViewController.rearrange(provider: provider) {
            DispatchQueue.main.async {
                self.activeIndex = 1 // resets view to center
            }
        }
    }

}

class ElegantPagerController<Provider>: UIViewController where Provider: ElegantPagerProvider {

    private var controllers: [UIHostingController<AnyView>]
    private var previousPage: Int

    init(provider: Provider) {
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

    func rearrange(provider: Provider, completion: @escaping () -> Void) {
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
