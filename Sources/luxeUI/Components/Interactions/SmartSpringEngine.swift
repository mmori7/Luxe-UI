import SwiftUI

// MARK: - Smart Spring Configuration

public struct SmartSpringConfiguration: Sendable {
    public var sensitivity: Double
    public var enableRotation: Bool
    public var rotationMultiplier: Double
    public var maxOffset: CGFloat
    public var maxRotation: Double
    public var responseSpeed: Double
    public var dampingFraction: Double
    public var velocityThreshold: CGFloat
    public var enableHaptics: Bool
    public var hapticIntensity: TactileFeedback.Intensity
    
    public init(
        sensitivity: Double = 1.0,
        enableRotation: Bool = false,
        rotationMultiplier: Double = 1.0,
        maxOffset: CGFloat = 100,
        maxRotation: Double = 15,
        responseSpeed: Double = 0.3,
        dampingFraction: Double = 0.7,
        velocityThreshold: CGFloat = 500,
        enableHaptics: Bool = true,
        hapticIntensity: TactileFeedback.Intensity = .light
    ) {
        self.sensitivity = sensitivity
        self.enableRotation = enableRotation
        self.rotationMultiplier = rotationMultiplier
        self.maxOffset = maxOffset
        self.maxRotation = maxRotation
        self.responseSpeed = responseSpeed
        self.dampingFraction = dampingFraction
        self.velocityThreshold = velocityThreshold
        self.enableHaptics = enableHaptics
        self.hapticIntensity = hapticIntensity
    }
    
    // Presets
    public static let `default` = SmartSpringConfiguration()
    
    public static let bouncy = SmartSpringConfiguration(
        sensitivity: 1.5,
        responseSpeed: 0.4,
        dampingFraction: 0.5
    )
    
    public static let stiff = SmartSpringConfiguration(
        sensitivity: 0.5,
        responseSpeed: 0.2,
        dampingFraction: 0.9
    )
    
    public static let wobbly = SmartSpringConfiguration(
        sensitivity: 1.2,
        enableRotation: true,
        rotationMultiplier: 1.5,
        dampingFraction: 0.4
    )
    
    public static let subtle = SmartSpringConfiguration(
        sensitivity: 0.3,
        maxOffset: 30,
        responseSpeed: 0.2
    )
}

// MARK: - Smart Spring Modifier

public struct SmartSpringModifier: ViewModifier {
    private let configuration: SmartSpringConfiguration
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @GestureState private var dragVelocity: CGSize = .zero
    
    public init(configuration: SmartSpringConfiguration = .default) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(offset)
            .rotationEffect(.degrees(configuration.enableRotation ? rotation : 0))
            .gesture(
                DragGesture()
                    .updating($dragVelocity) { value, state, _ in
                        state = value.translation
                    }
                    .onChanged { value in
                        let velocity = hypot(value.velocity.width, value.velocity.height)
                        let velocityFactor = min(velocity / configuration.velocityThreshold, 2.0)
                        let scaledSensitivity = configuration.sensitivity * (1.0 + velocityFactor * 0.5)
                        
                        withAnimation(.spring(
                            response: configuration.responseSpeed,
                            dampingFraction: configuration.dampingFraction
                        )) {
                            offset = CGSize(
                                width: min(max(value.translation.width * scaledSensitivity, -configuration.maxOffset), configuration.maxOffset),
                                height: min(max(value.translation.height * scaledSensitivity, -configuration.maxOffset), configuration.maxOffset)
                            )
                            
                            if configuration.enableRotation {
                                rotation = Double(value.translation.width / 20) * configuration.rotationMultiplier
                                rotation = min(max(rotation, -configuration.maxRotation), configuration.maxRotation)
                            }
                        }
                        
                        if velocity > configuration.velocityThreshold && configuration.enableHaptics {
                            TactileFeedback.trigger(configuration.hapticIntensity)
                        }
                    }
                    .onEnded { value in
                        let velocity = hypot(value.velocity.width, value.velocity.height)
                        
                        withAnimation(.spring(
                            response: configuration.responseSpeed,
                            dampingFraction: configuration.dampingFraction
                        )) {
                            offset = .zero
                            rotation = 0
                        }
                        
                        if velocity > configuration.velocityThreshold * 1.5 && configuration.enableHaptics {
                            TactileFeedback.medium()
                        }
                    }
            )
    }
}

// MARK: - Magnetic Pull Configuration

public struct MagneticPullConfiguration: Sendable {
    public var radius: CGFloat
    public var strength: Double
    public var maxOffset: CGFloat
    public var responseSpeed: Double
    public var dampingFraction: Double
    public var enableHaptics: Bool
    public var hapticOnEnter: Bool
    
    public init(
        radius: CGFloat = 100,
        strength: Double = 0.5,
        maxOffset: CGFloat = 20,
        responseSpeed: Double = 0.3,
        dampingFraction: Double = 0.7,
        enableHaptics: Bool = true,
        hapticOnEnter: Bool = true
    ) {
        self.radius = radius
        self.strength = strength
        self.maxOffset = maxOffset
        self.responseSpeed = responseSpeed
        self.dampingFraction = dampingFraction
        self.enableHaptics = enableHaptics
        self.hapticOnEnter = hapticOnEnter
    }
    
    public static let `default` = MagneticPullConfiguration()
    
    public static let strong = MagneticPullConfiguration(
        radius: 150,
        strength: 0.8,
        maxOffset: 30
    )
    
    public static let subtle = MagneticPullConfiguration(
        radius: 80,
        strength: 0.3,
        maxOffset: 10
    )
    
    public static let wide = MagneticPullConfiguration(
        radius: 200,
        strength: 0.4,
        maxOffset: 25
    )
}

// MARK: - Magnetic Pull Modifier

public struct MagneticPullModifier: ViewModifier {
    private let configuration: MagneticPullConfiguration
    
    @State private var offset: CGSize = .zero
    @State private var isInRange = false
    
    public init(configuration: MagneticPullConfiguration = .default) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(offset)
            .animation(
                .spring(response: configuration.responseSpeed, dampingFraction: configuration.dampingFraction),
                value: offset
            )
            .onHover { hovering in
                // Fallback for platforms without onContinuousHover
                if !hovering {
                    isInRange = false
                    offset = .zero
                }
            }
    }
}

// MARK: - Smart Spring Button Configuration

public struct SmartSpringButtonConfiguration: Sendable {
    public var cornerRadius: CGFloat
    public var padding: CGFloat
    public var shadowRadius: CGFloat
    public var pressScale: CGFloat
    public var hoverScale: CGFloat
    public var gradient: [Color]
    public var enableHaptics: Bool
    public var hapticIntensity: TactileFeedback.Intensity
    public var animationResponse: Double
    public var animationDamping: Double
    
    public init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 20,
        shadowRadius: CGFloat = 15,
        pressScale: CGFloat = 0.95,
        hoverScale: CGFloat = 1.05,
        gradient: [Color] = [.purple, .pink],
        enableHaptics: Bool = true,
        hapticIntensity: TactileFeedback.Intensity = .medium,
        animationResponse: Double = 0.3,
        animationDamping: Double = 0.7
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.shadowRadius = shadowRadius
        self.pressScale = pressScale
        self.hoverScale = hoverScale
        self.gradient = gradient
        self.enableHaptics = enableHaptics
        self.hapticIntensity = hapticIntensity
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
    }
    
    public static let `default` = SmartSpringButtonConfiguration()
    
    public static let magnetic = SmartSpringButtonConfiguration(
        cornerRadius: 20,
        padding: 24,
        shadowRadius: 20,
        hoverScale: 1.08,
        gradient: [.cyan, .blue]
    )
    
    public static let compact = SmartSpringButtonConfiguration(
        cornerRadius: 12,
        padding: 14,
        shadowRadius: 10,
        hoverScale: 1.03
    )
}

public enum SmartSpringButtonStyle: Sendable {
    case standard
    case magnetic
    case custom(SmartSpringButtonConfiguration)
}

// MARK: - Smart Spring Button

public struct SmartSpringButton<Label: View>: View {
    private let action: () -> Void
    private let label: Label
    private let style: SmartSpringButtonStyle
    private var configuration: SmartSpringButtonConfiguration
    
    @State private var isPressed = false
    @State private var isHovered = false
    @State private var magneticOffset: CGSize = .zero
    
    public init(
        style: SmartSpringButtonStyle = .standard,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.style = style
        self.action = action
        self.label = label()
        
        switch style {
        case .standard:
            self.configuration = .default
        case .magnetic:
            self.configuration = .magnetic
        case .custom(let config):
            self.configuration = config
        }
    }
    
    public var body: some View {
        Button(action: {
            if configuration.enableHaptics {
                TactileFeedback.trigger(configuration.hapticIntensity)
            }
            action()
        }) {
            label
                .padding(configuration.padding)
                .background(
                    LinearGradient(
                        colors: configuration.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(
                    color: configuration.gradient.first?.opacity(0.4) ?? .purple.opacity(0.4),
                    radius: configuration.shadowRadius,
                    y: 8
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? configuration.pressScale : (isHovered ? configuration.hoverScale : 1.0))
        .offset(magneticOffset)
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: isPressed
        )
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: isHovered
        )
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: magneticOffset
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onHover { hovering in
            isHovered = hovering
            if !hovering {
                magneticOffset = .zero
            }
        }
    }
    
    // Modifier methods
    public func gradient(_ colors: [Color]) -> SmartSpringButton {
        var copy = self
        copy.configuration.gradient = colors
        return copy
    }
    
    public func cornerRadius(_ radius: CGFloat) -> SmartSpringButton {
        var copy = self
        copy.configuration.cornerRadius = radius
        return copy
    }
    
    public func haptics(_ enabled: Bool, intensity: TactileFeedback.Intensity = .medium) -> SmartSpringButton {
        var copy = self
        copy.configuration.enableHaptics = enabled
        copy.configuration.hapticIntensity = intensity
        return copy
    }
}

// MARK: - View Extensions

public extension View {
    func smartSprings(configuration: SmartSpringConfiguration = .default) -> some View {
        self.modifier(SmartSpringModifier(configuration: configuration))
    }
    
    func smartSprings(
        sensitivity: Double = 1.0,
        enableRotation: Bool = false,
        rotationMultiplier: Double = 1.0,
        maxOffset: CGFloat = 100,
        responseSpeed: Double = 0.3,
        dampingFraction: Double = 0.7,
        enableHaptics: Bool = true
    ) -> some View {
        let config = SmartSpringConfiguration(
            sensitivity: sensitivity,
            enableRotation: enableRotation,
            rotationMultiplier: rotationMultiplier,
            maxOffset: maxOffset,
            responseSpeed: responseSpeed,
            dampingFraction: dampingFraction,
            enableHaptics: enableHaptics
        )
        return self.modifier(SmartSpringModifier(configuration: config))
    }
    
    func magneticPull(configuration: MagneticPullConfiguration = .default) -> some View {
        self.modifier(MagneticPullModifier(configuration: configuration))
    }
    
    func magneticPull(
        radius: CGFloat = 100,
        strength: Double = 0.5,
        maxOffset: CGFloat = 20,
        enableHaptics: Bool = true
    ) -> some View {
        let config = MagneticPullConfiguration(
            radius: radius,
            strength: strength,
            maxOffset: maxOffset,
            enableHaptics: enableHaptics
        )
        return self.modifier(MagneticPullModifier(configuration: config))
    }
}
