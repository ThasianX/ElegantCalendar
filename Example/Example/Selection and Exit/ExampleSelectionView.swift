// Kevin Li - 8:33 PM - 6/24/20

import SwiftUI

class SelectionModel: ObservableObject {

    @Published var showCalendar = false

    let calendarManager: ElegantCalendarManager = .init(configuration: .mock)

    init() {
        calendarManager.delegate = self
    }

}

extension SelectionModel: ElegantCalendarDelegate {

    func calendar(didSelectDate date: Date) {
        withAnimation(.spring()) {
            showCalendar = false
        }
    }

}

struct ExampleSelectionView: View {

    @ObservedObject var model: SelectionModel = .init()

    var calendarManager: ElegantCalendarManager {
        model.calendarManager
    }

    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                Button(action: {
                    withAnimation(.spring()) {
                        self.model.showCalendar = true
                    }
                }) {
                    Text("Show Calendar").foregroundColor(.blackPearl)
                }

                Text(calendarManager.selectedDate?.fullDate ?? "No date selected")
            }

            calendarView
                .modal(isPresented: model.showCalendar)
        }
    }

    private var calendarView: some View {
        ElegantCalendarView(calendarManager: calendarManager)
    }

    private func scrollToSelectedDateIfExists() {
        if let selectedDate = calendarManager.selectedDate {
            calendarManager.scrollToMonth(selectedDate)
        }
    }

}

extension View {

    func modal(isPresented: Bool) -> some View {
        self
            .offset(y: isPresented ? 0 : screen.height)
            .opacity(isPresented ? 1 : 0)
    }

}

struct ExampleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleSelectionView()
    }
}
