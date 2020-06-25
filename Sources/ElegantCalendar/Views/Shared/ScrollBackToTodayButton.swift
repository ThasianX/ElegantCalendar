// Kevin Li - 7:14 PM - 6/14/20

import SwiftUI

struct ScrollBackToTodayButton: View {

    let scrollBackToToday: () -> Void
    let color: Color

    var body: some View {
        Button(action: scrollBackToToday) {
            Image(systemName: "arrow.uturn.left")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(color)
                .padding(10)
        }
        .animation(.easeInOut)
    }

}

struct ScrollBackToTodayButton_Previews: PreviewProvider {
    static var previews: some View {
        LightDarkThemePreview {
            ScrollBackToTodayButton(scrollBackToToday: {}, color: .blackPearl)
        }
    }
}
