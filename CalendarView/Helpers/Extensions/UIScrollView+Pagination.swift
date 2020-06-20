// Kevin Li - 9:47 PM - 6/14/20

import SwiftUI

extension UIScrollView {

    var withPagination: UIScrollView {
        showsVerticalScrollIndicator = false
        backgroundColor = .none
        scrollsToTop = false

        // gets rid of scroll insets. iphone 11 only. TODO: Need to test other phones. I should actually grab the scroll insets before I start attaching the scrollview
        contentInset = UIEdgeInsets(top: -44,
                                    left: 0,
                                    bottom: -34,
                                    right: 0)

        isPagingEnabled = true
        decelerationRate = .fast

        return self
    }

}
