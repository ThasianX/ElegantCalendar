// Kevin Li - 7:14 PM - 6/14/20

import SwiftUI

struct ScrollBackToTodayButton: View {

    let scrollBackToToday: () -> Void
    let color: Color

    var body: some View {
        Button(action: scrollBackToToday) {
            Image.uTurnLeft
                .resizable()
                .frame(width: 30, height: 25)
                .foregroundColor(color)
        }
        .animation(.easeInOut)
    }

}

struct ScrollBackToTodayButton_Previews: PreviewProvider {
    static var previews: some View {
        LightDarkThemePreview {
            ScrollBackToTodayButton(scrollBackToToday: {}, color: .purple)
        }
    }
}
