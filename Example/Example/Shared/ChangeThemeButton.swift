// Kevin Li - 7:42 PM - 7/14/20

import ElegantCalendar
import SwiftUI

struct ChangeThemeButton: View {

    @Binding var calendarTheme: CalendarTheme

    var body: some View {
        Button(action: {
            self.calendarTheme = .randomTheme
        }) {
            Text("CHANGE THEME")
        }
    }

}

private extension CalendarTheme {

    static var randomTheme: CalendarTheme {
        let randomNumber = arc4random_uniform(UInt32(CalendarTheme.allThemes.count))
        return CalendarTheme.allThemes[Int(randomNumber)]
    }

}
