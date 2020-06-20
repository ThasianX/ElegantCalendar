// Kevin Li - 7:31 PM - 6/13/20

import SwiftUI

extension UITableView {

    var withPaginationAndNoSeparators: UITableView {
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .none
        allowsSelection = false
        scrollsToTop = false

        // TODO: Remove this later and probably replace the yearly calendar view with a scrollview implementation
        contentInset = UIEdgeInsets(top: -adjustedContentInset.top,
                                    left: 0,
                                    bottom: -adjustedContentInset.bottom,
                                    right: 0)

        isPagingEnabled = true
        decelerationRate = .fast
        rowHeight = CalendarConstants.cellHeight // This is crucial for pagination

        return self
    }

}
