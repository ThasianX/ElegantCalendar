// Kevin Li - 8:58 PM - 7/9/20

import UIKit

extension UIImpactFeedbackGenerator {

    private static var selectionHaptic = UISelectionFeedbackGenerator()
    static func generateSelectionHaptic() {
        selectionHaptic.selectionChanged()
    }

}
