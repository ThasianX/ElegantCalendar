// Kevin Li - 8:30 PM - 6/24/20

import SwiftUI

struct ContentView: View {

    @State var shifsDate: [Int] = [25, 27]
    @State var initialMonth: Date = Date()
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
//            initialMonth: Date())
        
        ExampleCalendarView(ascVisits: Visit.mocks(
                                start: Date(),
                                end: .daysFromToday(30*24)),
                            initialMonth: initialMonth,
                            shiftsDate: shifsDate, onChangeMonth: { date in
                                DispatchQueue.main.async {
                                    shifsDate = [Int.random(in: 1...30), Int.random(in: 1...30)]
                                    initialMonth = date
                                }
                                
            })
//        ExampleCalendarView(ascVisits: Visit.mocks(
//                                start: Date(),
//                                end: .daysFromToday(30*24)),
//                            initialMonth: Date())

//        ExampleSelectionView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
