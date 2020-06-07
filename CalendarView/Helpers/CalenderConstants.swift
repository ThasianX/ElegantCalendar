// Kevin Li - 11:00 AM - 6/7/20

import SwiftUI

struct CalendarConstants {

    static let horizontalPadding: CGFloat = 24
    static let daysInRow: CGFloat = 7

    static let gridSpacing: CGFloat = 16

    static private let totalHorizontalPadding: CGFloat = 2 * horizontalPadding
    static private let innerGridSpacing: CGFloat = (daysInRow - 1) * gridSpacing
    static let dayWidth = (screen.width - totalHorizontalPadding - innerGridSpacing) / daysInRow

    static let daysOfWeekInitials = ["S", "M", "T", "W", "T", "F", "S"]

}
