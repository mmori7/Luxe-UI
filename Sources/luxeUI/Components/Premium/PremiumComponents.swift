import SwiftUI

/// Premium card with advanced glass effect and hover animations
public struct LuxeCard<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    @State private var isHovered = false
    
    private let content: Content
    private let cornerRadius: CGFloat
    
    public init(
        cornerRadius: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        content
            .padding(theme.spacingL)
            .background(
                ZStack {
                    // Base glass layer
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                    
                    // Shimmer gradient overlay
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.3)
                                ],
                                startPoint: isHovered ? .topLeading : .bottomTrailing,
                                endPoint: isHovered ? .bottomTrailing : .topLeading
                            )
                        )
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isHovered)
                    
                    // Border glow
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    theme.primaryColor.opacity(0.5),
                                    theme.accentColor.opacity(0.3),
                                    theme.primaryColor.opacity(0.5)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                }
            )
            .shadow(color: theme.primaryColor.opacity(0.3), radius: isHovered ? 25 : 15, y: isHovered ? 12 : 8)
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

/// Floating orb with animated glow effect
public struct FloatingOrb: View {
    @Environment(\.luxeTheme) private var theme
    @State private var animate = false
    
    let size: CGFloat
    let color: Color
    
    public init(size: CGFloat = 200, color: Color? = nil) {
        self.size = size
        self.color = color ?? .blue
    }
    
    public var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        color.opacity(0.6),
                        color.opacity(0.3),
                        color.opacity(0.1),
                        .clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .blur(radius: 40)
            .scaleEffect(animate ? 1.2 : 0.8)
            .opacity(animate ? 0.8 : 0.4)
            .animation(
                .easeInOut(duration: 3)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear { animate = true }
    }
}

/// Premium button with glass effect and haptic feedback
public struct LuxeButton: View {
    @Environment(\.luxeTheme) private var theme
    @State private var isPressed = false
    
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    
    public enum ButtonStyle {
        case primary
        case secondary
        case glass
    }
    
    public init(
        _ title: String,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            #endif
        }) {
            Text(title)
                .font(.system(size: theme.fontSizeBody, weight: theme.fontWeightMedium))
                .foregroundColor(.white)
                .padding(.horizontal, theme.spacingL)
                .padding(.vertical, theme.spacingM)
                .background(
                    ZStack {
                        switch style {
                        case .primary:
                            RoundedRectangle(cornerRadius: theme.cornerRadiusMedium)
                                .fill(
                                    LinearGradient(
                                        colors: [theme.primaryColor, theme.accentColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        case .secondary:
                            RoundedRectangle(cornerRadius: theme.cornerRadiusMedium)
                                .fill(theme.secondaryColor)
                        case .glass:
                            RoundedRectangle(cornerRadius: theme.cornerRadiusMedium)
                                .fill(.ultraThinMaterial)
                        }
                        
                        RoundedRectangle(cornerRadius: theme.cornerRadiusMedium)
                            .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                    }
                )
                .shadow(
                    color: theme.primaryColor.opacity(0.5),
                    radius: isPressed ? 8 : 12,
                    y: isPressed ? 2 : 6
                )
                .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(.plain)
        .pressEvents(
            onPress: { isPressed = true },
            onRelease: { isPressed = false }
        )
    }
}

/// Helper for press events
struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: onPress, onRelease: onRelease))
    }
}

/// Animated mesh gradient background
public struct MeshGradientBackground: View {
    @State private var animateGradient = false
    let colors: [Color]
    
    public init(colors: [Color]) {
        self.colors = colors
    }
    
    public var body: some View {
        ZStack {
            ForEach(0..<colors.count, id: \.self) { index in
                FloatingOrb(
                    size: 300 + CGFloat(index * 50),
                    color: colors[index]
                )
                .offset(
                    x: animateGradient ? CGFloat.random(in: -100...100) : 0,
                    y: animateGradient ? CGFloat.random(in: -100...100) : 0
                )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
    }
}

/// Badge with glow effect
public struct LuxeBadge: View {
    @Environment(\.luxeTheme) private var theme
    
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color? = nil) {
        self.text = text
        self.color = color ?? .blue
    }
    
    public var body: some View {
        Text(text)
            .font(.system(size: theme.fontSizeCaption, weight: theme.fontWeightBold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(color)
                    .shadow(color: color.opacity(0.6), radius: 8, y: 4)
            )
    }
}
