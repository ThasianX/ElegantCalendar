// Kevin Li - 3:53 PM - 6/20/20

import SwiftUI

private class UpdateUIViewControllerBugFixClass { }

protocol ElegantPagerProvider: ObservableObject {

    var currentPage: Int { get }
    var pageCount: Int { get }
    func view(for page: Int) -> AnyView
    func onRearrange()

}

struct ElegantPagerView<Provider>: UIViewControllerRepresentable where Provider: ElegantPagerProvider {

    typealias UIViewControllerType = ElegantPagerController

    // See https://stackoverflow.com/questions/58635048/in-a-uiviewcontrollerrepresentable-how-can-i-pass-an-observedobjects-value-to
    private let bugFix = UpdateUIViewControllerBugFixClass()

    @ObservedObject var provider: Provider

    func makeUIViewController(context: Context) -> ElegantPagerController<Provider> {
        ElegantPagerController(provider: provider)
    }

    func updateUIViewController(_ uiViewController: ElegantPagerController<Provider>, context: Context) {
        uiViewController.rearrange(provider: provider) {
            self.provider.onRearrange()
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
