// Kevin Li - 7:48 PM - 6/10/20

import SwiftUI

struct CalendarManagerGroup<PreviewGroup: View>: View {

    let previewGroup: PreviewGroup

    var body: some View {
        previewGroup
            .environmentObject(ElegantCalendarManager(configuration: .mock))
    }

    init(@ViewBuilder previewGroup: @escaping () -> PreviewGroup) {
        self.previewGroup = previewGroup()
    }

}
