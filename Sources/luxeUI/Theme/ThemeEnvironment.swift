import SwiftUI

/// Environment key for storing the LuxeUI theme
/// This allows theme to flow down the view hierarchy automatically
struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: Theme = .default
}

extension EnvironmentValues {
    /// Access the current LuxeUI theme from the environment
    /// Internal access - used by LuxeUI components to read the theme
    var luxeTheme: Theme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}
