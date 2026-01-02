import SwiftUI

// MARK: - Smart Spring Engine

/// A velocity-aware spring animation engine that responds to gesture speed
/// Provides tactile, physics-based micro-interactions for 2026 UIs
public struct SmartSpringModifier: ViewModifier {
    @Environment(\.luxeTheme) private var theme
    
    @GestureState private var dragVelocity: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0.0
    @State private var offset: CGSize = .zero
    
    let sensitivity: CGFloat
    let enableRotation: Bool
    let enableOffset: Bool
    
    public init(
        sensitivity: CGFloat = 1.0,
        enableRotation: Bool = true,
        enableOffset: Bool = true
    ) {
        self.sensitivity = sensitivity
        self.enableRotation = enableRotation
        self.enableOffset = enableOffset
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .offset(offset)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($dragVelocity) { value, state, _ in
                        state = CGSize(
                            width: value.translation.width - value.predictedEndTranslation.width,
                            height: value.translation.height - value.predictedEndTranslation.height
                        )
                    }
                    .onChanged { value in
                        // Calculate velocity from gesture
                        let velocity = sqrt(
                            pow(value.predictedEndTranslation.width - value.translation.width, 2) +
                            pow(value.predictedEndTranslation.height - value.translation.height, 2)
                        )
                        
                        // Scale based on velocity - faster = more dramatic
                        let velocityScale = min(velocity / 100.0, 1.0) * sensitivity
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            scale = 1.0 - (velocityScale * 0.05)
                            
                            if enableRotation {
                                rotation = Double(value.translation.width / 20.0 * sensitivity)
                            }
                            
                            if enableOffset {
                                offset = CGSize(
                                    width: value.translation.width * 0.3,
                                    height: value.translation.height * 0.3
                                )
                            }
                        }
                    }
                    .onEnded { value in
                        // Spring back with velocity-aware timing
                        let velocity = sqrt(
                            pow(value.predictedEndTranslation.width, 2) +
                            pow(value.predictedEndTranslation.height, 2)
                        )
                        
                        let springResponse = max(0.3, min(0.6, 0.3 + velocity / 1000.0))
                        
                        withAnimation(.spring(response: springResponse, dampingFraction: 0.7)) {
                            scale = 1.0
                            rotation = 0.0
                            offset = .zero
                        }
                    }
            )
    }
}

// MARK: - Magnetic Pull Effect

/// Creates a magnetic attraction effect - UI elements "pull" toward cursor/touch
public struct MagneticPullModifier: ViewModifier {
    @Environment(\.luxeTheme) private var theme
    
    @State private var hoverLocation: CGPoint = .zero
    @State private var isHovering: Bool = false
    @State private var magneticOffset: CGSize = .zero
    @State private var magneticScale: CGFloat = 1.0
    @State private var glowIntensity: CGFloat = 0.0
    
    let radius: CGFloat
    let strength: CGFloat
    let enableGlow: Bool
    
    public init(
        radius: CGFloat = 100,
        strength: CGFloat = 0.3,
        enableGlow: Bool = true
    ) {
        self.radius = radius
        self.strength = strength
        self.enableGlow = enableGlow
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .offset(magneticOffset)
                .scaleEffect(magneticScale)
                .shadow(
                    color: theme.primaryColor.opacity(enableGlow ? glowIntensity * 0.6 : 0),
                    radius: 20 * glowIntensity,
                    x: 0,
                    y: 0
                )
                .onHover { hovering in
                    isHovering = hovering
                    if !hovering {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            magneticOffset = .zero
                            magneticScale = 1.0
                            glowIntensity = 0.0
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard isHovering else { return }
                            
                            let location = value.location
                            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            let distance = sqrt(
                                pow(location.x - center.x, 2) +
                                pow(location.y - center.y, 2)
                            )
                            
                            // Only activate within radius
                            if distance < radius {
                                let normalizedDistance = distance / radius
                                let pullStrength = (1.0 - normalizedDistance) * strength
                                
                                // Calculate pull direction
                                let angle = atan2(location.y - center.y, location.x - center.x)
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    magneticOffset = CGSize(
                                        width: cos(angle) * pullStrength * 15,
                                        height: sin(angle) * pullStrength * 15
                                    )
                                    magneticScale = 1.0 + (pullStrength * 0.05)
                                    glowIntensity = pullStrength
                                }
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    magneticOffset = .zero
                                    magneticScale = 1.0
                                    glowIntensity = 0.0
                                }
                            }
                        }
                )
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

// MARK: - Tactile Feedback System

/// High-fidelity haptic feedback system for micro-interactions
public struct TactileFeedback {
    public enum Style {
        case light
        case medium
        case heavy
        case success
        case warning
        case error
    }
    
    #if os(iOS)
    public static func trigger(_ style: Style) {
        let generator: UIImpactFeedbackGenerator
        
        switch style {
        case .light:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .medium:
            generator = UIImpactFeedbackGenerator(style: .medium)
        case .heavy:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            return
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            return
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        generator.prepare()
        generator.impactOccurred()
    }
    #else
    public static func trigger(_ style: Style) {
        // macOS haptics (limited support)
        NSHapticFeedbackManager.defaultPerformer.perform(
            .generic,
            performanceTime: .default
        )
    }
    #endif
}

// MARK: - Smart Spring Button

/// Button with velocity-aware springs and magnetic pull
public struct SmartSpringButton<Label: View>: View {
    @Environment(\.luxeTheme) private var theme
    
    let label: Label
    let style: ButtonStyle
    let action: () -> Void
    
    @State private var isPressed: Bool = false
    @State private var scale: CGFloat = 1.0
    
    public enum ButtonStyle {
        case primary
        case secondary
        case magnetic
    }
    
    public init(
        style: ButtonStyle = .primary,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.style = style
        self.action = action
        self.label = label()
    }
    
    public var body: some View {
        Button(action: {
            TactileFeedback.trigger(.medium)
            action()
        }) {
            label
                .padding(.horizontal, theme.spacingL)
                .padding(.vertical, theme.spacingM)
                .background(backgroundView)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusMedium))
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(scale)
        .modifier(SmartSpringModifier(sensitivity: 0.8, enableRotation: false))
        .modifier(
            style == .magnetic ?
            AnyViewModifier(MagneticPullModifier(radius: 80, strength: 0.4)) :
            AnyViewModifier(EmptyModifier())
        )
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = pressing ? 0.95 : 1.0
            }
            if pressing {
                TactileFeedback.trigger(.light)
            }
        }, perform: {})
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            LinearGradient(
                colors: [theme.primaryColor, theme.secondaryColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .secondary:
            theme.secondaryColor.opacity(0.3)
        case .magnetic:
            ZStack {
                LinearGradient(
                    colors: [theme.accentColor, theme.primaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Animated shimmer
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .blendMode(.overlay)
            }
        }
    }
}

// MARK: - Helper Wrappers

private struct AnyViewModifier: ViewModifier {
    let modifier: any ViewModifier
    
    init<M: ViewModifier>(_ modifier: M) {
        self.modifier = modifier
    }
    
    func body(content: Content) -> some View {
        content
    }
}

private struct EmptyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

// MARK: - View Extensions

extension View {
    /// Apply smart spring micro-interactions with velocity-aware physics
    ///
    /// Responds to gesture speed for tactile feedback
    ///
    /// Example:
    /// ```swift
    /// LuxeCard { }
    ///     .smartSprings(sensitivity: 1.0)
    /// ```
    public func smartSprings(
        sensitivity: CGFloat = 1.0,
        enableRotation: Bool = true,
        enableOffset: Bool = true
    ) -> some View {
        modifier(SmartSpringModifier(
            sensitivity: sensitivity,
            enableRotation: enableRotation,
            enableOffset: enableOffset
        ))
    }
    
    /// Apply magnetic pull effect - UI tilts toward cursor/touch
    ///
    /// Creates subtle attraction within specified radius
    ///
    /// Example:
    /// ```swift
    /// LuxeButton("Click") { }
    ///     .magneticPull(radius: 100, strength: 0.3)
    /// ```
    public func magneticPull(
        radius: CGFloat = 100,
        strength: CGFloat = 0.3,
        enableGlow: Bool = true
    ) -> some View {
        modifier(MagneticPullModifier(
            radius: radius,
            strength: strength,
            enableGlow: enableGlow
        ))
    }
}
