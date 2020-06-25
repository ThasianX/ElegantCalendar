// Kevin Li - 7:09 PM - 6/6/20

import Foundation

extension Date {

    var abbreviatedMonth: String {
        DateFormatter.abbreviatedMonth.string(from: self)
    }

    var dayOfWeekWithMonthAndDay: String {
        DateFormatter.dayOfWeekWithMonthAndDay.string(from: self)
    }

    var fullMonth: String {
        DateFormatter.fullMonth.string(from: self)
    }

    var timeOnlyWithPadding: String {
        DateFormatter.timeOnlyWithPadding.string(from: self)
    }

    var year: String {
        DateFormatter.year.string(from: self)
    }

}

extension DateFormatter {

    static var abbreviatedMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }

    static var dayOfWeekWithMonthAndDay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM d"
        return formatter
    }

    static var fullMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static let timeOnlyWithPadding: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    static var year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }

}
