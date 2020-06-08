// Kevin Li - 12:01 PM - 6/7/20

import SwiftUI

class CalendarScrollTracker: NSObject, ObservableObject {

    var calendarManager: CalendarManager!
    var tableView: UITableView!

    func initialiaze(with tableView: UITableView, calendarManager: CalendarManager) {
        self.tableView = tableView
        tableView.delegate = self

        self.calendarManager = calendarManager
    }

}

extension CalendarScrollTracker {

    func scrollBackToToday() {
        guard let todayMonthIndex = calendarManager.todayMonthIndex else { return }

        tableView.scrollToRow(at: IndexPath(row: todayMonthIndex, section: 0), at: .top, animated: true)

        calendarManager.monthDidChange(newIndex: todayMonthIndex)
    }

}

extension CalendarScrollTracker: UITableViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.y / CalendarConstants.cellHeight)
        calendarManager.monthDidChange(newIndex: index)
    }

}
