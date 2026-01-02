import SwiftUI

// MARK: - Theme Provider Configuration

public struct ThemeProviderConfiguration: Sendable {
    public var theme: Theme
    public var animated: Bool
    public var animationDuration: Double
    public var propagateToChildren: Bool
    
    public init(
        theme: Theme = .default,
        animated: Bool = true,
        animationDuration: Double = 0.3,
        propagateToChildren: Bool = true
    ) {
        self.theme = theme
        self.animated = animated
        self.animationDuration = animationDuration
        self.propagateToChildren = propagateToChildren
    }
    
    // MARK: - Presets
    
    public static let `default` = ThemeProviderConfiguration()
    
    public static let instant = ThemeProviderConfiguration(animated: false)
    
    public static let smooth = ThemeProviderConfiguration(
        animationDuration: 0.5
    )
}

// MARK: - Theme Provider

/// A container view that provides theme context to its children
public struct ThemeProvider<Content: View>: View {
    private var configuration: ThemeProviderConfiguration
    private let content: Content
    
    public init(
        configuration: ThemeProviderConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    public init(
        theme: Theme,
        animated: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = ThemeProviderConfiguration(theme: theme, animated: animated)
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.luxeTheme, configuration.theme)
            .animation(
                configuration.animated
                    ? .easeInOut(duration: configuration.animationDuration)
                    : nil,
                value: configuration.theme.primaryColor.description
            )
    }
    
    // MARK: - Modifier Methods
    
    public func theme(_ theme: Theme) -> ThemeProvider {
        var copy = self
        copy.configuration.theme = theme
        return copy
    }
    
    public func animated(_ value: Bool) -> ThemeProvider {
        var copy = self
        copy.configuration.animated = value
        return copy
    }
    
    public func animationDuration(_ duration: Double) -> ThemeProvider {
        var copy = self
        copy.configuration.animationDuration = duration
        return copy
    }
}

// MARK: - Dynamic Theme Provider

/// A theme provider that can switch between themes dynamically
public struct DynamicThemeProvider<Content: View>: View {
    @Binding private var currentTheme: Theme
    private var animated: Bool
    private var animationDuration: Double
    private let content: Content
    
    public init(
        theme: Binding<Theme>,
        animated: Bool = true,
        animationDuration: Double = 0.3,
        @ViewBuilder content: () -> Content
    ) {
        self._currentTheme = theme
        self.animated = animated
        self.animationDuration = animationDuration
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.luxeTheme, currentTheme)
            .animation(
                animated ? .easeInOut(duration: animationDuration) : nil,
                value: currentTheme.primaryColor.description
            )
    }
}

// MARK: - Theme Picker

public struct ThemePicker: View {
    @Binding private var selectedPreset: ThemePreset
    private var showLabels: Bool
    private var itemSize: CGFloat
    
    public init(
        selection: Binding<ThemePreset>,
        showLabels: Bool = true,
        itemSize: CGFloat = 40
    ) {
        self._selectedPreset = selection
        self.showLabels = showLabels
        self.itemSize = itemSize
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ThemePreset.allCases, id: \.rawValue) { preset in
                    ThemePresetButton(
                        preset: preset,
                        isSelected: selectedPreset == preset,
                        showLabel: showLabels,
                        size: itemSize
                    ) {
                        selectedPreset = preset
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Theme Preset Button

private struct ThemePresetButton: View {
    let preset: ThemePreset
    let isSelected: Bool
    let showLabel: Bool
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [preset.theme.primaryColor, preset.theme.secondaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size, height: size)
                    
                    if isSelected {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: size + 6, height: size + 6)
                    }
                }
                
                if showLabel {
                    Text(preset.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white : .gray)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Theme-Aware Components

/// A text view that automatically uses theme colors
public struct ThemedText: View {
    @Environment(\.luxeTheme) private var theme
    
    private let text: String
    private var style: TextStyle
    private var customColor: Color?
    
    public enum TextStyle {
        case body
        case headline
        case caption
        case display
    }
    
    public init(_ text: String, style: TextStyle = .body) {
        self.text = text
        self.style = style
    }
    
    public var body: some View {
        Text(text)
            .font(fontForStyle)
            .foregroundColor(customColor ?? colorForStyle)
    }
    
    private var fontForStyle: Font {
        switch style {
        case .body: return .system(size: theme.typography.fontSizeM)
        case .headline: return .system(size: theme.typography.fontSizeXL, weight: .bold)
        case .caption: return .system(size: theme.typography.fontSizeS)
        case .display: return .system(size: theme.typography.fontSizeDisplay, weight: .bold)
        }
    }
    
    private var colorForStyle: Color {
        switch style {
        case .body, .display: return theme.textColor
        case .headline: return theme.textColor
        case .caption: return theme.textSecondaryColor
        }
    }
    
    // MARK: - Modifiers
    
    public func foregroundColor(_ color: Color) -> ThemedText {
        var copy = self
        copy.customColor = color
        return copy
    }
}

/// A background view that uses theme colors
public struct ThemedBackground<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    
    private let content: Content
    private var useSurface: Bool
    
    public init(
        useSurface: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.useSurface = useSurface
        self.content = content()
    }
    
    public var body: some View {
        content
            .background(useSurface ? theme.surfaceColor : theme.backgroundColor)
    }
}
