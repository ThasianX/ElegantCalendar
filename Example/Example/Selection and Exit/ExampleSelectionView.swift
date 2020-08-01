// Kevin Li - 8:33 PM - 6/24/20

import ElegantPages
import ElegantCalendar
import SwiftUI

fileprivate let turnAnimation: Animation = .spring(response: 0.4, dampingFraction: 0.95)

class SelectionModel: ObservableObject {

    @Published var showCalendar = false
    @Published var calendarManager: ElegantCalendarManager = .init(configuration: .init(startDate: .daysFromToday(-365),
                                                                                        endDate: .daysFromToday(365*3)))

    init() {
        calendarManager.delegate = self
    }

}

extension SelectionModel: ElegantCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(turnAnimation) {
                self.showCalendar = false
            }
        }
    }

}

struct ExampleSelectionView: View {

    @ObservedObject var model: SelectionModel = .init()

    var calendarManager: ElegantCalendarManager {
        model.calendarManager
    }

    private var offset: CGFloat {
        model.showCalendar ? -screen.width : -screen.width*2
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            calendarView
                .frame(width: screen.width*2, height: screen.height, alignment: .trailing)
            homeView
                .frame(width: screen.width, height: screen.height)
        }
        .frame(width: screen.width, height: screen.height, alignment: .leading)
        .offset(x: offset)
    }

    private var calendarView: some View {
        ElegantCalendarView(calendarManager: calendarManager)
    }

    private var homeView: some View {
        VStack(spacing: 25) {
            Button(action: {
                withAnimation(turnAnimation) {
                    self.model.showCalendar = true
                }
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
