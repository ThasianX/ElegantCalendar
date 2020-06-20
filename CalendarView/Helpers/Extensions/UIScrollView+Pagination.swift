// Kevin Li - 9:47 PM - 6/14/20

import SwiftUI

extension UIScrollView {

    var withPagination: UIScrollView {
        showsVerticalScrollIndicator = false
        backgroundColor = .none
        scrollsToTop = false

        // gets rid of scroll insets
        contentInset = UIEdgeInsets(top: -CalendarConstants.scrollInsets,
                                    left: 0,
                                    bottom: -CalendarConstants.scrollInsets,
                                    right: 0)

        isPagingEnabled = true
        decelerationRate = .fast

        return self
    }

}
