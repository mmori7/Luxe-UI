import SwiftUI

/// A view modifier that injects a LuxeUI theme into the environment
/// This allows all child views to access the theme automatically
struct ThemeModifier: ViewModifier {
    let theme: Theme
    
    func body(content: Content) -> some View {
        content
            .environment(\.luxeTheme, theme)
    }
}

extension View {
    /// Apply a LuxeUI theme to this view and all its descendants
    ///
    /// Use this modifier at the root of your app to set the global theme for all LuxeUI components.
    ///
    /// Example:
    /// ```swift
    /// ContentView()
    ///     .luxeTheme(.midnight)
    /// ```
    ///
    /// Or create a custom theme:
    /// ```swift
    /// let customTheme = Theme(
    ///     primaryColor: .blue,
    ///     secondaryColor: .purple,
    ///     cornerRadiusMedium: 12
    /// )
    ///
    /// ContentView()
    ///     .luxeTheme(customTheme)
    /// ```
    ///
    /// - Parameter theme: The theme to apply to this view hierarchy
    /// - Returns: A view with the theme injected into the environment
    public func luxeTheme(_ theme: Theme) -> some View {
        modifier(ThemeModifier(theme: theme))
    }
}
