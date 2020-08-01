// Kevin Li - 8:30 PM - 6/24/20

import SwiftUI

struct ContentView: View {

    // Uncomment out the view you want to test.
    var body: some View {
//        ExampleYearlyCalendarView(
//            ascVisits: Visit.mocks(
//                start: .daysFromToday(-30*36),
//                end: .daysFromToday(30*36)),
//            initialYear: .daysFromToday(365))

//        ExampleMonthlyCalendarView(
//            ascVisits: Visit.mocks(
//                start: .daysFromToday(-30*36),
//                end: .daysFromToday(30*36)),
//            initialMonth: .daysFromToday(30))

        ExampleCalendarView(
            ascVisits: Visit.mocks(
                start: .daysFromToday(-30*36),
                end: .daysFromToday(30*36)),
            initialMonth: Date())

//        ExampleSelectionView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
