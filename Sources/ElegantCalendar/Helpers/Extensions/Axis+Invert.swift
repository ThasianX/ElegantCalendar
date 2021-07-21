// Kevin Li - 12:07 PM - 8/4/20

import SwiftUI

extension Axis {

    var inverted: Axis {
        (self == .vertical) ? .horizontal : .vertical
    }

}

extension View {
    
    /// Read the height of a view
    ///
    /// - Parameters:
    ///   - onChange: `onChange` closure passes the view's width as its parameter.
    ///
    /// - Returns: A background with no color
    func readHeight(onChange: @escaping (CGFloat) -> Void) -> some View {
        return self.background(GeometryReader { proxy in
            Color.clear.preference(key: WidthPreferenceKey.self, value: proxy.size.height)
        })
        .onPreferenceChange(WidthPreferenceKey.self, perform: onChange)
    }
}

// MARK: - Width Preference Key
struct WidthPreferenceKey: PreferenceKey {

    typealias Value = CGFloat

    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
