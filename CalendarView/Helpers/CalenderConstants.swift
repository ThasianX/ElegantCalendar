// Kevin Li - 11:00 AM - 6/7/20

import SwiftUI

struct CalendarConstants {

    static let horizontalPadding: CGFloat = 24
    static let gridSpacing: CGFloat = 16

    static let daysInRow: CGFloat = 7
    static let cellHeight: CGFloat = screen.height
    static let cellWidth: CGFloat = screen.width

    static let dayWidth: CGFloat = {
        let totalHorizontalPadding: CGFloat = 2 * horizontalPadding
        let innerGridSpacing: CGFloat = (daysInRow - 1) * gridSpacing
        return (cellWidth - totalHorizontalPadding - innerGridSpacing) / daysInRow
    }()

}
