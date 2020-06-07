// Kevin Li - 2:46 PM - 6/1/20

import SwiftUI

extension Color {
    
    static let blackPearl = Color("blackPearl")
    static let blackPearlComplement = Color("blackPearlComplement")
    
}

struct AppTheme {
    
    let primary: Color
    let complementary: Color
    
}

extension AppTheme {
    
    static let `default` = AppTheme(primary: .blackPearl, complementary: .blackPearlComplement)
    
}

struct AppThemeKey: EnvironmentKey {
    
    static let defaultValue: AppTheme = .default
    
}

extension EnvironmentValues {
    
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
    
}
