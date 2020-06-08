// Kevin Li - 12:01 PM - 6/7/20

import SwiftUI

class CalendarScrollTracker: NSObject, ObservableObject {

    var tableView: UITableView!

    func initialiaze(with tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = self
    }

}

extension CalendarScrollTracker: UITableViewDelegate {

    // TODO: Add method to scroll back to current month here and just any month in general

}
