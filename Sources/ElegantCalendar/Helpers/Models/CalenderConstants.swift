// Kevin Li - 11:00 AM - 6/7/20

import SwiftUI

let screen = UIScreen.main.bounds

struct CalendarConstants {

    static let cellHeight: CGFloat = screen.height

    static let daysInRow: CGFloat = 7

    struct Monthly {

        static var cellWidth: CGFloat!
        static let horizontalPadding: CGFloat = cellWidth * 0.045

        static let outerHorizontalPadding: CGFloat = horizontalPadding + dayWidth/4

        static let topPadding: CGFloat = cellHeight * 0.078
        static let gridSpacing: CGFloat = cellWidth * 0.038

        static let dayWidth: CGFloat = {
            let totalHorizontalPadding: CGFloat = 2 * horizontalPadding
            let innerGridSpacing: CGFloat = (daysInRow - 1) * gridSpacing
            return (cellWidth - totalHorizontalPadding - innerGridSpacing) / daysInRow
        }()

    }

    struct Yearly {

        static let cellWidth: CGFloat = screen.width
        static let horizontalPadding: CGFloat = cellWidth * 0.058

        static let outerHorizontalPadding: CGFloat = horizontalPadding + monthWidth/7

        static let topPadding: CGFloat = cellHeight * 0.12

        static let monthsInRow = 3
        static let monthsInColumn = 4
        static let monthsGridSpacing: CGFloat = 4
        static let monthWidth: CGFloat = {
            let totalHorizontalPadding: CGFloat = 2 * horizontalPadding
            let innerGridSpacing: CGFloat = CGFloat(monthsInRow - 1) * monthsGridSpacing
            return (cellWidth - totalHorizontalPadding - innerGridSpacing) / CGFloat(monthsInRow)
        }()

        static let daysGridVerticalSpacing: CGFloat = 4
        static let daysGridHorizontalSpacing: CGFloat = 2
        static let dayWidth: CGFloat = {
            let innerGridSpacing: CGFloat = (daysInRow - 1) * daysGridHorizontalSpacing
            return (monthWidth - innerGridSpacing) / daysInRow
        }()
        static let daysStackHeight: CGFloat = 6*dayWidth + 5*daysGridVerticalSpacing
    }

}
