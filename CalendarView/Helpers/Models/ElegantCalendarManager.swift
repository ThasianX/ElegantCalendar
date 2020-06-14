// Kevin Li - 5:25 PM - 6/10/20

import SwiftUI

protocol ElegantCalendarDataSource {

    func elegantCalendar(_ calendarManager: ElegantCalendarManager, colorOpacityForDay day: Date) -> Double
    func elegantCalendar(_ calendarManager: ElegantCalendarManager, viewForSelectedDay day: Date, dimensions size: CGSize) -> AnyView

}

extension ElegantCalendarDataSource {

    func elegantCalendar(_ calendarManager: ElegantCalendarManager, colorOpacityForDay day: Date) -> Double {
        1
    }

    func elegantCalendar(_ calendarManager: ElegantCalendarManager, viewForSelectedDay day: Date, dimensions size: CGSize) -> AnyView {
        EmptyView().erased
    }

}

protocol ElegantCalendarDelegate {

    func elegantCalendar(_ calendarManager: ElegantCalendarManager, didSelectDate date: Date)
    func elegantCalendar(_ calendarManager: ElegantCalendarManager, willDisplay month: Date)

}

extension ElegantCalendarDelegate {

    func elegantCalendar(_ calendarManager: ElegantCalendarManager, didSelectDate date: Date) { }

    func elegantCalendar(_ calendarManager: ElegantCalendarManager, willDisplay month: Date) { }

}

public class ElegantCalendarManager: ObservableObject {

    @Published var currentMonth: Date
    @Published var selectedDate: Date?

    var datasource: ElegantCalendarDataSource?
    var delegate: ElegantCalendarDelegate?

    private var scrollTracker: CalendarScrollTracker!

    let configuration: CalendarConfiguration
    let months: [Date]

    init(configuration: CalendarConfiguration) {
        self.configuration = configuration

        months = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.endDate),
            matching: .firstDayOfEveryMonth)

        currentMonth = months.first!
    }

}

extension ElegantCalendarManager: ListPaginationDelegate {

    func willDisplay(page: Int) {
        if currentMonth != months[page] {
            currentMonth = months[page]
            selectedDate = nil
            delegate?.elegantCalendar(self, willDisplay: currentMonth)
        }
    }

}

extension ElegantCalendarManager {

    func attach(to tableView: UITableView, with initialMonth: Date?) {
        if scrollTracker == nil {
            scrollTracker = CalendarScrollTracker(delegate: self, tableView: tableView)
            if let initialMonth = initialMonth {
                scrollToMonth(initialMonth)
            }
        }
    }

    func scrollBackToToday() {
        scrollToMonth(Date())
        dayTapped(day: Date())
    }

}

extension ElegantCalendarManager {

    func dayTapped(day: Date) {
        selectedDate = day
        delegate?.elegantCalendar(self, didSelectDate: day)
    }

}

extension ElegantCalendarManager {

    public func scrollToMonth(_ month: Date) {
        let startOfMonthForStartDate = calendar.startOfMonth(for: configuration.startDate)
        let startOfMonthForToBeCurrentMonth = calendar.startOfMonth(for: month)
        let monthsInBetween = configuration.calendar.dateComponents([.month],
                                                                    from: startOfMonthForStartDate,
                                                                    to: startOfMonthForToBeCurrentMonth).month!
        scrollTracker.scroll(to: monthsInBetween)
    }

}

protocol CalendarManagerDirectAccess {

    var calendarManager: ElegantCalendarManager { get }

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
