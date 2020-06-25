// Kevin Li - 8:55 PM - 6/24/20

import SwiftUI

extension Date {

    var fullDate: String {
        DateFormatter.fullDate.string(from: self)
    }

}

extension DateFormatter {

    static var fullDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }

}
