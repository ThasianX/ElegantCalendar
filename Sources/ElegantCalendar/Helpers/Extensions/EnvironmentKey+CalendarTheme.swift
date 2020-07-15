// Kevin Li - 6:10 PM - 7/14/20

import SwiftUI

public struct CalendarTheme: Equatable, Hashable {

    public let primary: Color

    public init(primary: Color) {
        self.primary = primary
    }

}

public extension CalendarTheme {

    static let allThemes: [CalendarTheme] = [.brilliantViolet, .craftBrown, .fluorescentPink, .kiwiGreen, .mauvePurple, .orangeYellow, .red, .royalBlue]

    static let brilliantViolet = CalendarTheme(primary: .brilliantViolet)
    static let craftBrown = CalendarTheme(primary: .craftBrown)
    static let fluorescentPink = CalendarTheme(primary: .fluorescentPink)
    static let kiwiGreen = CalendarTheme(primary: .kiwiGreen)
    static let mauvePurple = CalendarTheme(primary: .mauvePurple)
    static let orangeYellow = CalendarTheme(primary: .orangeYellow)
    static let red = CalendarTheme(primary: .red)
    static let royalBlue = CalendarTheme(primary: .royalBlue)

}

extension CalendarTheme {

    static let `default`: CalendarTheme = .royalBlue

}

struct CalendarThemeKey: EnvironmentKey {

    static let defaultValue: CalendarTheme = .default

}

extension EnvironmentValues {

    var calendarTheme: CalendarTheme {
        get { self[CalendarThemeKey.self] }
        set { self[CalendarThemeKey.self] = newValue }
    }

}

private extension Color {

    static let brilliantViolet = Color("brilliantViolet")
    static let craftBrown = Color("craftBrown")
    static let fluorescentPink = Color("fluorescentPink")
    static let kiwiGreen = Color("kiwiGreen")
    static let mauvePurple = Color("mauvePurple")
    static let orangeYellow = Color("orangeYellow")
    static let red = Color("red")
    static let royalBlue = Color("royalBlue")

}
