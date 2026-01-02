import SwiftUI

/// An animated circular progress indicator that displays progress as a ring.
///
/// This component features smooth animations, customizable colors, and optional percentage display.
/// It automatically adapts to the current theme.
///
/// Example usage:
/// ```swift
/// CircularProgressBar(progress: 0.75)
/// ```
///
/// With customization:
/// ```swift
/// CircularProgressBar(
///     progress: 0.65,
///     lineWidth: 15,
///     showPercentage: true,
///     gradient: true
/// )
/// ```
public struct CircularProgressBar: View {
    @Environment(\.luxeTheme) private var theme
    
    private let progress: Double
    private let lineWidth: CGFloat
    private let showPercentage: Bool
    private let trackColor: Color?
    private let progressColor: Color?
    private let gradient: Bool
    private let animated: Bool
    private let size: CGFloat
    
    @State private var animatedProgress: Double = 0
    
    /// Creates a circular progress bar with default settings
    /// - Parameter progress: Progress value from 0.0 to 1.0
    public init(progress: Double) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = 12
        self.showPercentage = false
        self.trackColor = nil
        self.progressColor = nil
        self.gradient = false
        self.animated = true
        self.size = 120
    }
    
    /// Creates a circular progress bar with custom settings
    /// - Parameters:
    ///   - progress: Progress value from 0.0 to 1.0
    ///   - lineWidth: Width of the progress ring (default: 12)
    ///   - showPercentage: Whether to show percentage text (default: false)
    ///   - trackColor: Color of the background track (default: uses theme secondary background)
    ///   - progressColor: Color of the progress ring (default: uses theme primary color)
    ///   - gradient: Whether to use gradient colors (default: false)
    ///   - animated: Whether to animate progress changes (default: true)
    ///   - size: Size of the progress circle (default: 120)
    public init(
        progress: Double,
        lineWidth: CGFloat = 12,
        showPercentage: Bool = false,
        trackColor: Color? = nil,
        progressColor: Color? = nil,
        gradient: Bool = false,
        animated: Bool = true,
        size: CGFloat = 120
    ) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.showPercentage = showPercentage
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.gradient = gradient
        self.animated = animated
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(
                    trackColor ?? theme.secondaryBackgroundColor,
                    lineWidth: lineWidth
                )
            
            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    gradient ? AnyShapeStyle(gradientStyle) : AnyShapeStyle(solidStyle),
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            
            // Percentage text
            if showPercentage {
                VStack(spacing: theme.spacingXS) {
                    Text("\(Int(animatedProgress * 100))%")
                        .font(.system(size: size / 3.5, weight: theme.fontWeightBold))
                        .foregroundColor(theme.textPrimary)
                    
                    if size > 100 {
                        Text("Complete")
                            .font(.system(size: size / 10, weight: theme.fontWeightRegular))
                            .foregroundColor(theme.textSecondary)
                    }
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if animated {
                withAnimation(.spring(response: theme.animationSpring, dampingFraction: 0.7)) {
                    animatedProgress = progress
                }
            } else {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            if animated {
                withAnimation(.spring(response: theme.animationSpring, dampingFraction: 0.7)) {
                    animatedProgress = newValue
                }
            } else {
                animatedProgress = newValue
            }
        }
    }
    
    private var solidStyle: some ShapeStyle {
        progressColor ?? theme.primaryColor
    }
    
    private var gradientStyle: some ShapeStyle {
        LinearGradient(
            colors: [
                progressColor ?? theme.primaryColor,
                theme.accentColor
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Progress Ring Style Variants

extension CircularProgressBar {
    /// Creates a small circular progress bar (60pt)
    public static func small(progress: Double, showPercentage: Bool = false) -> CircularProgressBar {
        CircularProgressBar(
            progress: progress,
            lineWidth: 6,
            showPercentage: showPercentage,
            size: 60
        )
    }
    
    /// Creates a medium circular progress bar (120pt, default)
    public static func medium(progress: Double, showPercentage: Bool = true) -> CircularProgressBar {
        CircularProgressBar(
            progress: progress,
            lineWidth: 12,
            showPercentage: showPercentage,
            size: 120
        )
    }
    
    /// Creates a large circular progress bar (200pt)
    public static func large(progress: Double, showPercentage: Bool = true) -> CircularProgressBar {
        CircularProgressBar(
            progress: progress,
            lineWidth: 20,
            showPercentage: showPercentage,
            size: 200
        )
    }
}
