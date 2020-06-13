// Kevin Li - 5:25 PM - 6/10/20

import SwiftUI

protocol ElegantCalendarDataSource {

    func elegantCalendar(_ calendarManager: CalendarManager,colorOpacityForDay day: Date) -> Double
    func elegantCalendar(_ calendarManager: CalendarManager,viewForSelectedDay day: Date) -> AnyView

}

extension ElegantCalendarDataSource {

    func elegantCalendar(_ calendarManager: CalendarManager,colorOpacityForDay day: Date) -> Double {
        1
    }

    func elegantCalendar(_ calendarManager: CalendarManager,viewForSelectedDay day: Date) -> AnyView {
        AnyView(EmptyView())
    }

}

protocol ElegantCalendarDelegate {

    func elegantCalendar(_ calendarManager: CalendarManager, didSelectDate date: Date)
    func elegantCalendar(_ calendarManager: CalendarManager, willDisplay month: Date)

}

extension ElegantCalendarDelegate {

    func elegantCalendar(_ calendarManager: CalendarManager, didSelectDate date: Date) { }

    func elegantCalendar(_ calendarManager: CalendarManager, willDisplay month: Date) { }

}

class CalendarManager: ObservableObject {

    @Published var currentMonth: Date
    @Published var selectedDate: Date?

    var datasource: ElegantCalendarDataSource?
    var delegate: ElegantCalendarDelegate?

    private var scrollTracker: CalendarScrollTracker!

    let configuration: CalendarConfiguration
    let months: [Date]
    private let todayMonthIndex: Int?

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration

        months = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryMonth)

        let currentDate = Date()
        todayMonthIndex = months.firstIndex(where: { month in
            configuration.calendar.isDate(month, equalTo:currentDate, toGranularities: [.month, .year])
        })

        currentMonth = months.first!
    }

}

extension CalendarManager: ListPaginationDelegate {

    func willDisplay(page: Int) {
        if currentMonth != months[page] {
            currentMonth = months[page]
            selectedDate = nil
            delegate?.elegantCalendar(self, willDisplay: currentMonth)
        }
    }

}

extension CalendarManager {

    func attach(to tableView: UITableView) {
        scrollTracker = CalendarScrollTracker(delegate: self, tableView: tableView)
    }

    func scrollBackToToday() {
        if let todayMonthIndex = todayMonthIndex {
            scrollTracker.scroll(to: todayMonthIndex)
            dayTapped(day: months[todayMonthIndex])
        }
    }

}

extension CalendarManager {

    func dayTapped(day: Date) {
        selectedDate = day
        delegate?.elegantCalendar(self, didSelectDate: day)
    }

}

private extension DateComponents {

    static var firstDayOfEveryMonth: DateComponents {
        DateComponents(day: 1, hour: 0, minute: 0, second: 0)
    }

}

protocol CalendarManagerDirectAccess {

    var calendarManager: CalendarManager { get }

}

extension CalendarManagerDirectAccess {

    var configuration: CalendarConfiguration {
        calendarManager.configuration
    }

    var calendar: Calendar {
        configuration.calendar
    }

    var startDate: Date {
        configuration.startDate
    }

    var endDate: Date {
        configuration.endDate
    }

    var themeColor: Color {
        configuration.themeColor
    }

    func generateDates(inside interval: DateInterval,
                       matching components: DateComponents) -> [Date] {
        calendar.generateDates(inside: interval, matching: components)
    }

    var currentMonth: Date {
        calendarManager.currentMonth
    }

    var selectedDate: Date? {
        calendarManager.selectedDate
    }

    var datasource: ElegantCalendarDataSource? {
        calendarManager.datasource
    }

    var delegate: ElegantCalendarDelegate? {
        calendarManager.delegate
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
