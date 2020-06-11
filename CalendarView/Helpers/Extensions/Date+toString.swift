// Kevin Li - 7:09 PM - 6/6/20

import Foundation

extension Date {

    var fullMonth: String {
        DateFormatter.fullMonth.string(from: self)
    }

    var year: String {
        DateFormatter.year.string(from: self)
    }

}

extension DateFormatter {

    static var fullMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }

}
