import SwiftUI

// MARK: - Environment Key

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .default
}

public extension EnvironmentValues {
    var luxeTheme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - Theme Modifier

public struct ThemeModifier: ViewModifier {
    private let theme: Theme
    
    public init(theme: Theme) {
        self.theme = theme
    }
    
    public func body(content: Content) -> some View {
        content
            .environment(\.luxeTheme, theme)
    }
}

// MARK: - View Extension

public extension View {
    /// Apply a LuxeUI theme to this view and all its children
    func luxeTheme(_ theme: Theme) -> some View {
        modifier(ThemeModifier(theme: theme))
    }
    
    /// Apply a preset theme
    func luxeTheme(_ preset: ThemePreset) -> some View {
        modifier(ThemeModifier(theme: preset.theme))
    }
}

// MARK: - Theme Reader

/// A view that reads the current theme from the environment
public struct ThemeReader<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    private let content: (Theme) -> Content
    
    public init(@ViewBuilder content: @escaping (Theme) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(theme)
    }
}
