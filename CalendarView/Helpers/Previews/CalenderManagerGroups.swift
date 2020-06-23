// Kevin Li - 7:48 PM - 6/10/20

import SwiftUI

struct MonthlyCalendarManagerGroup<PreviewGroup: View>: View {

    let previewGroup: PreviewGroup

    var body: some View {
        previewGroup
            .environmentObject(MonthlyCalendarManager(configuration: .mock))
    }

    init(@ViewBuilder previewGroup: @escaping () -> PreviewGroup) {
        self.previewGroup = previewGroup()
    }

}

struct YearlyCalendarManagerGroup<PreviewGroup: View>: View {

    let previewGroup: PreviewGroup

    var body: some View {
        previewGroup
            .environment(\.yearlyCalendar, YearlyCalendarManager(configuration: .mock))
    }

    init(@ViewBuilder previewGroup: @escaping () -> PreviewGroup) {
        self.previewGroup = previewGroup()
    }

}
