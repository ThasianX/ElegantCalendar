// Kevin Li - 12:01 PM - 6/7/20

import SwiftUI

protocol ListPaginationDelegate {

    func willDisplay(page: Int)

}

class CalendarScrollTracker: NSObject, ObservableObject {

    private let delegate: ListPaginationDelegate
    private let scrollView: UIScrollView

//    private var lastContentOffset: CGFloat = 0
//    private var isScrolling = false

    init(delegate: ListPaginationDelegate, scrollView: UIScrollView) {
        self.delegate = delegate
        self.scrollView = scrollView
        super.init()

        scrollView.delegate = self
    }

}

extension CalendarScrollTracker {

//    func scroll(to page: Int) {
//        tableView.scrollToRow(at: IndexPath(row: page, section: 0), at: .top, animated: true)
//        delegate.willDisplay(page: page)
//    }

    func resetToCenter() {
        scrollView.setContentOffset(CGPoint(x: 0, y: CalendarConstants.cellHeight), animated: false)
    }

}

extension CalendarScrollTracker: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.y / CalendarConstants.cellHeight)
        delegate.willDisplay(page: page)
    }

}

//fileprivate let scrollCutOff: CGFloat = 30
//
//extension CalendarScrollTracker: UITableViewDelegate {
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        lastContentOffset = scrollView.contentOffset.y
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard !isScrolling else { return }
//        let offset = scrollView.contentOffset.y
//        let cellHeight = CalendarConstants.cellHeight
//
//        if lastContentOffset < offset && (offset - lastContentOffset) > scrollCutOff {
//            let nextPage = Int(offset / cellHeight + 1)
//            scrollToPage(nextPage, scrollView: scrollView)
//        }
//
////        else if lastContentOffset > offset && (lastContentOffset - offset) > scrollCutOff {
////            let previousPage = Int(offset / cellHeight)
////            scrollToPage(previousPage, scrollView: scrollView)
////        }
//
////        let offset = scrollView.contentOffset.y
////        let cellHeight = CalendarConstants.cellHeight
////
////        let correctedOffset = Int(offset) % Int(cellHeight)
////        if correctedOffset >= scrollDownCutOff && correctedOffset <= scrollDownCutOff + 10 {
////            let nextPage = Int(offset / cellHeight + 1)
////            scrollToPage(nextPage, scrollView: scrollView)
////        } else if correctedOffset >= scrollUpCutOff - 10 && correctedOffset <= scrollUpCutOff {
////            let previousPage = Int(offset / cellHeight)
////            scrollToPage(previousPage, scrollView: scrollView)
////        }
//    }
//
//    private func scrollToPage(_ page: Int, scrollView: UIScrollView) {
//        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            self.isScrolling = true
////            scrollView.isScrollEnabled = false
////            self.tableView.scrollToRow(at: IndexPath(row: page, section: 0), at: .top, animated: false)
//            scrollView.contentOffset = CGPoint(x: 0, y: CalendarConstants.cellHeight * CGFloat(page))
//        }) { (finished) -> Void in
//            self.isScrolling = false
////            scrollView.isScrollEnabled = true
//        }
//    }
//
////    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
////        if !decelerate {
////            scrollViewDidEndDecelerating(scrollView)
////        }
////    }
////
////    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
////        scrollViewDidEndDecelerating(scrollView)
////    }
////
////    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        let rowHeight = CalendarConstants.cellHeight
////        let page = tableView.indexPathForRow(at: CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + tableView.rowHeight/2))!
////        tableView.scrollToRow(at: page, at: .top, animated: true)
//////        let page = Int(scrollView.contentOffset.y / CalendarConstants.cellHeight)
////        delegate.willDisplay(page: page.row)
////    }
//
//}

//extension UIScrollView {
//
//    var isAtTop: Bool {
//        return contentOffset.y <= verticalOffsetForTop
//    }
//
//    var isAtBottom: Bool {
//        return contentOffset.y >= verticalOffsetForBottom
//    }
//
//    var verticalOffsetForTop: CGFloat {
//        let topInset = contentInset.top
//        return -topInset
//    }
//
//    var verticalOffsetForBottom: CGFloat {
//        let scrollViewHeight = bounds.height
//        let scrollContentSizeHeight = contentSize.height
//        let bottomInset = contentInset.bottom
//        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
//        return scrollViewBottomOffset
//    }
//
//}
