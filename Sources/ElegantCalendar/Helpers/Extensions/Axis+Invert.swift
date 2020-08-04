// Kevin Li - 12:07 PM - 8/4/20

import SwiftUI

extension Axis {

    var inverted: Axis {
        (self == .vertical) ? .horizontal : .vertical
    }

}
