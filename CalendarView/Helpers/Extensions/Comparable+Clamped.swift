// Kevin Li - 3:08 PM - 6/20/20

import Foundation

extension Comparable {

    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }

}
