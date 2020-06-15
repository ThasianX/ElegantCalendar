// Kevin Li - 4:00 PM - 6/13/20

import SwiftUI

struct VisitsListView: View {

    private let timer = Timer.publish(every: VisitPreviewConstants.previewTime,
                                      on: .main, in: .common).autoconnect()
    @State var visitIndex = 0
    
    let visits: [Visit]
    let numberOfCellsInBlock: Int

    init(visits: [Visit], height: CGFloat) {
        self.visits = visits
        numberOfCellsInBlock = Int(height / (VisitPreviewConstants.cellHeight + VisitPreviewConstants.cellPadding*2))
    }

    private var range: Range<Int> {
        let exclusiveEndIndex = visitIndex + numberOfCellsInBlock
        guard visits.count > numberOfCellsInBlock &&
            exclusiveEndIndex <= visits.count else {
            return visitIndex..<visits.count
        }
        return visitIndex..<exclusiveEndIndex
    }

    var body: some View {
        visitsPreviewList
            .animation(.easeInOut)
            .onAppear(perform: setUpVisitsSlideShow)
            .onReceive(timer) { _ in
                self.shiftActivePreviewVisitIndex()
            }
    }

    private func setUpVisitsSlideShow() {
        if visits.count <= numberOfCellsInBlock {
            // To reduce memory usage, we don't want the timer to fire when
            // visits count is less than or equal to the number
            // of visits allowed in a single slide
            timer.upstream.connect().cancel()
        }
    }

    private func shiftActivePreviewVisitIndex() {
        let startingVisitIndexOfNextSlide = visitIndex + numberOfCellsInBlock
        let startingVisitIndexOfNextSlideIsValid = startingVisitIndexOfNextSlide < visits.count
        visitIndex = startingVisitIndexOfNextSlideIsValid ? startingVisitIndexOfNextSlide : 0
    }

    private var visitsPreviewList: some View {
        VStack(spacing: 0) {
            ForEach(visits[range]) { visit in
                VisitCell(visit: visit)
            }
        }
    }

}

struct VisitsListView_Previews: PreviewProvider {
    static var previews: some View {
        DarkThemePreview {
            VisitsListView(visits: Visit.mocks(start: Date(), end: .daysFromToday(2)), height: 300)
        }
    }
}
