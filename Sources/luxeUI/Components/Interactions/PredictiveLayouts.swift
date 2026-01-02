import SwiftUI

// MARK: - Predictive Layout Configuration

public struct PredictiveLayoutConfiguration: Sendable {
    public var baseOpacity: Double
    public var activeOpacity: Double
    public var baseScale: CGFloat
    public var activeScale: CGFloat
    public var baseShadowRadius: CGFloat
    public var activeShadowRadius: CGFloat
    public var glowColor: Color
    public var glowOpacity: Double
    public var animationResponse: Double
    public var animationDamping: Double
    public var probabilityThreshold: Double
    public var enableGlow: Bool
    public var enableScale: Bool
    public var enableElevation: Bool
    
    public init(
        baseOpacity: Double = 0.7,
        activeOpacity: Double = 1.0,
        baseScale: CGFloat = 1.0,
        activeScale: CGFloat = 1.05,
        baseShadowRadius: CGFloat = 5,
        activeShadowRadius: CGFloat = 20,
        glowColor: Color = .blue,
        glowOpacity: Double = 0.3,
        animationResponse: Double = 0.3,
        animationDamping: Double = 0.7,
        probabilityThreshold: Double = 0.5,
        enableGlow: Bool = true,
        enableScale: Bool = true,
        enableElevation: Bool = true
    ) {
        self.baseOpacity = baseOpacity
        self.activeOpacity = activeOpacity
        self.baseScale = baseScale
        self.activeScale = activeScale
        self.baseShadowRadius = baseShadowRadius
        self.activeShadowRadius = activeShadowRadius
        self.glowColor = glowColor
        self.glowOpacity = glowOpacity
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
        self.probabilityThreshold = probabilityThreshold
        self.enableGlow = enableGlow
        self.enableScale = enableScale
        self.enableElevation = enableElevation
    }
    
    public static let `default` = PredictiveLayoutConfiguration()
    
    public static let subtle = PredictiveLayoutConfiguration(
        activeScale: 1.02,
        activeShadowRadius: 10,
        glowOpacity: 0.2
    )
    
    public static let prominent = PredictiveLayoutConfiguration(
        activeScale: 1.08,
        activeShadowRadius: 30,
        glowOpacity: 0.5
    )
    
    public static let noAnimation = PredictiveLayoutConfiguration(
        enableGlow: false,
        enableScale: false,
        enableElevation: false
    )
}

// MARK: - Adaptive Container

public struct LuxeAdaptiveContainer<Content: View>: View {
    private let content: Content
    private let probability: Double
    private var configuration: PredictiveLayoutConfiguration
    
    @Environment(\.luxeTheme) private var theme
    
    public init(
        probability: Double,
        configuration: PredictiveLayoutConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.probability = probability
        self.configuration = configuration
        self.content = content()
    }
    
    private var interpolatedOpacity: Double {
        configuration.baseOpacity + (configuration.activeOpacity - configuration.baseOpacity) * probability
    }
    
    private var interpolatedScale: CGFloat {
        if !configuration.enableScale { return 1.0 }
        return configuration.baseScale + (configuration.activeScale - configuration.baseScale) * CGFloat(probability)
    }
    
    private var interpolatedShadow: CGFloat {
        if !configuration.enableElevation { return 0 }
        return configuration.baseShadowRadius + (configuration.activeShadowRadius - configuration.baseShadowRadius) * CGFloat(probability)
    }
    
    public var body: some View {
        content
            .opacity(interpolatedOpacity)
            .scaleEffect(interpolatedScale)
            .shadow(
                color: configuration.enableGlow && probability > configuration.probabilityThreshold 
                    ? configuration.glowColor.opacity(configuration.glowOpacity * probability) 
                    : .clear,
                radius: interpolatedShadow
            )
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                value: probability
            )
    }
    
    // Modifier methods
    public func glowColor(_ color: Color) -> LuxeAdaptiveContainer {
        var copy = self
        copy.configuration.glowColor = color
        return copy
    }
    
    public func threshold(_ value: Double) -> LuxeAdaptiveContainer {
        var copy = self
        copy.configuration.probabilityThreshold = value
        return copy
    }
}

// MARK: - Smart Form Button Configuration

public struct SmartFormButtonConfiguration: Sendable {
    public var minWidth: CGFloat
    public var maxWidth: CGFloat
    public var minHeight: CGFloat
    public var maxHeight: CGFloat
    public var cornerRadius: CGFloat
    public var fontSize: CGFloat
    public var fontWeight: Font.Weight
    public var inactiveColors: [Color]
    public var activeColors: [Color]
    public var shadowRadius: CGFloat
    public var animationResponse: Double
    public var animationDamping: Double
    public var enableHaptics: Bool
    public var hapticThreshold: Double
    
    public init(
        minWidth: CGFloat = 120,
        maxWidth: CGFloat = 280,
        minHeight: CGFloat = 44,
        maxHeight: CGFloat = 56,
        cornerRadius: CGFloat = 14,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .semibold,
        inactiveColors: [Color] = [.gray.opacity(0.3), .gray.opacity(0.2)],
        activeColors: [Color] = [.green, .cyan],
        shadowRadius: CGFloat = 20,
        animationResponse: Double = 0.4,
        animationDamping: Double = 0.7,
        enableHaptics: Bool = true,
        hapticThreshold: Double = 0.5
    ) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.inactiveColors = inactiveColors
        self.activeColors = activeColors
        self.shadowRadius = shadowRadius
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
        self.enableHaptics = enableHaptics
        self.hapticThreshold = hapticThreshold
    }
    
    public static let `default` = SmartFormButtonConfiguration()
    
    public static let compact = SmartFormButtonConfiguration(
        minWidth: 100,
        maxWidth: 200,
        minHeight: 36,
        maxHeight: 48
    )
    
    public static let large = SmartFormButtonConfiguration(
        minWidth: 150,
        maxWidth: 350,
        minHeight: 50,
        maxHeight: 64,
        fontSize: 18
    )
}

// MARK: - Smart Form Button

public struct SmartFormButton: View {
    private let title: String
    private let completionProbability: Double
    private let action: () -> Void
    private var configuration: SmartFormButtonConfiguration
    
    @State private var isPressed = false
    @State private var lastHapticProbability: Double = 0
    
    public init(
        _ title: String,
        completionProbability: Double,
        configuration: SmartFormButtonConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.completionProbability = completionProbability
        self.configuration = configuration
        self.action = action
    }
    
    private var interpolatedWidth: CGFloat {
        configuration.minWidth + (configuration.maxWidth - configuration.minWidth) * CGFloat(completionProbability)
    }
    
    private var interpolatedHeight: CGFloat {
        configuration.minHeight + (configuration.maxHeight - configuration.minHeight) * CGFloat(completionProbability)
    }
    
    private var currentGradient: [Color] {
        if completionProbability < 0.3 {
            return configuration.inactiveColors
        } else if completionProbability < 0.7 {
            return [
                configuration.inactiveColors[0].opacity(1 - completionProbability),
                configuration.activeColors[0].opacity(completionProbability)
            ]
        } else {
            return configuration.activeColors
        }
    }
    
    public var body: some View {
        Button(action: {
            if configuration.enableHaptics {
                TactileFeedback.heavy()
            }
            action()
        }) {
            Text(title)
                .font(.system(size: configuration.fontSize, weight: configuration.fontWeight))
                .foregroundColor(.white)
                .frame(width: interpolatedWidth, height: interpolatedHeight)
                .background(
                    LinearGradient(
                        colors: currentGradient,
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
                    color: completionProbability > 0.5 
                        ? configuration.activeColors[0].opacity(0.4 * completionProbability) 
                        : .clear,
                    radius: configuration.shadowRadius * CGFloat(completionProbability),
                    y: 8
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: completionProbability
        )
        .animation(
            .spring(response: 0.2, dampingFraction: 0.7),
            value: isPressed
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onChange(of: completionProbability) { newValue in
            if configuration.enableHaptics {
                // Haptic when crossing threshold
                if newValue >= configuration.hapticThreshold && lastHapticProbability < configuration.hapticThreshold {
                    TactileFeedback.medium()
                }
                // Haptic when form becomes complete
                if newValue >= 0.95 && lastHapticProbability < 0.95 {
                    TactileFeedback.success()
                }
                lastHapticProbability = newValue
            }
        }
    }
    
    // Modifier methods
    public func colors(inactive: [Color], active: [Color]) -> SmartFormButton {
        var copy = self
        copy.configuration.inactiveColors = inactive
        copy.configuration.activeColors = active
        return copy
    }
    
    public func size(minWidth: CGFloat = 120, maxWidth: CGFloat = 280, minHeight: CGFloat = 44, maxHeight: CGFloat = 56) -> SmartFormButton {
        var copy = self
        copy.configuration.minWidth = minWidth
        copy.configuration.maxWidth = maxWidth
        copy.configuration.minHeight = minHeight
        copy.configuration.maxHeight = maxHeight
        return copy
    }
}

// MARK: - Predictive List Item Configuration

public struct PredictiveListItemConfiguration: Sendable {
    public var baseOpacity: Double
    public var activeOpacity: Double
    public var baseScale: CGFloat
    public var activeScale: CGFloat
    public var leadingPadding: CGFloat
    public var activeLeadingPadding: CGFloat
    public var glowColor: Color
    public var glowOpacity: Double
    public var shadowRadius: CGFloat
    public var animationResponse: Double
    public var enableHaptics: Bool
    
    public init(
        baseOpacity: Double = 0.6,
        activeOpacity: Double = 1.0,
        baseScale: CGFloat = 0.98,
        activeScale: CGFloat = 1.0,
        leadingPadding: CGFloat = 0,
        activeLeadingPadding: CGFloat = 8,
        glowColor: Color = .blue,
        glowOpacity: Double = 0.2,
        shadowRadius: CGFloat = 10,
        animationResponse: Double = 0.3,
        enableHaptics: Bool = true
    ) {
        self.baseOpacity = baseOpacity
        self.activeOpacity = activeOpacity
        self.baseScale = baseScale
        self.activeScale = activeScale
        self.leadingPadding = leadingPadding
        self.activeLeadingPadding = activeLeadingPadding
        self.glowColor = glowColor
        self.glowOpacity = glowOpacity
        self.shadowRadius = shadowRadius
        self.animationResponse = animationResponse
        self.enableHaptics = enableHaptics
    }
    
    public static let `default` = PredictiveListItemConfiguration()
    
    public static let subtle = PredictiveListItemConfiguration(
        baseOpacity: 0.8,
        activeScale: 1.0,
        activeLeadingPadding: 4
    )
    
    public static let prominent = PredictiveListItemConfiguration(
        baseOpacity: 0.5,
        activeScale: 1.02,
        activeLeadingPadding: 12,
        glowOpacity: 0.3
    )
}

// MARK: - Predictive List Item

public struct PredictiveListItem<Content: View>: View {
    private let content: Content
    private let probability: Double
    private var configuration: PredictiveListItemConfiguration
    
    public init(
        probability: Double,
        configuration: PredictiveListItemConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.probability = probability
        self.configuration = configuration
        self.content = content()
    }
    
    private var interpolatedOpacity: Double {
        configuration.baseOpacity + (configuration.activeOpacity - configuration.baseOpacity) * probability
    }
    
    private var interpolatedScale: CGFloat {
        configuration.baseScale + (configuration.activeScale - configuration.baseScale) * CGFloat(probability)
    }
    
    private var interpolatedPadding: CGFloat {
        configuration.leadingPadding + (configuration.activeLeadingPadding - configuration.leadingPadding) * CGFloat(probability)
    }
    
    public var body: some View {
        content
            .opacity(interpolatedOpacity)
            .scaleEffect(interpolatedScale, anchor: .leading)
            .padding(.leading, interpolatedPadding)
            .shadow(
                color: probability > 0.5 
                    ? configuration.glowColor.opacity(configuration.glowOpacity * probability) 
                    : .clear,
                radius: configuration.shadowRadius * CGFloat(probability)
            )
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: 0.7),
                value: probability
            )
    }
    
    // Modifier methods
    public func glowColor(_ color: Color) -> PredictiveListItem {
        var copy = self
        copy.configuration.glowColor = color
        return copy
    }
}

// MARK: - Intent Calculator

public struct IntentCalculator {
    /// Calculate form completion probability based on filled fields
    public static func formCompletionProbability(
        filledFields: Int,
        totalFields: Int,
        isValid: Bool = true
    ) -> Double {
        guard totalFields > 0 else { return 0 }
        let fillRatio = Double(filledFields) / Double(totalFields)
        let validityBonus = isValid ? 0.1 : 0
        return min(fillRatio + validityBonus, 1.0)
    }
    
    /// Calculate hover intent based on duration
    public static func hoverIntentProbability(
        duration: TimeInterval,
        maxDuration: TimeInterval = 2.0
    ) -> Double {
        min(duration / maxDuration, 1.0)
    }
    
    /// Calculate scroll intent based on position
    public static func scrollIntentProbability(
        currentPosition: CGFloat,
        targetPosition: CGFloat,
        viewportHeight: CGFloat
    ) -> Double {
        let distance = abs(currentPosition - targetPosition)
        let normalizedDistance = distance / viewportHeight
        return max(0, 1 - normalizedDistance)
    }
    
    /// Calculate click probability based on mouse movement patterns
    public static func clickIntentProbability(
        approachVelocity: CGFloat,
        distanceToTarget: CGFloat,
        maxDistance: CGFloat = 100
    ) -> Double {
        let distanceFactor = max(0, 1 - distanceToTarget / maxDistance)
        let velocityFactor = min(approachVelocity / 500, 1.0)
        return distanceFactor * (0.7 + velocityFactor * 0.3)
    }
    
    /// Calculate selection probability based on context
    public static func selectionProbability(
        itemIndex: Int,
        totalItems: Int,
        recentSelections: [Int] = [],
        weights: [Int: Double] = [:]
    ) -> Double {
        var probability = 1.0 / Double(totalItems)
        
        // Boost recently selected items
        if recentSelections.contains(itemIndex) {
            probability *= 1.5
        }
        
        // Apply custom weights
        if let weight = weights[itemIndex] {
            probability *= weight
        }
        
        return min(probability, 1.0)
    }
}

// MARK: - Predictive Modifier

public struct PredictiveModifier: ViewModifier {
    let probability: Double
    let configuration: PredictiveLayoutConfiguration
    
    public init(probability: Double, configuration: PredictiveLayoutConfiguration = .default) {
        self.probability = probability
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .opacity(configuration.baseOpacity + (configuration.activeOpacity - configuration.baseOpacity) * probability)
            .scaleEffect(
                configuration.enableScale 
                    ? configuration.baseScale + (configuration.activeScale - configuration.baseScale) * CGFloat(probability)
                    : 1.0
            )
            .shadow(
                color: configuration.enableGlow && probability > configuration.probabilityThreshold
                    ? configuration.glowColor.opacity(configuration.glowOpacity * probability)
                    : .clear,
                radius: configuration.enableElevation
                    ? configuration.baseShadowRadius + (configuration.activeShadowRadius - configuration.baseShadowRadius) * CGFloat(probability)
                    : 0
            )
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                value: probability
            )
    }
}

// MARK: - View Extension

public extension View {
    func predictive(
        probability: Double,
        configuration: PredictiveLayoutConfiguration = .default
    ) -> some View {
        self.modifier(PredictiveModifier(probability: probability, configuration: configuration))
    }
}
