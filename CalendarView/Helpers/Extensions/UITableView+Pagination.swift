// Kevin Li - 7:31 PM - 6/13/20

import SwiftUI

extension UITableView {

    var withPaginationAndNoSeparators: UITableView {
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .none
        allowsSelection = false
        scrollsToTop = false

        // gets rid of scroll insets
        contentInset = .calendarInsets

        isPagingEnabled = true
        decelerationRate = .fast
        rowHeight = CalendarConstants.cellHeight // This is crucial for pagination

        return self
    }

}

private extension UIEdgeInsets {

    static var calendarInsets: UIEdgeInsets {
        UIEdgeInsets(top: -CalendarConstants.scrollInsets,
                     left: 0,
                     bottom: CalendarConstants.scrollInsets,
                     right: 0)
    }

}
