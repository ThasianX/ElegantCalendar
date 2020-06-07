// Kevin Li - 10:51 PM - 6/6/20

import Foundation

struct CalendarConfiguration {

    let calendar: Calendar
    let startDate: Date
    let endDate: Date

    init(calendar: Calendar = .current, startDate: Date, endDate: Date) {
        self.calendar = calendar
        self.startDate = startDate
        self.endDate = endDate
    }

}

extension CalendarConfiguration {

    static let mock = CalendarConfiguration(
        startDate: Date(),
        endDate: Date().addingTimeInterval(60*60*24*365))

}

protocol CalendarConfigurationDirectAccess {

    var configuration: CalendarConfiguration { get }

}

extension CalendarConfigurationDirectAccess {

    var calendar: Calendar {
        configuration.calendar
    }

    var startDate: Date {
        configuration.startDate
    }

    var endDate: Date {
        configuration.endDate
    }

    func generateDates(inside interval: DateInterval,
                       matching components: DateComponents) -> [Date] {
        calendar.generateDates(inside: interval, matching: components)
    }

}

private extension Calendar {

    func generateDates(inside interval: DateInterval,
                       matching components: DateComponents) -> [Date] {
       var dates: [Date] = []
       dates.append(interval.start)

       enumerateDates(
           startingAfter: interval.start,
           matching: components,
           matchingPolicy: .nextTime) { date, _, stop in
           if let date = date {
               if date < interval.end {
                   dates.append(date)
               } else {
                   stop = true
               }
           }
       }

       return dates
    }

}
