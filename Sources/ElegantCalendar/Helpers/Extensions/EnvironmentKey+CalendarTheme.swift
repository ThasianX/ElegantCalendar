// Kevin Li - 6:10 PM - 7/14/20

import SwiftUI

public struct CalendarTheme: Equatable, Hashable {

    let primary: Color

}

public extension CalendarTheme {

    static let allThemes: [CalendarTheme] = [.brilliantViolet, .kiwiGreen, .mauvePurple, .royalBlue]

    static let brilliantViolet = CalendarTheme(primary: .brilliantViolet)
    static let kiwiGreen = CalendarTheme(primary: .kiwiGreen)
    static let mauvePurple = CalendarTheme(primary: .mauvePurple)
    static let royalBlue = CalendarTheme(primary: .royalBlue)

}

struct CalendarThemeKey: EnvironmentKey {

    static let defaultValue: CalendarTheme = .brilliantViolet

}

extension EnvironmentValues {

    var calendarTheme: CalendarTheme {
        get { self[CalendarThemeKey.self] }
        set { self[CalendarThemeKey.self] = newValue }
    }

}

private extension Color {

    static let brilliantViolet = Color("brilliantViolet")
    static let kiwiGreen = Color("kiwiGreen")
    static let mauvePurple = Color("mauvePurple")
    static let royalBlue = Color("royalBlue")

}
