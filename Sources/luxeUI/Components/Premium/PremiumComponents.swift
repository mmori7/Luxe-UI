import SwiftUI

// MARK: - LuxeCard Configuration

public struct LuxeCardConfiguration: Sendable {
    public var cornerRadius: CGFloat
    public var blur: CGFloat
    public var backgroundOpacity: Double
    public var borderWidth: CGFloat
    public var borderOpacity: Double
    public var shadowColor: Color
    public var shadowRadius: CGFloat
    public var shadowX: CGFloat
    public var shadowY: CGFloat
    public var hoverScale: CGFloat
    public var pressScale: CGFloat
    public var animationResponse: Double
    public var animationDamping: Double
    public var enableHaptics: Bool
    
    public init(
        cornerRadius: CGFloat = 20,
        blur: CGFloat = 10,
        backgroundOpacity: Double = 0.15,
        borderWidth: CGFloat = 1,
        borderOpacity: Double = 0.3,
        shadowColor: Color = .black,
        shadowRadius: CGFloat = 20,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 10,
        hoverScale: CGFloat = 1.02,
        pressScale: CGFloat = 0.98,
        animationResponse: Double = 0.3,
        animationDamping: Double = 0.7,
        enableHaptics: Bool = true
    ) {
        self.cornerRadius = cornerRadius
        self.blur = blur
        self.backgroundOpacity = backgroundOpacity
        self.borderWidth = borderWidth
        self.borderOpacity = borderOpacity
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.hoverScale = hoverScale
        self.pressScale = pressScale
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
        self.enableHaptics = enableHaptics
    }
    
    // Presets
    public static let `default` = LuxeCardConfiguration()
    
    public static let compact = LuxeCardConfiguration(
        cornerRadius: 12,
        blur: 8,
        shadowRadius: 10,
        hoverScale: 1.01
    )
    
    public static let prominent = LuxeCardConfiguration(
        cornerRadius: 28,
        blur: 15,
        backgroundOpacity: 0.2,
        shadowRadius: 30,
        shadowY: 15,
        hoverScale: 1.05
    )
    
    public static let subtle = LuxeCardConfiguration(
        cornerRadius: 16,
        blur: 5,
        backgroundOpacity: 0.1,
        shadowRadius: 8,
        hoverScale: 1.01
    )
    
    public static let floating = LuxeCardConfiguration(
        cornerRadius: 24,
        blur: 12,
        shadowRadius: 40,
        shadowY: 20,
        hoverScale: 1.03
    )
}

// MARK: - LuxeCard

public struct LuxeCard<Content: View>: View {
    private let content: Content
    private var configuration: LuxeCardConfiguration
    
    @State private var isHovered = false
    @State private var isPressed = false
    
    // Callbacks
    private var onHoverStart: (() -> Void)?
    private var onHoverEnd: (() -> Void)?
    private var onTapAction: (() -> Void)?
    
    public init(
        configuration: LuxeCardConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    // Convenience initializers with individual parameters
    public init(
        cornerRadius: CGFloat = 20,
        blur: CGFloat = 10,
        backgroundOpacity: Double = 0.15,
        borderWidth: CGFloat = 1,
        shadowRadius: CGFloat = 20,
        hoverScale: CGFloat = 1.02,
        pressScale: CGFloat = 0.98,
        enableHaptics: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = LuxeCardConfiguration(
            cornerRadius: cornerRadius,
            blur: blur,
            backgroundOpacity: backgroundOpacity,
            borderWidth: borderWidth,
            shadowRadius: shadowRadius,
            hoverScale: hoverScale,
            pressScale: pressScale,
            enableHaptics: enableHaptics
        )
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: configuration.cornerRadius)
                            .fill(.white.opacity(configuration.backgroundOpacity))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(configuration.borderOpacity),
                                .white.opacity(configuration.borderOpacity * 0.33)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: configuration.borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
            .shadow(
                color: configuration.shadowColor.opacity(0.3),
                radius: configuration.shadowRadius,
                x: configuration.shadowX,
                y: configuration.shadowY
            )
            .scaleEffect(isPressed ? configuration.pressScale : (isHovered ? configuration.hoverScale : 1.0))
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                value: isHovered
            )
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                value: isPressed
            )
            .onHover { hovering in
                isHovered = hovering
                if hovering {
                    onHoverStart?()
                } else {
                    onHoverEnd?()
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            if configuration.enableHaptics {
                                TactileFeedback.light()
                            }
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        onTapAction?()
                    }
            )
    }
    
    // Modifier methods for callbacks
    public func onHoverStart(_ action: @escaping () -> Void) -> LuxeCard {
        var copy = self
        copy.onHoverStart = action
        return copy
    }
    
    public func onHoverEnd(_ action: @escaping () -> Void) -> LuxeCard {
        var copy = self
        copy.onHoverEnd = action
        return copy
    }
    
    public func onTap(_ action: @escaping () -> Void) -> LuxeCard {
        var copy = self
        copy.onTapAction = action
        return copy
    }
    
    // Modifier methods for configuration
    public func cardCornerRadius(_ radius: CGFloat) -> LuxeCard {
        var copy = self
        copy.configuration.cornerRadius = radius
        return copy
    }
    
    public func cardShadow(color: Color = .black, radius: CGFloat = 20, x: CGFloat = 0, y: CGFloat = 10) -> LuxeCard {
        var copy = self
        copy.configuration.shadowColor = color
        copy.configuration.shadowRadius = radius
        copy.configuration.shadowX = x
        copy.configuration.shadowY = y
        return copy
    }
    
    public func cardHoverEffect(scale: CGFloat = 1.02) -> LuxeCard {
        var copy = self
        copy.configuration.hoverScale = scale
        return copy
    }
    
    public func cardPressEffect(scale: CGFloat = 0.98) -> LuxeCard {
        var copy = self
        copy.configuration.pressScale = scale
        return copy
    }
}

// MARK: - LuxeButton Configuration

public struct LuxeButtonConfiguration: Sendable {
    public var cornerRadius: CGFloat
    public var fontSize: CGFloat
    public var fontWeight: Font.Weight
    public var paddingHorizontal: CGFloat
    public var paddingVertical: CGFloat
    public var shadowRadius: CGFloat
    public var pressScale: CGFloat
    public var animationResponse: Double
    public var animationDamping: Double
    public var enableHaptics: Bool
    public var hapticIntensity: TactileFeedback.Intensity
    
    public init(
        cornerRadius: CGFloat = 12,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .semibold,
        paddingHorizontal: CGFloat = 24,
        paddingVertical: CGFloat = 12,
        shadowRadius: CGFloat = 10,
        pressScale: CGFloat = 0.95,
        animationResponse: Double = 0.2,
        animationDamping: Double = 0.7,
        enableHaptics: Bool = true,
        hapticIntensity: TactileFeedback.Intensity = .medium
    ) {
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.shadowRadius = shadowRadius
        self.pressScale = pressScale
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
        self.enableHaptics = enableHaptics
        self.hapticIntensity = hapticIntensity
    }
    
    // Size presets
    public static let small = LuxeButtonConfiguration(
        cornerRadius: 8,
        fontSize: 14,
        paddingHorizontal: 16,
        paddingVertical: 8,
        shadowRadius: 6
    )
    
    public static let medium = LuxeButtonConfiguration()
    
    public static let large = LuxeButtonConfiguration(
        cornerRadius: 16,
        fontSize: 18,
        paddingHorizontal: 32,
        paddingVertical: 16,
        shadowRadius: 15
    )
    
    public static let extraLarge = LuxeButtonConfiguration(
        cornerRadius: 20,
        fontSize: 20,
        fontWeight: .bold,
        paddingHorizontal: 40,
        paddingVertical: 20,
        shadowRadius: 20
    )
}

public enum LuxeButtonStyle: Sendable {
    case primary
    case secondary
    case glass
    case custom(
        background: [Color],
        foreground: Color,
        shadowColor: Color
    )
}

public struct LuxeButton: View {
    private let title: String
    private let style: LuxeButtonStyle
    private var configuration: LuxeButtonConfiguration
    private let action: () -> Void
    
    // Custom colors
    private var customGradient: [Color]?
    private var customForeground: Color?
    private var customShadowColor: Color?
    
    @State private var isPressed = false
    @Environment(\.luxeTheme) private var theme
    
    public init(
        _ title: String,
        style: LuxeButtonStyle = .primary,
        configuration: LuxeButtonConfiguration = .medium,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.configuration = configuration
        self.action = action
    }
    
    // Size convenience initializers
    public static func small(_ title: String, style: LuxeButtonStyle = .primary, action: @escaping () -> Void) -> LuxeButton {
        LuxeButton(title, style: style, configuration: .small, action: action)
    }
    
    public static func medium(_ title: String, style: LuxeButtonStyle = .primary, action: @escaping () -> Void) -> LuxeButton {
        LuxeButton(title, style: style, configuration: .medium, action: action)
    }
    
    public static func large(_ title: String, style: LuxeButtonStyle = .primary, action: @escaping () -> Void) -> LuxeButton {
        LuxeButton(title, style: style, configuration: .large, action: action)
    }
    
    private var gradientColors: [Color] {
        if let custom = customGradient { return custom }
        switch style {
        case .primary:
            return [theme.primaryColor, theme.accentColor]
        case .secondary:
            return [theme.secondaryColor, theme.secondaryColor.opacity(0.8)]
        case .glass:
            return [.white.opacity(0.2), .white.opacity(0.1)]
        case .custom(let background, _, _):
            return background
        }
    }
    
    private var foregroundColor: Color {
        if let custom = customForeground { return custom }
        switch style {
        case .primary, .secondary:
            return .white
        case .glass:
            return .white
        case .custom(_, let foreground, _):
            return foreground
        }
    }
    
    private var shadowColor: Color {
        if let custom = customShadowColor { return custom }
        switch style {
        case .primary:
            return theme.primaryColor
        case .secondary:
            return theme.secondaryColor
        case .glass:
            return .clear
        case .custom(_, _, let shadow):
            return shadow
        }
    }
    
    public var body: some View {
        Button(action: {
            if configuration.enableHaptics {
                TactileFeedback.trigger(configuration.hapticIntensity)
            }
            action()
        }) {
            Text(title)
                .font(.system(size: configuration.fontSize, weight: configuration.fontWeight))
                .foregroundColor(foregroundColor)
                .padding(.horizontal, configuration.paddingHorizontal)
                .padding(.vertical, configuration.paddingVertical)
                .background(
                    Group {
                        if case .glass = style {
                            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                                .fill(.ultraThinMaterial)
                        } else {
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(
                    color: shadowColor.opacity(0.4),
                    radius: configuration.shadowRadius,
                    y: 5
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? configuration.pressScale : 1.0)
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: isPressed
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
    
    // Customization methods
    public func gradient(_ colors: [Color]) -> LuxeButton {
        var copy = self
        copy.customGradient = colors
        return copy
    }
    
    public func foregroundColor(_ color: Color) -> LuxeButton {
        var copy = self
        copy.customForeground = color
        return copy
    }
    
    public func shadowColor(_ color: Color) -> LuxeButton {
        var copy = self
        copy.customShadowColor = color
        return copy
    }
    
    public func cornerRadius(_ radius: CGFloat) -> LuxeButton {
        var copy = self
        copy.configuration.cornerRadius = radius
        return copy
    }
    
    public func fontSize(_ size: CGFloat) -> LuxeButton {
        var copy = self
        copy.configuration.fontSize = size
        return copy
    }
}

// MARK: - LuxeBadge Configuration

public struct LuxeBadgeConfiguration: Sendable {
    public var fontSize: CGFloat
    public var fontWeight: Font.Weight
    public var paddingHorizontal: CGFloat
    public var paddingVertical: CGFloat
    public var cornerRadius: CGFloat
    public var backgroundOpacity: Double
    public var glowRadius: CGFloat
    public var glowOpacity: Double
    public var enableGlow: Bool
    
    public init(
        fontSize: CGFloat = 10,
        fontWeight: Font.Weight = .bold,
        paddingHorizontal: CGFloat = 12,
        paddingVertical: CGFloat = 6,
        cornerRadius: CGFloat = 20,
        backgroundOpacity: Double = 0.2,
        glowRadius: CGFloat = 8,
        glowOpacity: Double = 0.5,
        enableGlow: Bool = true
    ) {
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.cornerRadius = cornerRadius
        self.backgroundOpacity = backgroundOpacity
        self.glowRadius = glowRadius
        self.glowOpacity = glowOpacity
        self.enableGlow = enableGlow
    }
    
    public static let `default` = LuxeBadgeConfiguration()
    public static let small = LuxeBadgeConfiguration(fontSize: 8, paddingHorizontal: 8, paddingVertical: 4)
    public static let large = LuxeBadgeConfiguration(fontSize: 12, paddingHorizontal: 16, paddingVertical: 8)
    public static let noGlow = LuxeBadgeConfiguration(enableGlow: false)
}

public struct LuxeBadge: View {
    private let text: String
    private let color: Color
    private let configuration: LuxeBadgeConfiguration
    
    public init(
        _ text: String,
        color: Color = .white,
        configuration: LuxeBadgeConfiguration = .default
    ) {
        self.text = text
        self.color = color
        self.configuration = configuration
    }
    
    public var body: some View {
        Text(text)
            .font(.system(size: configuration.fontSize, weight: configuration.fontWeight))
            .foregroundColor(color)
            .padding(.horizontal, configuration.paddingHorizontal)
            .padding(.vertical, configuration.paddingVertical)
            .background(
                Capsule()
                    .fill(color.opacity(configuration.backgroundOpacity))
                    .overlay(
                        Capsule()
                            .stroke(color.opacity(0.5), lineWidth: 1)
                    )
            )
            .shadow(
                color: configuration.enableGlow ? color.opacity(configuration.glowOpacity) : .clear,
                radius: configuration.glowRadius
            )
    }
}

// MARK: - FloatingOrb Configuration

public struct FloatingOrbConfiguration: Sendable {
    public var blurRadius: CGFloat
    public var opacity: Double
    public var animationDuration: Double
    public var animationRange: CGFloat
    public var enableAnimation: Bool
    public var enableGlow: Bool
    public var glowRadius: CGFloat
    
    public init(
        blurRadius: CGFloat = 60,
        opacity: Double = 0.6,
        animationDuration: Double = 4,
        animationRange: CGFloat = 20,
        enableAnimation: Bool = true,
        enableGlow: Bool = true,
        glowRadius: CGFloat = 50
    ) {
        self.blurRadius = blurRadius
        self.opacity = opacity
        self.animationDuration = animationDuration
        self.animationRange = animationRange
        self.enableAnimation = enableAnimation
        self.enableGlow = enableGlow
        self.glowRadius = glowRadius
    }
    
    public static let `default` = FloatingOrbConfiguration()
    public static let subtle = FloatingOrbConfiguration(blurRadius: 80, opacity: 0.4, animationRange: 10)
    public static let vibrant = FloatingOrbConfiguration(blurRadius: 40, opacity: 0.8, animationRange: 30)
    public static let `static` = FloatingOrbConfiguration(enableAnimation: false)
}

public struct FloatingOrb: View {
    private let size: CGFloat
    private let color: Color
    private let configuration: FloatingOrbConfiguration
    
    @State private var offset: CGFloat = 0
    
    public init(
        size: CGFloat,
        color: Color,
        configuration: FloatingOrbConfiguration = .default
    ) {
        self.size = size
        self.color = color
        self.configuration = configuration
    }
    
    public var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color, color.opacity(0.3), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .blur(radius: configuration.blurRadius)
            .opacity(configuration.opacity)
            .shadow(
                color: configuration.enableGlow ? color.opacity(0.5) : .clear,
                radius: configuration.glowRadius
            )
            .offset(y: configuration.enableAnimation ? offset : 0)
            .onAppear {
                if configuration.enableAnimation {
                    withAnimation(
                        .easeInOut(duration: configuration.animationDuration)
                        .repeatForever(autoreverses: true)
                    ) {
                        offset = configuration.animationRange
                    }
                }
            }
    }
}

// MARK: - MeshGradientBackground Configuration

public struct MeshGradientConfiguration: Sendable {
    public var orbCount: Int
    public var orbSizes: [CGFloat]
    public var orbOffsets: [(x: CGFloat, y: CGFloat)]
    public var orbBlur: CGFloat
    public var orbOpacity: Double
    public var animationDuration: Double
    public var animationRange: CGFloat
    public var enableAnimation: Bool
    public var backgroundColor: Color
    
    public init(
        orbCount: Int = 3,
        orbSizes: [CGFloat] = [400, 350, 300],
        orbOffsets: [(x: CGFloat, y: CGFloat)] = [(-100, -200), (150, 100), (-50, 250)],
        orbBlur: CGFloat = 100,
        orbOpacity: Double = 0.7,
        animationDuration: Double = 8,
        animationRange: CGFloat = 50,
        enableAnimation: Bool = true,
        backgroundColor: Color = Color(red: 0.05, green: 0.05, blue: 0.1)
    ) {
        self.orbCount = orbCount
        self.orbSizes = orbSizes
        self.orbOffsets = orbOffsets
        self.orbBlur = orbBlur
        self.orbOpacity = orbOpacity
        self.animationDuration = animationDuration
        self.animationRange = animationRange
        self.enableAnimation = enableAnimation
        self.backgroundColor = backgroundColor
    }
    
    public static let `default` = MeshGradientConfiguration()
    
    public static let minimal = MeshGradientConfiguration(
        orbCount: 2,
        orbSizes: [300, 250],
        orbOffsets: [(0, -100), (0, 100)],
        orbBlur: 120,
        orbOpacity: 0.5
    )
    
    public static let vibrant = MeshGradientConfiguration(
        orbCount: 5,
        orbSizes: [450, 400, 350, 300, 250],
        orbOffsets: [(-150, -250), (200, -100), (-100, 150), (150, 200), (0, 0)],
        orbBlur: 80,
        orbOpacity: 0.85,
        animationRange: 70
    )
    
    public static let `static` = MeshGradientConfiguration(enableAnimation: false)
}

public struct MeshGradientBackground: View {
    private let colors: [Color]
    private let configuration: MeshGradientConfiguration
    
    @State private var animate = false
    
    public init(
        colors: [Color],
        configuration: MeshGradientConfiguration = .default
    ) {
        self.colors = colors
        self.configuration = configuration
    }
    
    // Convenience initializer with individual parameters
    public init(
        colors: [Color],
        orbCount: Int = 3,
        orbBlur: CGFloat = 100,
        orbOpacity: Double = 0.7,
        animationDuration: Double = 8,
        enableAnimation: Bool = true,
        backgroundColor: Color = Color(red: 0.05, green: 0.05, blue: 0.1)
    ) {
        self.colors = colors
        self.configuration = MeshGradientConfiguration(
            orbCount: orbCount,
            orbBlur: orbBlur,
            orbOpacity: orbOpacity,
            animationDuration: animationDuration,
            enableAnimation: enableAnimation,
            backgroundColor: backgroundColor
        )
    }
    
    public var body: some View {
        ZStack {
            configuration.backgroundColor
                .ignoresSafeArea()
            
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<min(colors.count, configuration.orbCount), id: \.self) { index in
                        let size = configuration.orbSizes.indices.contains(index) 
                            ? configuration.orbSizes[index] 
                            : CGFloat(400 - index * 50)
                        let offset = configuration.orbOffsets.indices.contains(index)
                            ? configuration.orbOffsets[index]
                            : (x: CGFloat(index * 50 - 100), y: CGFloat(index * 100 - 200))
                        
                        Circle()
                            .fill(colors[index])
                            .frame(width: size, height: size)
                            .blur(radius: configuration.orbBlur)
                            .opacity(configuration.orbOpacity)
                            .offset(
                                x: offset.x + (configuration.enableAnimation && animate ? configuration.animationRange : 0),
                                y: offset.y + (configuration.enableAnimation && animate ? configuration.animationRange : 0)
                            )
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if configuration.enableAnimation {
                withAnimation(
                    .easeInOut(duration: configuration.animationDuration)
                    .repeatForever(autoreverses: true)
                ) {
                    animate = true
                }
            }
        }
    }
}

// MARK: - TactileFeedback

public struct TactileFeedback: Sendable {
    public enum Intensity: Sendable {
        case light
        case medium
        case heavy
    }
    
    public static func trigger(_ intensity: Intensity) {
        switch intensity {
        case .light: light()
        case .medium: medium()
        case .heavy: heavy()
        }
    }
    
    public static func light() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
    }
    
    public static func medium() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        #endif
    }
    
    public static func heavy() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        #endif
    }
    
    public static func success() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
    }
    
    public static func warning() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        #endif
    }
    
    public static func error() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        #endif
    }
}
