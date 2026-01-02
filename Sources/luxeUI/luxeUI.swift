// LuxeUI - A highly customizable SwiftUI component library
// https://github.com/yourusername/luxeui

import SwiftUI

/// LuxeUI - A Style-System UI Kit for SwiftUI
///
/// LuxeUI provides complex, customizable UI components with a powerful theming system.
/// Set a theme at the root level and it flows down to all SDK components automatically.
///
/// ## Getting Started
///
/// 1. Import LuxeUI in your SwiftUI view:
/// ```swift
/// import LuxeUI
/// ```
///
/// 2. Apply a theme to your app:
/// ```swift
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .luxeTheme(.midnight)  // Apply preset theme
///         }
///     }
/// }
/// ```
///
/// 3. Or create a custom theme:
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
/// ## Available Components
/// - Premium Cards with Hover Effects
/// - Refractive Liquid Glass Effects (2026 signature effect)
/// - Animated Mesh Gradient Backgrounds
/// - Multi-thumb sliders
/// - Animated circular progress bars
/// - Glassmorphism containers
/// - Premium Buttons with Haptics
/// - Floating Orbs & Glowing Badges
///
public struct LuxeUI {
    /// Current version of LuxeUI
    public static let version = "1.0.0"
    
    private init() {}
}
