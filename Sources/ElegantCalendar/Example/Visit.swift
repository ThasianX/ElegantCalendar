// Kevin Li - 1:32 PM - 6/13/20

import SwiftUI

let currentCalendar = Calendar.current

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
        locationName.hashValue
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

fileprivate let colorAssortment: [Color] = [.red, .green, .blue, .gray, .orange, .yellow]

private extension Color {

    static var randomColor: Color {
        let randomNumber = arc4random_uniform(UInt32(colorAssortment.count))
        return colorAssortment[Int(randomNumber)]
    }

}
