// Kevin Li - 8:30 PM - 6/24/20

import SwiftUI

struct ContentView: View {

    @State var shifsDate: [Int] = [25, 27]
    @State var initialMonth: Date = Date()
    // Uncomment out the view you want to test.
    var body: some View {
        TabView {
            ExampleCalendarView(startDate: Date(),
                                endDate: .daysFromToday(30*24),
                                initialMonth: initialMonth,
                                shiftsDate: shifsDate, onChangeMonth: { date in
                                    DispatchQueue.main.async {
                                        shifsDate = [Int.random(in: 1...30), Int.random(in: 1...30)]
                                        initialMonth = date
                                    }
                                })
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
         
            Text("Bookmark Tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "bookmark.circle.fill")
                    Text("Bookmark")
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
