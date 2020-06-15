// Kevin Li - 9:48 PM - 6/14/20

import SwiftUI

class YearlyCalendarScrollTracker: NSObject, ObservableObject {

    private let delegate: ListPaginationDelegate
    private let scrollView: UIScrollView

    init(delegate: ListPaginationDelegate, scrollView: UIScrollView) {
        self.delegate = delegate
        self.scrollView = scrollView
        super.init()

        scrollView.delegate = self
    }

}

extension YearlyCalendarScrollTracker {

    func scroll(to page: Int) {
        scrollView.setContentOffset(CGPoint(x: 0, y: CalendarConstants.cellHeight*CGFloat(page)), animated: true)
        delegate.willDisplay(page: page)
    }

}

extension YearlyCalendarScrollTracker: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.y / CalendarConstants.cellHeight)
        delegate.willDisplay(page: page)
    }

}
