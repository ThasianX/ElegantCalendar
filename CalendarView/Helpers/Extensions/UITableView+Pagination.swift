// Kevin Li - 7:31 PM - 6/13/20

import SwiftUI

extension UITableView {

    var withPagination: UITableView {
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .none
        allowsSelection = false
        scrollsToTop = false

        // gets rid of scroll insets
        contentInset = UIEdgeInsets(top: -CalendarConstants.scrollInsets,
                                    left: 0,
                                    bottom: -CalendarConstants.scrollInsets,
                                    right: 0)

        isPagingEnabled = true
        decelerationRate = .fast
        rowHeight = CalendarConstants.cellHeight // This is crucial for pagination

        return self
    }

}
