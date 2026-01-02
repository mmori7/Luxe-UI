import SwiftUI

// MARK: - Circular Progress Configuration

public struct CircularProgressConfiguration: Sendable {
    public var size: CGFloat
    public var lineWidth: CGFloat
    public var lineCap: CGLineCap
    public var trackColor: Color
    public var trackOpacity: Double
    public var progressColors: [Color]
    public var useGradient: Bool
    public var showPercentage: Bool
    public var percentageFontSize: CGFloat
    public var percentageFontWeight: Font.Weight
    public var percentageColor: Color
    public var animationDuration: Double
    public var enableGlow: Bool
    public var glowRadius: CGFloat
    public var glowOpacity: Double
    public var rotationOffset: Double
    
    public init(
        size: CGFloat = 100,
        lineWidth: CGFloat = 10,
        lineCap: CGLineCap = .round,
        trackColor: Color = .gray,
        trackOpacity: Double = 0.2,
        progressColors: [Color] = [.blue, .purple],
        useGradient: Bool = true,
        showPercentage: Bool = true,
        percentageFontSize: CGFloat = 24,
        percentageFontWeight: Font.Weight = .bold,
        percentageColor: Color = .white,
        animationDuration: Double = 0.5,
        enableGlow: Bool = true,
        glowRadius: CGFloat = 8,
        glowOpacity: Double = 0.5,
        rotationOffset: Double = -90
    ) {
        self.size = size
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.trackColor = trackColor
        self.trackOpacity = trackOpacity
        self.progressColors = progressColors
        self.useGradient = useGradient
        self.showPercentage = showPercentage
        self.percentageFontSize = percentageFontSize
        self.percentageFontWeight = percentageFontWeight
        self.percentageColor = percentageColor
        self.animationDuration = animationDuration
        self.enableGlow = enableGlow
        self.glowRadius = glowRadius
        self.glowOpacity = glowOpacity
        self.rotationOffset = rotationOffset
    }
    
    // Size presets
    public static let small = CircularProgressConfiguration(
        size: 50,
        lineWidth: 6,
        percentageFontSize: 12
    )
    
    public static let medium = CircularProgressConfiguration(
        size: 80,
        lineWidth: 8,
        percentageFontSize: 18
    )
    
    public static let large = CircularProgressConfiguration(
        size: 120,
        lineWidth: 12,
        percentageFontSize: 28
    )
    
    public static let extraLarge = CircularProgressConfiguration(
        size: 160,
        lineWidth: 14,
        percentageFontSize: 36
    )
    
    // Style presets
    public static let `default` = CircularProgressConfiguration()
    
    public static let flat = CircularProgressConfiguration(
        useGradient: false,
        enableGlow: false
    )
    
    public static let neon = CircularProgressConfiguration(
        progressColors: [.cyan, .blue],
        glowRadius: 15,
        glowOpacity: 0.8
    )
    
    public static let subtle = CircularProgressConfiguration(
        trackOpacity: 0.1,
        enableGlow: false
    )
}

// MARK: - Circular Progress Bar

public struct CircularProgressBar: View {
    private let progress: Double
    private var configuration: CircularProgressConfiguration
    
    // Callbacks
    private var onComplete: (() -> Void)?
    private var onProgressChange: ((Double) -> Void)?
    
    @State private var animatedProgress: Double = 0
    @Environment(\.luxeTheme) private var theme
    
    public init(
        progress: Double,
        configuration: CircularProgressConfiguration = .default
    ) {
        self.progress = max(0, min(1, progress))
        self.configuration = configuration
    }
    
    // Convenience initializer with common parameters
    public init(
        progress: Double,
        showPercentage: Bool = true,
        gradient: Bool = true,
        size: CGFloat = 100,
        lineWidth: CGFloat = 10,
        colors: [Color]? = nil
    ) {
        self.progress = max(0, min(1, progress))
        self.configuration = CircularProgressConfiguration(
            size: size,
            lineWidth: lineWidth,
            progressColors: colors ?? [.blue, .purple],
            useGradient: gradient,
            showPercentage: showPercentage
        )
    }
    
    // Size convenience initializers
    public static func small(
        progress: Double,
        showPercentage: Bool = false,
        colors: [Color]? = nil
    ) -> CircularProgressBar {
        var config = CircularProgressConfiguration.small
        config.showPercentage = showPercentage
        if let colors = colors {
            config.progressColors = colors
        }
        return CircularProgressBar(progress: progress, configuration: config)
    }
    
    public static func medium(
        progress: Double,
        showPercentage: Bool = true,
        colors: [Color]? = nil
    ) -> CircularProgressBar {
        var config = CircularProgressConfiguration.medium
        config.showPercentage = showPercentage
        if let colors = colors {
            config.progressColors = colors
        }
        return CircularProgressBar(progress: progress, configuration: config)
    }
    
    public static func large(
        progress: Double,
        showPercentage: Bool = true,
        colors: [Color]? = nil
    ) -> CircularProgressBar {
        var config = CircularProgressConfiguration.large
        config.showPercentage = showPercentage
        if let colors = colors {
            config.progressColors = colors
        }
        return CircularProgressBar(progress: progress, configuration: config)
    }
    
    public var body: some View {
        ZStack {
            // Track circle
            Circle()
                .stroke(
                    configuration.trackColor.opacity(configuration.trackOpacity),
                    style: StrokeStyle(
                        lineWidth: configuration.lineWidth,
                        lineCap: configuration.lineCap
                    )
                )
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    configuration.useGradient
                        ? AnyShapeStyle(
                            AngularGradient(
                                colors: configuration.progressColors + [configuration.progressColors.first ?? .blue],
                                center: .center,
                                startAngle: .degrees(0),
                                endAngle: .degrees(360)
                            )
                        )
                        : AnyShapeStyle(configuration.progressColors.first ?? .blue),
                    style: StrokeStyle(
                        lineWidth: configuration.lineWidth,
                        lineCap: configuration.lineCap
                    )
                )
                .rotationEffect(.degrees(configuration.rotationOffset))
                .shadow(
                    color: configuration.enableGlow 
                        ? configuration.progressColors.first?.opacity(configuration.glowOpacity) ?? .blue.opacity(configuration.glowOpacity)
                        : .clear,
                    radius: configuration.glowRadius
                )
            
            // Percentage text
            if configuration.showPercentage {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(
                        size: configuration.percentageFontSize,
                        weight: configuration.percentageFontWeight
                    ))
                    .foregroundColor(configuration.percentageColor)
            }
        }
        .frame(width: configuration.size, height: configuration.size)
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            let oldValue = animatedProgress
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedProgress = newValue
            }
            onProgressChange?(newValue)
            
            if newValue >= 1.0 && oldValue < 1.0 {
                onComplete?()
            }
        }
    }
    
    // Modifier methods
    public func onComplete(_ action: @escaping () -> Void) -> CircularProgressBar {
        var copy = self
        copy.onComplete = action
        return copy
    }
    
    public func onProgressChange(_ action: @escaping (Double) -> Void) -> CircularProgressBar {
        var copy = self
        copy.onProgressChange = action
        return copy
    }
    
    public func colors(_ colors: [Color]) -> CircularProgressBar {
        var copy = self
        copy.configuration.progressColors = colors
        return copy
    }
    
    public func trackColor(_ color: Color, opacity: Double = 0.2) -> CircularProgressBar {
        var copy = self
        copy.configuration.trackColor = color
        copy.configuration.trackOpacity = opacity
        return copy
    }
    
    public func lineWidth(_ width: CGFloat) -> CircularProgressBar {
        var copy = self
        copy.configuration.lineWidth = width
        return copy
    }
    
    public func showPercentage(_ show: Bool) -> CircularProgressBar {
        var copy = self
        copy.configuration.showPercentage = show
        return copy
    }
    
    public func glow(_ enabled: Bool, radius: CGFloat = 8, opacity: Double = 0.5) -> CircularProgressBar {
        var copy = self
        copy.configuration.enableGlow = enabled
        copy.configuration.glowRadius = radius
        copy.configuration.glowOpacity = opacity
        return copy
    }
    
    public func gradient(_ enabled: Bool) -> CircularProgressBar {
        var copy = self
        copy.configuration.useGradient = enabled
        return copy
    }
}

// MARK: - Linear Progress Configuration

public struct LinearProgressConfiguration: Sendable {
    public var height: CGFloat
    public var cornerRadius: CGFloat
    public var trackColor: Color
    public var trackOpacity: Double
    public var progressColors: [Color]
    public var useGradient: Bool
    public var animationDuration: Double
    public var enableGlow: Bool
    public var glowRadius: CGFloat
    public var glowOpacity: Double
    
    public init(
        height: CGFloat = 8,
        cornerRadius: CGFloat = 4,
        trackColor: Color = .gray,
        trackOpacity: Double = 0.2,
        progressColors: [Color] = [.blue, .purple],
        useGradient: Bool = true,
        animationDuration: Double = 0.3,
        enableGlow: Bool = true,
        glowRadius: CGFloat = 5,
        glowOpacity: Double = 0.4
    ) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.trackColor = trackColor
        self.trackOpacity = trackOpacity
        self.progressColors = progressColors
        self.useGradient = useGradient
        self.animationDuration = animationDuration
        self.enableGlow = enableGlow
        self.glowRadius = glowRadius
        self.glowOpacity = glowOpacity
    }
    
    public static let `default` = LinearProgressConfiguration()
    
    public static let thin = LinearProgressConfiguration(
        height: 4,
        cornerRadius: 2,
        glowRadius: 3
    )
    
    public static let thick = LinearProgressConfiguration(
        height: 12,
        cornerRadius: 6,
        glowRadius: 8
    )
}

// MARK: - Linear Progress Bar

public struct LinearProgressBar: View {
    private let progress: Double
    private var configuration: LinearProgressConfiguration
    
    @State private var animatedProgress: Double = 0
    
    public init(
        progress: Double,
        configuration: LinearProgressConfiguration = .default
    ) {
        self.progress = max(0, min(1, progress))
        self.configuration = configuration
    }
    
    public init(
        progress: Double,
        height: CGFloat = 8,
        colors: [Color]? = nil,
        gradient: Bool = true
    ) {
        self.progress = max(0, min(1, progress))
        self.configuration = LinearProgressConfiguration(
            height: height,
            progressColors: colors ?? [.blue, .purple],
            useGradient: gradient
        )
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(configuration.trackColor.opacity(configuration.trackOpacity))
                
                // Progress
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(
                        configuration.useGradient
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: configuration.progressColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            : AnyShapeStyle(configuration.progressColors.first ?? .blue)
                    )
                    .frame(width: geometry.size.width * animatedProgress)
                    .shadow(
                        color: configuration.enableGlow
                            ? configuration.progressColors.first?.opacity(configuration.glowOpacity) ?? .blue.opacity(configuration.glowOpacity)
                            : .clear,
                        radius: configuration.glowRadius
                    )
            }
        }
        .frame(height: configuration.height)
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedProgress = newValue
            }
        }
    }
    
    // Modifier methods
    public func colors(_ colors: [Color]) -> LinearProgressBar {
        var copy = self
        copy.configuration.progressColors = colors
        return copy
    }
    
    public func height(_ height: CGFloat) -> LinearProgressBar {
        var copy = self
        copy.configuration.height = height
        copy.configuration.cornerRadius = height / 2
        return copy
    }
    
    public func glow(_ enabled: Bool) -> LinearProgressBar {
        var copy = self
        copy.configuration.enableGlow = enabled
        return copy
    }
}
