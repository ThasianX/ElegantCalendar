// Kevin Li - 9:47 PM - 6/14/20

import SwiftUI

extension UIScrollView {

    var withPagination: UIScrollView {
        backgroundColor = .none
        scrollsToTop = false

        contentInset = UIEdgeInsets(top: -adjustedContentInset.top,
                                    left: 0,
                                    bottom: -adjustedContentInset.bottom,
                                    right: 0)

        isPagingEnabled = true
        decelerationRate = .fast

        return self
    }

}
