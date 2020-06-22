// Kevin Li - 10:54 AM - 6/22/20

import SwiftUI

struct YearlyCalendarKey: EnvironmentKey {

    static let defaultValue: YearlyCalendarAccessible = YearlyCalendarManager.stub

}

extension EnvironmentValues {

    var yearlyCalendar: YearlyCalendarAccessible {
        get {
            self[YearlyCalendarKey.self]
        }
        set {
            self[YearlyCalendarKey.self] = newValue
        }
    }

}

private extension YearlyCalendarManager {

    static let stub = YearlyCalendarManager(configuration: .stub)

}
