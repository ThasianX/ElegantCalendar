// Kevin Li - 12:01 PM - 6/7/20

import SwiftUI

protocol ListPaginationDelegate {

    func willDisplay(page: Int)

}

class CalendarScrollTracker: NSObject, ObservableObject {

    private let delegate: ListPaginationDelegate
    private let tableView: UITableView

    init(delegate: ListPaginationDelegate, tableView: UITableView) {
        self.delegate = delegate
        self.tableView = tableView
        super.init()

        tableView.delegate = self
    }

}

extension CalendarScrollTracker {

    func scroll(to page: Int) {
        tableView.scrollToRow(at: IndexPath(row: page, section: 0), at: .top, animated: true)
        delegate.willDisplay(page: page)
    }

}

extension CalendarScrollTracker: UITableViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.y / CalendarConstants.cellHeight)
        delegate.willDisplay(page: page)
    }

}
