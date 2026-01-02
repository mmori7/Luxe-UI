import SwiftUI

/// Helper extension to make theme access easier within LuxeUI components
extension View {
    /// Access the current LuxeUI theme from the environment
    /// This is an internal helper that components use to style themselves
    ///
    /// Example usage within a component:
    /// ```swift
    /// struct MyComponent: View {
    ///     var body: some View {
    ///         withLuxeTheme { theme in
    ///             Text("Hello")
    ///                 .foregroundColor(theme.primaryColor)
    ///                 .font(.system(size: theme.fontSizeBody))
    ///         }
    ///     }
    /// }
    /// ```
    @ViewBuilder
    func withLuxeTheme<Content: View>(@ViewBuilder _ content: @escaping (Theme) -> Content) -> some View {
        ThemedContent(content: content)
    }
}

/// Internal view that reads the theme from environment and passes it to content
private struct ThemedContent<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    let content: (Theme) -> Content
    
    var body: some View {
        content(theme)
    }
}
