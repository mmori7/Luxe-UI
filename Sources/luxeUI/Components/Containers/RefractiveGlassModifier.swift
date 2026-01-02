import SwiftUI

// MARK: - Refractive Glass Configuration

public struct RefractiveGlassConfiguration: Sendable {
    public var distortionIntensity: Double
    public var distortionRadius: CGFloat
    public var chromaticAberration: Bool
    public var aberrationStrength: CGFloat
    public var causticAnimation: Bool
    public var causticSpeed: Double
    public var causticCount: Int
    public var layerCount: Int
    public var blurRadius: CGFloat
    public var cornerRadius: CGFloat
    public var backgroundOpacity: Double
    public var borderWidth: CGFloat
    public var borderOpacity: Double
    public var shadowRadius: CGFloat
    public var shadowOpacity: Double
    public var enableHaptics: Bool
    public var animationResponse: Double
    public var animationDamping: Double
    
    public init(
        distortionIntensity: Double = 0.2,
        distortionRadius: CGFloat = 50,
        chromaticAberration: Bool = true,
        aberrationStrength: CGFloat = 2.0,
        causticAnimation: Bool = true,
        causticSpeed: Double = 0.5,
        causticCount: Int = 8,
        layerCount: Int = 3,
        blurRadius: CGFloat = 20,
        cornerRadius: CGFloat = 24,
        backgroundOpacity: Double = 0.15,
        borderWidth: CGFloat = 1.5,
        borderOpacity: Double = 0.4,
        shadowRadius: CGFloat = 30,
        shadowOpacity: Double = 0.5,
        enableHaptics: Bool = true,
        animationResponse: Double = 0.3,
        animationDamping: Double = 0.7
    ) {
        self.distortionIntensity = distortionIntensity
        self.distortionRadius = distortionRadius
        self.chromaticAberration = chromaticAberration
        self.aberrationStrength = aberrationStrength
        self.causticAnimation = causticAnimation
        self.causticSpeed = causticSpeed
        self.causticCount = causticCount
        self.layerCount = layerCount
        self.blurRadius = blurRadius
        self.cornerRadius = cornerRadius
        self.backgroundOpacity = backgroundOpacity
        self.borderWidth = borderWidth
        self.borderOpacity = borderOpacity
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.enableHaptics = enableHaptics
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
    }
    
    // Presets
    public static let `default` = RefractiveGlassConfiguration()
    
    public static let subtle = RefractiveGlassConfiguration(
        distortionIntensity: 0.1,
        aberrationStrength: 1.0,
        causticCount: 4,
        layerCount: 2,
        blurRadius: 15
    )
    
    public static let intense = RefractiveGlassConfiguration(
        distortionIntensity: 0.35,
        aberrationStrength: 3.0,
        causticCount: 12,
        layerCount: 5,
        blurRadius: 25
    )
    
    public static let minimal = RefractiveGlassConfiguration(
        distortionIntensity: 0.05,
        chromaticAberration: false,
        causticAnimation: false,
        layerCount: 1,
        blurRadius: 10
    )
    
    public static let liquid = RefractiveGlassConfiguration(
        distortionIntensity: 0.25,
        distortionRadius: 70,
        aberrationStrength: 2.5,
        causticSpeed: 0.3,
        causticCount: 10,
        layerCount: 4
    )
    
    public static let frosted = RefractiveGlassConfiguration(
        distortionIntensity: 0.08,
        chromaticAberration: false,
        causticAnimation: false,
        blurRadius: 30,
        backgroundOpacity: 0.25
    )
}

// MARK: - Refractive Glass Modifier

public struct RefractiveGlassModifier: ViewModifier {
    private let configuration: RefractiveGlassConfiguration
    
    @State private var phase: Double = 0
    @Environment(\.luxeTheme) private var theme
    
    public init(configuration: RefractiveGlassConfiguration = .default) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Multi-layer refractive depth
                    ForEach(0..<configuration.layerCount, id: \.self) { layer in
                        RefractiveLayer(
                            layer: layer,
                            totalLayers: configuration.layerCount,
                            configuration: configuration,
                            phase: phase
                        )
                    }
                    
                    // Optional caustic light patterns
                    if configuration.causticAnimation {
                        CausticLightCanvas(
                            phase: phase,
                            causticCount: configuration.causticCount
                        )
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
            )
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(configuration.borderOpacity),
                                .white.opacity(configuration.borderOpacity * 0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: configuration.borderWidth
                    )
            )
            .shadow(
                color: theme.primaryColor.opacity(configuration.shadowOpacity),
                radius: configuration.shadowRadius,
                y: 15
            )
            .onAppear {
                if configuration.causticAnimation {
                    withAnimation(
                        .linear(duration: 10 / configuration.causticSpeed)
                        .repeatForever(autoreverses: false)
                    ) {
                        phase = 2 * .pi
                    }
                }
            }
    }
}

// MARK: - Refractive Layer

private struct RefractiveLayer: View {
    let layer: Int
    let totalLayers: Int
    let configuration: RefractiveGlassConfiguration
    let phase: Double
    
    private var layerOffset: Double {
        Double(layer) / Double(totalLayers)
    }
    
    var body: some View {
        ZStack {
            // Base glass material
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(.ultraThinMaterial)
                .opacity(0.3 + layerOffset * 0.2)
            
            // Chromatic aberration layers
            if configuration.chromaticAberration {
                // Red channel
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(
                        RadialGradient(
                            colors: [.red.opacity(0.1), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: configuration.distortionRadius + CGFloat(layer * 20)
                        )
                    )
                    .offset(
                        x: -configuration.aberrationStrength * (1 + layerOffset),
                        y: -configuration.aberrationStrength * (1 + layerOffset)
                    )
                    .blendMode(.screen)
                
                // Blue channel
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(
                        RadialGradient(
                            colors: [.blue.opacity(0.1), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: configuration.distortionRadius + CGFloat(layer * 20)
                        )
                    )
                    .offset(
                        x: configuration.aberrationStrength * (1 + layerOffset),
                        y: configuration.aberrationStrength * (1 + layerOffset)
                    )
                    .blendMode(.screen)
            }
            
            // Glass highlight
            LinearGradient(
                colors: [
                    .white.opacity(0.2 - layerOffset * 0.1),
                    .clear,
                    .white.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .blur(radius: configuration.blurRadius / CGFloat(totalLayers - layer + 1))
    }
}

// MARK: - Caustic Light Canvas

private struct CausticLightCanvas: View {
    let phase: Double
    let causticCount: Int
    
    var body: some View {
        Canvas { context, size in
            for i in 0..<causticCount {
                let progress = Double(i) / Double(causticCount)
                let x = size.width * (0.2 + 0.6 * sin(phase + progress * .pi * 2))
                let y = size.height * (0.2 + 0.6 * cos(phase * 1.3 + progress * .pi * 2))
                
                let causticSize = 30 + 20 * sin(phase * 2 + progress * .pi)
                
                let gradient = Gradient(colors: [
                    .white.opacity(0.3),
                    .white.opacity(0.1),
                    .clear
                ])
                
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: x - causticSize / 2,
                        y: y - causticSize / 2,
                        width: causticSize,
                        height: causticSize * 0.6
                    )),
                    with: .radialGradient(
                        gradient,
                        center: CGPoint(x: x, y: y),
                        startRadius: 0,
                        endRadius: causticSize / 2
                    )
                )
            }
        }
        .blendMode(.overlay)
    }
}

// MARK: - Lens Distortion Effect

public struct LensDistortionEffect: GeometryEffect {
    public var intensity: Double
    public var radius: CGFloat
    
    public var animatableData: Double {
        get { intensity }
        set { intensity = newValue }
    }
    
    public init(intensity: Double = 0.2, radius: CGFloat = 50) {
        self.intensity = intensity
        self.radius = radius
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        let perspective: CGFloat = 1 / (1 + CGFloat(intensity) * 0.5)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1 / (size.width * 2)
        transform = CATransform3DRotate(transform, CGFloat(intensity) * 0.1, 1, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(intensity) * 0.1, 0, 1, 0)
        transform = CATransform3DScale(transform, perspective, perspective, 1)
        
        let affine = CGAffineTransform(
            a: transform.m11,
            b: transform.m12,
            c: transform.m21,
            d: transform.m22,
            tx: transform.m41,
            ty: transform.m42
        )
        
        return ProjectionTransform(affine)
    }
}

// MARK: - Advanced Refractive Glass

public struct AdvancedRefractiveGlass<Content: View>: View {
    private let content: Content
    private let configuration: RefractiveGlassConfiguration
    
    @State private var phase: Double = 0
    @Environment(\.luxeTheme) private var theme
    
    public init(
        configuration: RefractiveGlassConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    public var body: some View {
        content
            .modifier(LensDistortionEffect(
                intensity: configuration.distortionIntensity,
                radius: configuration.distortionRadius
            ))
            .modifier(RefractiveGlassModifier(configuration: configuration))
    }
}

// MARK: - Refractive Glass Card

public struct RefractiveGlassCard<Content: View>: View {
    private let content: Content
    private var configuration: RefractiveGlassConfiguration
    
    // Callbacks
    private var onHoverStart: (() -> Void)?
    private var onHoverEnd: (() -> Void)?
    private var onTapAction: (() -> Void)?
    
    @State private var isHovered = false
    @State private var isPressed = false
    @State private var phase: Double = 0
    @Environment(\.luxeTheme) private var theme
    
    public init(
        configuration: RefractiveGlassConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    // Convenience initializer with common parameters
    public init(
        distortionIntensity: Double = 0.2,
        chromaticAberration: Bool = true,
        cornerRadius: CGFloat = 24,
        causticAnimation: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = RefractiveGlassConfiguration(
            distortionIntensity: distortionIntensity,
            chromaticAberration: chromaticAberration,
            causticAnimation: causticAnimation,
            cornerRadius: cornerRadius
        )
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            // Multi-layer refractive background
            ZStack {
                ForEach(0..<configuration.layerCount, id: \.self) { layer in
                    RefractiveLayer(
                        layer: layer,
                        totalLayers: configuration.layerCount,
                        configuration: configuration,
                        phase: phase
                    )
                }
                
                if configuration.causticAnimation {
                    CausticLightCanvas(
                        phase: phase,
                        causticCount: configuration.causticCount
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
            
            // Content
            content
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(.white.opacity(configuration.backgroundOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(configuration.borderOpacity),
                            .white.opacity(configuration.borderOpacity * 0.25)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: configuration.borderWidth
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
        .shadow(
            color: theme.primaryColor.opacity(configuration.shadowOpacity),
            radius: configuration.shadowRadius,
            y: 15
        )
        .modifier(LensDistortionEffect(
            intensity: isHovered ? configuration.distortionIntensity * 1.5 : configuration.distortionIntensity,
            radius: configuration.distortionRadius
        ))
        .scaleEffect(isPressed ? 0.98 : (isHovered ? 1.02 : 1.0))
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
        .onAppear {
            if configuration.causticAnimation {
                withAnimation(
                    .linear(duration: 10 / configuration.causticSpeed)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 2 * .pi
                }
            }
        }
    }
    
    // Modifier methods
    public func onHoverStart(_ action: @escaping () -> Void) -> RefractiveGlassCard {
        var copy = self
        copy.onHoverStart = action
        return copy
    }
    
    public func onHoverEnd(_ action: @escaping () -> Void) -> RefractiveGlassCard {
        var copy = self
        copy.onHoverEnd = action
        return copy
    }
    
    public func onTap(_ action: @escaping () -> Void) -> RefractiveGlassCard {
        var copy = self
        copy.onTapAction = action
        return copy
    }
    
    public func distortionIntensity(_ intensity: Double) -> RefractiveGlassCard {
        var copy = self
        copy.configuration.distortionIntensity = intensity
        return copy
    }
    
    public func chromaticAberration(_ enabled: Bool, strength: CGFloat = 2.0) -> RefractiveGlassCard {
        var copy = self
        copy.configuration.chromaticAberration = enabled
        copy.configuration.aberrationStrength = strength
        return copy
    }
    
    public func caustics(_ enabled: Bool, speed: Double = 0.5, count: Int = 8) -> RefractiveGlassCard {
        var copy = self
        copy.configuration.causticAnimation = enabled
        copy.configuration.causticSpeed = speed
        copy.configuration.causticCount = count
        return copy
    }
    
    public func cornerRadius(_ radius: CGFloat) -> RefractiveGlassCard {
        var copy = self
        copy.configuration.cornerRadius = radius
        return copy
    }
}

// MARK: - View Extension

public extension View {
    func refractiveGlass(configuration: RefractiveGlassConfiguration = .default) -> some View {
        self.modifier(RefractiveGlassModifier(configuration: configuration))
    }
    
    func refractiveGlass(
        intensity: Double = 0.2,
        radius: CGFloat = 50,
        chromaticAberration: Bool = true,
        aberrationStrength: CGFloat = 2.0,
        causticAnimation: Bool = true,
        causticSpeed: Double = 0.5,
        causticCount: Int = 8,
        layers: Int = 3,
        blur: CGFloat = 20,
        cornerRadius: CGFloat = 24
    ) -> some View {
        let config = RefractiveGlassConfiguration(
            distortionIntensity: intensity,
            distortionRadius: radius,
            chromaticAberration: chromaticAberration,
            aberrationStrength: aberrationStrength,
            causticAnimation: causticAnimation,
            causticSpeed: causticSpeed,
            causticCount: causticCount,
            layerCount: layers,
            blurRadius: blur,
            cornerRadius: cornerRadius
        )
        return self.modifier(RefractiveGlassModifier(configuration: config))
    }
}
