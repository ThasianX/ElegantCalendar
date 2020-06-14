// Kevin Li - 7:28 PM - 6/10/20

import SwiftUI

extension Calendar {

    func isDate(_ date1: Date, equalTo date2: Date, toGranularities components: Set<Calendar.Component>) -> Bool {
        components.reduce(into: true) { isEqual, component in
            isEqual = isEqual && isDate(date1, equalTo: date2, toGranularity: component)
        }
    }

    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.month, .year], from: date)
        return self.date(from: components)!
    }

    func startOfYear(for date: Date) -> Date {
        let components = dateComponents([.year], from: date)
        return self.date(from: components)!
    }

}
