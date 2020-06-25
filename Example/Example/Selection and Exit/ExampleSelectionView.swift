// Kevin Li - 8:33 PM - 6/24/20

import Combine
import ElegantPages
import SwiftUI

class SelectionModel: ObservableObject {

    @Published var calendarManager: ElegantCalendarManager = .init(configuration: .mock)
    let pagesManager = ElegantPagesManager(startingPage: 1, pageTurnType: .earlyCutOffDefault)

    var anyCancellable: AnyCancellable? = nil

    init() {
        calendarManager.delegate = self

        anyCancellable = calendarManager.objectWillChange.sink {
            self.objectWillChange.send()
        }
    }

}

extension SelectionModel: ElegantCalendarDelegate {

    func calendar(didSelectDate date: Date) {
        pagesManager.scroll(to: 1)
    }

}

struct ExampleSelectionView: View {

    @ObservedObject var model: SelectionModel = .init()

    var calendarManager: ElegantCalendarManager {
        model.calendarManager
    }

    var pagesManager: ElegantPagesManager {
        model.pagesManager
    }

    var body: some View {
        // TODO: custom view
        ElegantHPages(manager: pagesManager) {
            calendarView
            homeView
        }
    }

    private var calendarView: some View {
        ElegantCalendarView(calendarManager: calendarManager)
    }

    private var homeView: some View {
        VStack(spacing: 25) {
            Button(action: {
                self.pagesManager.scroll(to: 0)
            }) {
                Text("Show Calendar").foregroundColor(.blackPearl)
            }

            Text(calendarManager.selectedDate?.fullDate ?? "No date selected")
        }
    }

}

struct ExampleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleSelectionView()
    }
}
