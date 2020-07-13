// Kevin Li - 2:42 PM - 7/12/20

import SwiftUI

class PagerState: ObservableObject {

    @Published var activeIndex: Int = 1
    @Published var translation: CGFloat = .zero

    let pagerWidth: CGFloat

    init(pagerWidth: CGFloat) {
        self.pagerWidth = pagerWidth
    }

}

protocol PagerStateDirectAccess {

    var pagerState: PagerState { get }

}

extension PagerStateDirectAccess {

    var pagerWidth: CGFloat {
        pagerState.pagerWidth
    }

    var activeIndex: Int {
        pagerState.activeIndex
    }

    var translation: CGFloat {
        pagerState.translation
    }

}
