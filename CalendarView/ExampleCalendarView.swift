// Kevin Li - 11:47 AM - 6/13/20

import SwiftUI

struct ExampleCalendarView: View {

    @ObservedObject private var calendarManager = ElegantCalendarManager(configuration: .mock)

    var body: some View {
        ElegantCalendarView(calendarManager: calendarManager,
                     initialMonth: Date().addingTimeInterval(60*60*24*90))
    }
    
}

struct ExampleCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleCalendarView()
    }
}
