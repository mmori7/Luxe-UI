import SwiftUI

// MARK: - Refractive Glass Effect

/// A premium refractive glass effect that physically warps the background
/// like looking through a liquid glass lens - the signature effect of 2026 UI design
public struct RefractiveGlassModifier: ViewModifier {
    @Environment(\.luxeTheme) private var theme
    
    let intensity: CGFloat
    let blurRadius: CGFloat
    let borderWidth: CGFloat
    
    @State private var animationPhase: CGFloat = 0
    
    public init(
        intensity: CGFloat = 0.15,
        blurRadius: CGFloat = 20,
        borderWidth: CGFloat = 1
    ) {
        self.intensity = intensity
        self.blurRadius = blurRadius
        self.borderWidth = borderWidth
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Multi-layer refractive effect
                    RefractiveLayer(phase: animationPhase, intensity: intensity * 1.0)
                        .blur(radius: blurRadius * 0.8)
                    
                    RefractiveLayer(phase: animationPhase + 0.3, intensity: intensity * 0.7)
                        .blur(radius: blurRadius * 0.5)
                    
                    RefractiveLayer(phase: animationPhase + 0.6, intensity: intensity * 0.4)
                        .blur(radius: blurRadius * 0.3)
                }
                .background(.ultraThinMaterial)
            )
            .overlay(
                // Refractive border with iridescent effect
                RoundedRectangle(cornerRadius: theme.cornerRadiusLarge)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                theme.primaryColor.opacity(0.3),
                                theme.secondaryColor.opacity(0.2),
                                theme.accentColor.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusLarge))
            .shadow(color: theme.primaryColor.opacity(0.2), radius: 20, x: 0, y: 10)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .onAppear {
                withAnimation(
                    .linear(duration: 8)
                    .repeatForever(autoreverses: false)
                ) {
                    animationPhase = 1.0
                }
            }
    }
}

// MARK: - Refractive Layer with Lens Distortion

private struct RefractiveLayer: View {
    let phase: CGFloat
    let intensity: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [
                        .white.opacity(0.15),
                        .white.opacity(0.08),
                        .white.opacity(0.03),
                        .clear
                    ],
                    center: .center,
                    startRadius: 20,
                    endRadius: 200
                )
            )
            .modifier(LensDistortionEffect(phase: phase, intensity: intensity))
    }
}

// MARK: - Lens Distortion Geometry Effect

/// Creates a lens-like warping effect that simulates light refraction
private struct LensDistortionEffect: GeometryEffect {
    var phase: CGFloat
    var intensity: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(phase, intensity) }
        set {
            phase = newValue.first
            intensity = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        // Create subtle warping at edges - lens effect
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        // Lens distortion matrix
        let scale = 1.0 + (intensity * 0.05 * sin(phase * .pi * 2))
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1000.0 // Perspective
        
        // Apply subtle rotation for liquid effect
        transform = CATransform3DRotate(transform, intensity * 0.02 * sin(phase * .pi), 1, 0, 0)
        transform = CATransform3DRotate(transform, intensity * 0.02 * cos(phase * .pi), 0, 1, 0)
        
        // Scale from center
        transform = CATransform3DTranslate(transform, -centerX, -centerY, 0)
        transform = CATransform3DScale(transform, scale, scale, 1.0)
        transform = CATransform3DTranslate(transform, centerX, centerY, 0)
        
        return ProjectionTransform(transform)
    }
}

// MARK: - Advanced Refractive Glass with Edge Distortion

/// Premium refractive glass with physically-based edge warping
public struct AdvancedRefractiveGlass<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    
    let content: Content
    let distortionIntensity: CGFloat
    let chromaticAberration: Bool
    
    @State private var phase: CGFloat = 0
    
    public init(
        distortionIntensity: CGFloat = 0.2,
        chromaticAberration: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.distortionIntensity = distortionIntensity
        self.chromaticAberration = chromaticAberration
    }
    
    public var body: some View {
        ZStack {
            // Background with animated mesh distortion
            if chromaticAberration {
                // RGB channel separation for prismatic effect
                Group {
                    content
                        .colorMultiply(.red.opacity(0.3))
                        .offset(x: sin(phase * .pi) * distortionIntensity * 2, y: 0)
                    
                    content
                        .colorMultiply(.green.opacity(0.3))
                    
                    content
                        .colorMultiply(.blue.opacity(0.3))
                        .offset(x: -sin(phase * .pi) * distortionIntensity * 2, y: 0)
                }
                .blendMode(.screen)
                .blur(radius: 15)
            }
            
            // Main content with refractive layers
            content
                .background(.ultraThinMaterial)
                .overlay(
                    // Animated refractive caustics
                    Canvas { context, size in
                        let columns = 8
                        let rows = 8
                        let cellWidth = size.width / CGFloat(columns)
                        let cellHeight = size.height / CGFloat(rows)
                        
                        for row in 0..<rows {
                            for col in 0..<columns {
                                let x = CGFloat(col) * cellWidth + cellWidth / 2
                                let y = CGFloat(row) * cellHeight + cellHeight / 2
                                
                                // Distance from center
                                let dx = x - size.width / 2
                                let dy = y - size.height / 2
                                let distance = sqrt(dx * dx + dy * dy)
                                let maxDistance = sqrt(size.width * size.width + size.height * size.height) / 2
                                
                                // Caustic effect - stronger at edges
                                let edgeFactor = distance / maxDistance
                                let wave = sin(phase * .pi * 2 + distance * 0.05) * distortionIntensity
                                let opacity = edgeFactor * 0.1 * (1 + wave)
                                
                                let center = CGPoint(x: x, y: y)
                                let radius = cellWidth * (0.3 + wave * 0.2)
                                
                                context.fill(
                                    Path(ellipseIn: CGRect(
                                        x: center.x - radius,
                                        y: center.y - radius,
                                        width: radius * 2,
                                        height: radius * 2
                                    )),
                                    with: .color(.white.opacity(opacity))
                                )
                            }
                        }
                    }
                    .blur(radius: 8)
                    .blendMode(.overlay)
                )
                .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusLarge))
                .overlay(
                    // Prismatic edge highlight
                    RoundedRectangle(cornerRadius: theme.cornerRadiusLarge)
                        .strokeBorder(
                            AngularGradient(
                                colors: [
                                    theme.primaryColor,
                                    theme.secondaryColor,
                                    theme.accentColor,
                                    theme.primaryColor
                                ],
                                center: .center,
                                angle: .degrees(phase * 360)
                            ),
                            lineWidth: 1.5
                        )
                        .opacity(0.4)
                )
                .shadow(color: theme.primaryColor.opacity(0.3), radius: 20, x: 0, y: 10)
                .shadow(color: theme.secondaryColor.opacity(0.2), radius: 30, x: 0, y: 15)
        }
        .onAppear {
            withAnimation(
                .linear(duration: 6)
                .repeatForever(autoreverses: false)
            ) {
                phase = 1.0
            }
        }
    }
}

// MARK: - View Extension

extension View {
    /// Apply a refractive liquid glass effect with lens-like distortion
    ///
    /// This premium effect simulates real glass refraction with:
    /// - Physical lens warping at edges
    /// - Multi-layer depth
    /// - Animated liquid glass shimmer
    /// - Theme-aware coloring
    ///
    /// Example:
    /// ```swift
    /// VStack {
    ///     Text("Premium Content")
    /// }
    /// .padding()
    /// .refractiveGlass(intensity: 0.2)
    /// ```
    public func refractiveGlass(
        intensity: CGFloat = 0.15,
        blurRadius: CGFloat = 20,
        borderWidth: CGFloat = 1
    ) -> some View {
        modifier(RefractiveGlassModifier(
            intensity: intensity,
            blurRadius: blurRadius,
            borderWidth: borderWidth
        ))
    }
}

// MARK: - Refractive Glass Card Component

/// A drop-in replacement for LuxeCard with advanced refractive glass effects
public struct RefractiveGlassCard<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    
    let content: Content
    let distortionIntensity: CGFloat
    let enableChromatic: Bool
    
    @State private var isHovered = false
    
    public init(
        distortionIntensity: CGFloat = 0.2,
        chromaticAberration: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.distortionIntensity = distortionIntensity
        self.enableChromatic = chromaticAberration
    }
    
    public var body: some View {
        AdvancedRefractiveGlass(
            distortionIntensity: distortionIntensity,
            chromaticAberration: enableChromatic
        ) {
            content
                .padding(theme.spacingL)
        }
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
