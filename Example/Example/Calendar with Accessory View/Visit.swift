// Kevin Li - 1:32 PM - 6/13/20

import SwiftUI

let currentCalendar = Calendar.current
let screen = UIScreen.main.bounds

struct Visit {

    let locationName: String
    let tagColor: Color
    let arrivalDate: Date
    let departureDate: Date

    var duration: String {
        arrivalDate.timeOnlyWithPadding + " ➝ " + departureDate.timeOnlyWithPadding
    }

}

extension Visit: Identifiable {

    var id: Int {
        UUID().hashValue
    }

}

extension Visit {

    static func mock(withDate date: Date) -> Visit {
        Visit(locationName: "Apple Inc",
              tagColor: .randomColor,
              arrivalDate: date,
              departureDate: date.addingTimeInterval(60*60))
    }

    static func mocks(start: Date, end: Date) -> [Visit] {
        currentCalendar.generateVisits(
            start: start,
            end: end)
    }

}

fileprivate let visitCountRange = 1...20

private extension Calendar {

    func generateVisits(start: Date, end: Date) -> [Visit] {
        var visits = [Visit]()

        enumerateDates(
            startingAfter: start,
            matching: .everyDay,
            matchingPolicy: .nextTime) { date, _, stop in
            if let date = date {
                if date < end {
                    for _ in 0..<Int.random(in: visitCountRange) {
                        visits.append(.mock(withDate: date))
                    }
                } else {
                    stop = true
                }
            }
        }

        return visits
    }

}

fileprivate let colorAssortment: [Color] = [.turquoise, .forestGreen, .darkPink, .darkRed, .lightBlue, .salmon, .military]

private extension Color {

    static var randomColor: Color {
        let randomNumber = arc4random_uniform(UInt32(colorAssortment.count))
        return colorAssortment[Int(randomNumber)]
    }

}

private extension Color {

    static let turquoise = Color(red: 24, green: 147, blue: 120)
    static let forestGreen = Color(red: 22, green: 128, blue: 83)
    static let darkPink = Color(red: 179, green: 102, blue: 159)
    static let darkRed = Color(red: 185, green: 22, blue: 77)
    static let lightBlue = Color(red: 72, green: 147, blue: 175)
    static let salmon = Color(red: 219, green: 135, blue: 41)
    static let military = Color(red: 117, green: 142, blue: 41)

}

fileprivate extension Color {

    init(red: Int, green: Int, blue: Int) {
        self.init(red: Double(red)/255, green: Double(green)/255, blue: Double(blue)/255)
    }

}

fileprivate extension DateComponents {

    static var everyDay: DateComponents {
        DateComponents(hour: 0, minute: 0, second: 0)
    }

}
