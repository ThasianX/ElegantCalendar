// Kevin Li - 7:44 PM - 7/13/20

import UIKit

fileprivate class BundleId {}

extension UIImage {

    internal convenience init?(named: String) {
        let customBundle = Bundle(for: BundleId.self)
        self.init(named: named, in: customBundle, compatibleWith: nil)
    }

}
