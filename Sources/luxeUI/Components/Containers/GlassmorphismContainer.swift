import SwiftUI

/// A modern glassmorphic container that provides a frosted glass effect with blur and transparency.
///
/// The glassmorphism effect creates a semi-transparent container with a blurred background,
/// giving the appearance of frosted glass. This component automatically adapts to the current theme.
///
/// Example usage:
/// ```swift
/// GlassmorphismContainer {
///     VStack {
///         Text("Hello, World!")
///         Button("Click Me") { }
///     }
/// }
/// ```
///
/// With customization:
/// ```swift
/// GlassmorphismContainer(
///     blurRadius: 20,
///     opacity: 0.3,
///     borderColor: .white.opacity(0.3)
/// ) {
///     MyContent()
/// }
/// ```
public struct GlassmorphismContainer<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    
    private let content: Content
    private let blurRadius: CGFloat
    private let opacity: Double
    private let borderColor: Color?
    private let borderWidth: CGFloat
    private let cornerRadius: CGFloat?
    private let shadowEnabled: Bool
    
    /// Creates a glassmorphism container with default settings
    /// - Parameter content: The content to display inside the container
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.blurRadius = 10
        self.opacity = 0.2
        self.borderColor = nil
        self.borderWidth = 1
        self.cornerRadius = nil
        self.shadowEnabled = true
    }
    
    /// Creates a glassmorphism container with custom settings
    /// - Parameters:
    ///   - blurRadius: The blur radius for the frosted glass effect (default: 10)
    ///   - opacity: The background opacity (default: 0.2)
    ///   - borderColor: Custom border color (default: uses theme secondary color with opacity)
    ///   - borderWidth: Width of the border (default: 1)
    ///   - cornerRadius: Custom corner radius (default: uses theme medium corner radius)
    ///   - shadowEnabled: Whether to show shadow (default: true)
    ///   - content: The content to display inside the container
    public init(
        blurRadius: CGFloat = 10,
        opacity: Double = 0.2,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat? = nil,
        shadowEnabled: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.blurRadius = blurRadius
        self.opacity = opacity
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.shadowEnabled = shadowEnabled
    }
    
    public var body: some View {
        content
            .padding(theme.spacingM)
            .background(
                GlassMaterial(
                    blurRadius: blurRadius,
                    opacity: opacity,
                    cornerRadius: cornerRadius ?? theme.cornerRadiusMedium
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius ?? theme.cornerRadiusMedium)
                    .strokeBorder(
                        borderColor ?? theme.secondaryColor.opacity(0.3),
                        lineWidth: borderWidth
                    )
            )
            .shadow(
                color: shadowEnabled ? Color.black.opacity(theme.shadowOpacity) : .clear,
                radius: shadowEnabled ? theme.shadowRadiusMedium : 0,
                x: 0,
                y: shadowEnabled ? 4 : 0
            )
    }
}

/// Internal view that creates the glass material effect
private struct GlassMaterial: View {
    let blurRadius: CGFloat
    let opacity: Double
    let cornerRadius: CGFloat
    
    var body: some View {
        ZStack {
            // Frosted glass blur effect
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .opacity(opacity)
            
            // Subtle gradient overlay for depth
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
}

// MARK: - Convenience Modifiers

extension View {
    /// Wraps the view in a glassmorphism container
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .glassmorphic()
    /// ```
    public func glassmorphic(
        blurRadius: CGFloat = 10,
        opacity: Double = 0.2,
        borderColor: Color? = nil,
        shadowEnabled: Bool = true
    ) -> some View {
        GlassmorphismContainer(
            blurRadius: blurRadius,
            opacity: opacity,
            borderColor: borderColor,
            shadowEnabled: shadowEnabled
        ) {
            self
        }
    }
}
