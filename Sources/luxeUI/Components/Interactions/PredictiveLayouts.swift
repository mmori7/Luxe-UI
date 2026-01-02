import SwiftUI

// MARK: - Predictive State-Aware Layout System

/// A container that adapts its appearance based on probability of user action
/// The future of 2026 UI - layouts that predict and respond to user intent
public struct LuxeAdaptiveContainer<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    
    let content: Content
    let probabilityOfAction: Double
    let adaptiveMode: AdaptiveMode
    
    @State private var currentScale: CGFloat = 1.0
    @State private var currentGlow: CGFloat = 0.0
    @State private var currentElevation: CGFloat = 0.0
    @State private var priority: CGFloat = 0.0
    
    public enum AdaptiveMode {
        case glow          // Increases glow intensity
        case scale         // Grows in size
        case elevate       // Lifts with shadow
        case prioritize    // Moves toward top (use with sortPriority)
        case all           // Combines all effects
    }
    
    public init(
        probabilityOfAction: Double,
        mode: AdaptiveMode = .all,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.probabilityOfAction = max(0.0, min(1.0, probabilityOfAction))
        self.adaptiveMode = mode
    }
    
    public var body: some View {
        content
            .scaleEffect(shouldScale ? currentScale : 1.0)
            .shadow(
                color: theme.primaryColor.opacity(shouldGlow ? currentGlow * 0.6 : 0),
                radius: currentGlow * 30,
                x: 0,
                y: 0
            )
            .shadow(
                color: .black.opacity(shouldElevate ? 0.3 : 0),
                radius: currentElevation * 20,
                x: 0,
                y: currentElevation * 10
            )
            .zIndex(shouldPrioritize ? priority : 0)
            .onChange(of: probabilityOfAction) { newValue in
                updateAdaptiveState(probability: newValue)
            }
            .onAppear {
                updateAdaptiveState(probability: probabilityOfAction)
            }
    }
    
    private var shouldScale: Bool {
        adaptiveMode == .scale || adaptiveMode == .all
    }
    
    private var shouldGlow: Bool {
        adaptiveMode == .glow || adaptiveMode == .all
    }
    
    private var shouldElevate: Bool {
        adaptiveMode == .elevate || adaptiveMode == .all
    }
    
    private var shouldPrioritize: Bool {
        adaptiveMode == .prioritize || adaptiveMode == .all
    }
    
    private func updateAdaptiveState(probability: Double) {
        let intensity = CGFloat(probability)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            if shouldScale {
                currentScale = 1.0 + (intensity * 0.1) // Grow up to 10%
            }
            
            if shouldGlow {
                currentGlow = intensity
            }
            
            if shouldElevate {
                currentElevation = intensity
            }
            
            if shouldPrioritize {
                priority = intensity * 100 // Higher z-index
            }
        }
    }
}

// MARK: - Smart Form Button

/// A button that adapts based on form completion probability
public struct SmartFormButton: View {
    @Environment(\.luxeTheme) private var theme
    
    let title: String
    let completionProbability: Double
    let action: () -> Void
    
    @State private var pulsePhase: CGFloat = 0
    
    public init(
        _ title: String,
        completionProbability: Double,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.completionProbability = max(0.0, min(1.0, completionProbability))
        self.action = action
    }
    
    public var body: some View {
        LuxeAdaptiveContainer(
            probabilityOfAction: completionProbability,
            mode: .all
        ) {
            Button(action: {
                TactileFeedback.trigger(.success)
                action()
            }) {
                HStack(spacing: 12) {
                    Text(title)
                        .font(.headline)
                    
                    if completionProbability > 0.8 {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, theme.spacingL)
                .padding(.vertical, theme.spacingM)
                .background(
                    ZStack {
                        // Base gradient
                        LinearGradient(
                            colors: [
                                theme.primaryColor,
                                theme.secondaryColor
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        // Readiness pulse
                        if completionProbability > 0.7 {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            .white.opacity(0.4 * completionProbability),
                                            .clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                                .scaleEffect(pulsePhase)
                                .opacity(1.0 - pulsePhase)
                                .blendMode(.overlay)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusMedium))
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cornerRadiusMedium)
                        .strokeBorder(
                            .white.opacity(0.3 * completionProbability),
                            lineWidth: 2
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(completionProbability < 0.3)
            .opacity(completionProbability < 0.3 ? 0.5 : 1.0)
        }
        .onAppear {
            if completionProbability > 0.7 {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    pulsePhase = 1.0
                }
            }
        }
    }
}

// MARK: - Predictive List Item

/// List item that adapts based on likelihood of selection
public struct PredictiveListItem<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    
    let selectionProbability: Double
    let content: Content
    let onTap: () -> Void
    
    public init(
        selectionProbability: Double,
        onTap: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.selectionProbability = max(0.0, min(1.0, selectionProbability))
        self.onTap = onTap
        self.content = content()
    }
    
    public var body: some View {
        LuxeAdaptiveContainer(
            probabilityOfAction: selectionProbability,
            mode: .all
        ) {
            Button(action: {
                TactileFeedback.trigger(.light)
                onTap()
            }) {
                HStack {
                    content
                    Spacer()
                    
                    if selectionProbability > 0.6 {
                        Image(systemName: "chevron.right")
                            .foregroundColor(theme.primaryColor)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(theme.spacingM)
                .background(
                    RoundedRectangle(cornerRadius: theme.cornerRadiusSmall)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: theme.cornerRadiusSmall)
                                .strokeBorder(
                                    theme.primaryColor.opacity(0.3 * selectionProbability),
                                    lineWidth: 1 + selectionProbability
                                )
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Intent Probability Calculator

/// Helper to calculate user intent probability from form/context state
public struct IntentCalculator {
    /// Calculate form completion probability
    public static func formCompletionProbability(
        filledFields: Int,
        totalFields: Int,
        isValid: Bool = true
    ) -> Double {
        guard totalFields > 0 else { return 0.0 }
        
        let completionRatio = Double(filledFields) / Double(totalFields)
        let validityMultiplier = isValid ? 1.0 : 0.5
        
        return completionRatio * validityMultiplier
    }
    
    /// Calculate selection probability based on hover time and frequency
    public static func selectionProbability(
        hoverDuration: TimeInterval,
        hoverCount: Int,
        maxHoverTime: TimeInterval = 2.0
    ) -> Double {
        let durationScore = min(hoverDuration / maxHoverTime, 1.0)
        let frequencyScore = min(Double(hoverCount) / 3.0, 1.0)
        
        return (durationScore * 0.7 + frequencyScore * 0.3)
    }
    
    /// Calculate scroll-to-view probability
    public static func viewProbability(
        scrollVelocity: CGFloat,
        distanceToElement: CGFloat,
        screenHeight: CGFloat
    ) -> Double {
        guard scrollVelocity > 0 else { return 0.0 }
        
        let velocityFactor = min(scrollVelocity / 1000.0, 1.0)
        let distanceFactor = max(0.0, 1.0 - (distanceToElement / screenHeight))
        
        return velocityFactor * distanceFactor
    }
}

// MARK: - View Extensions

extension View {
    /// Make container adapt to user intent probability
    ///
    /// Layout reshapes based on likelihood of user action
    ///
    /// Example:
    /// ```swift
    /// LuxeCard { }
    ///     .adaptive(probability: formCompletion, mode: .all)
    /// ```
    public func adaptive(
        probability: Double,
        mode: LuxeAdaptiveContainer<Self>.AdaptiveMode = .all
    ) -> some View {
        LuxeAdaptiveContainer(
            probabilityOfAction: probability,
            mode: mode
        ) {
            self
        }
    }
}
