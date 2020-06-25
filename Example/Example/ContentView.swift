// Kevin Li - 8:30 PM - 6/24/20

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            ExampleYearlyCalendarView(
                ascVisits: Visit.mocks(start: .daysFromToday(-30*36),
                                       end: .daysFromToday(30*36)))
                .tabItem({
                    Text("Yearly Calendar")
                }).tag(0)

            ExampleMonthlyCalendarView(
                ascVisits: Visit.mocks(start: .daysFromToday(-30*36),
                                       end: .daysFromToday(30*36)))
                .tabItem({
                    Text("Monthly Calendar")
                }).tag(1)

            ExampleCalendarView(
                ascVisits: Visit.mocks(start: .daysFromToday(-30*36),
                                       end: .daysFromToday(30*36)))
                .tabItem({
                    Text("Full Calendar")
                }).tag(2)

            ExampleSelectionView()
                .tabItem({
                    Text("Calendar Selection")
                }).tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
