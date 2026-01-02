import SwiftUI

// MARK: - Color Scheme

public struct LuxeColorScheme: Sendable {
    public var primary: Color
    public var secondary: Color
    public var accent: Color
    public var background: Color
    public var surface: Color
    public var text: Color
    public var textSecondary: Color
    public var success: Color
    public var warning: Color
    public var error: Color
    public var info: Color
    
    public init(
        primary: Color = .blue,
        secondary: Color = .purple,
        accent: Color = .cyan,
        background: Color = Color(red: 0.05, green: 0.05, blue: 0.1),
        surface: Color = Color(red: 0.1, green: 0.1, blue: 0.15),
        text: Color = .white,
        textSecondary: Color = .white.opacity(0.7),
        success: Color = .green,
        warning: Color = .orange,
        error: Color = .red,
        info: Color = .cyan
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.text = text
        self.textSecondary = textSecondary
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
    }
}

// MARK: - Typography

public struct LuxeTypography: Sendable {
    public var fontSizeXS: CGFloat
    public var fontSizeS: CGFloat
    public var fontSizeM: CGFloat
    public var fontSizeL: CGFloat
    public var fontSizeXL: CGFloat
    public var fontSizeXXL: CGFloat
    public var fontSizeDisplay: CGFloat
    public var fontWeightLight: Font.Weight
    public var fontWeightRegular: Font.Weight
    public var fontWeightMedium: Font.Weight
    public var fontWeightSemibold: Font.Weight
    public var fontWeightBold: Font.Weight
    public var lineHeightTight: CGFloat
    public var lineHeightNormal: CGFloat
    public var lineHeightRelaxed: CGFloat
    
    public init(
        fontSizeXS: CGFloat = 10,
        fontSizeS: CGFloat = 12,
        fontSizeM: CGFloat = 14,
        fontSizeL: CGFloat = 16,
        fontSizeXL: CGFloat = 20,
        fontSizeXXL: CGFloat = 24,
        fontSizeDisplay: CGFloat = 36,
        fontWeightLight: Font.Weight = .light,
        fontWeightRegular: Font.Weight = .regular,
        fontWeightMedium: Font.Weight = .medium,
        fontWeightSemibold: Font.Weight = .semibold,
        fontWeightBold: Font.Weight = .bold,
        lineHeightTight: CGFloat = 1.2,
        lineHeightNormal: CGFloat = 1.5,
        lineHeightRelaxed: CGFloat = 1.8
    ) {
        self.fontSizeXS = fontSizeXS
        self.fontSizeS = fontSizeS
        self.fontSizeM = fontSizeM
        self.fontSizeL = fontSizeL
        self.fontSizeXL = fontSizeXL
        self.fontSizeXXL = fontSizeXXL
        self.fontSizeDisplay = fontSizeDisplay
        self.fontWeightLight = fontWeightLight
        self.fontWeightRegular = fontWeightRegular
        self.fontWeightMedium = fontWeightMedium
        self.fontWeightSemibold = fontWeightSemibold
        self.fontWeightBold = fontWeightBold
        self.lineHeightTight = lineHeightTight
        self.lineHeightNormal = lineHeightNormal
        self.lineHeightRelaxed = lineHeightRelaxed
    }
}

// MARK: - Spacing

public struct LuxeSpacing: Sendable {
    public var xxxs: CGFloat
    public var xxs: CGFloat
    public var xs: CGFloat
    public var s: CGFloat
    public var m: CGFloat
    public var l: CGFloat
    public var xl: CGFloat
    public var xxl: CGFloat
    public var xxxl: CGFloat
    
    public init(
        xxxs: CGFloat = 2,
        xxs: CGFloat = 4,
        xs: CGFloat = 8,
        s: CGFloat = 12,
        m: CGFloat = 16,
        l: CGFloat = 24,
        xl: CGFloat = 32,
        xxl: CGFloat = 48,
        xxxl: CGFloat = 64
    ) {
        self.xxxs = xxxs
        self.xxs = xxs
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
    }
}

// MARK: - Border Radius

public struct LuxeBorderRadius: Sendable {
    public var none: CGFloat
    public var xs: CGFloat
    public var s: CGFloat
    public var m: CGFloat
    public var l: CGFloat
    public var xl: CGFloat
    public var full: CGFloat
    
    public init(
        none: CGFloat = 0,
        xs: CGFloat = 4,
        s: CGFloat = 8,
        m: CGFloat = 12,
        l: CGFloat = 16,
        xl: CGFloat = 24,
        full: CGFloat = 9999
    ) {
        self.none = none
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.full = full
    }
}

// MARK: - Effects

public struct LuxeEffects: Sendable {
    public var shadowSmall: CGFloat
    public var shadowMedium: CGFloat
    public var shadowLarge: CGFloat
    public var shadowXL: CGFloat
    public var blurSmall: CGFloat
    public var blurMedium: CGFloat
    public var blurLarge: CGFloat
    public var glowSmall: CGFloat
    public var glowMedium: CGFloat
    public var glowLarge: CGFloat
    public var animationFast: Double
    public var animationNormal: Double
    public var animationSlow: Double
    
    public init(
        shadowSmall: CGFloat = 4,
        shadowMedium: CGFloat = 8,
        shadowLarge: CGFloat = 16,
        shadowXL: CGFloat = 32,
        blurSmall: CGFloat = 8,
        blurMedium: CGFloat = 16,
        blurLarge: CGFloat = 32,
        glowSmall: CGFloat = 4,
        glowMedium: CGFloat = 8,
        glowLarge: CGFloat = 16,
        animationFast: Double = 0.15,
        animationNormal: Double = 0.3,
        animationSlow: Double = 0.5
    ) {
        self.shadowSmall = shadowSmall
        self.shadowMedium = shadowMedium
        self.shadowLarge = shadowLarge
        self.shadowXL = shadowXL
        self.blurSmall = blurSmall
        self.blurMedium = blurMedium
        self.blurLarge = blurLarge
        self.glowSmall = glowSmall
        self.glowMedium = glowMedium
        self.glowLarge = glowLarge
        self.animationFast = animationFast
        self.animationNormal = animationNormal
        self.animationSlow = animationSlow
    }
}

// MARK: - Theme

public struct Theme: Sendable {
    // Color tokens
    public var primaryColor: Color
    public var secondaryColor: Color
    public var accentColor: Color
    public var backgroundColor: Color
    public var surfaceColor: Color
    public var textColor: Color
    public var textSecondaryColor: Color
    
    // Design system
    public var colors: LuxeColorScheme
    public var typography: LuxeTypography
    public var spacing: LuxeSpacing
    public var borderRadius: LuxeBorderRadius
    public var effects: LuxeEffects
    
    // Legacy support
    public var fontSizeBody: CGFloat
    public var fontSizeHeadline: CGFloat
    public var cornerRadius: CGFloat
    public var spacingS: CGFloat
    public var spacingM: CGFloat
    public var spacingL: CGFloat
    public var shadowRadius: CGFloat
    public var animationDuration: Double
    public var enableHaptics: Bool
    
    public init(
        primaryColor: Color = .blue,
        secondaryColor: Color = .purple,
        accentColor: Color = .cyan,
        backgroundColor: Color = Color(red: 0.05, green: 0.05, blue: 0.1),
        surfaceColor: Color = Color(red: 0.1, green: 0.1, blue: 0.15),
        textColor: Color = .white,
        textSecondaryColor: Color = .white.opacity(0.7),
        colors: LuxeColorScheme? = nil,
        typography: LuxeTypography = LuxeTypography(),
        spacing: LuxeSpacing = LuxeSpacing(),
        borderRadius: LuxeBorderRadius = LuxeBorderRadius(),
        effects: LuxeEffects = LuxeEffects(),
        fontSizeBody: CGFloat = 16,
        fontSizeHeadline: CGFloat = 24,
        cornerRadius: CGFloat = 16,
        spacingS: CGFloat = 8,
        spacingM: CGFloat = 16,
        spacingL: CGFloat = 24,
        shadowRadius: CGFloat = 10,
        animationDuration: Double = 0.3,
        enableHaptics: Bool = true
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.surfaceColor = surfaceColor
        self.textColor = textColor
        self.textSecondaryColor = textSecondaryColor
        
        self.colors = colors ?? LuxeColorScheme(
            primary: primaryColor,
            secondary: secondaryColor,
            accent: accentColor,
            background: backgroundColor,
            surface: surfaceColor,
            text: textColor,
            textSecondary: textSecondaryColor
        )
        
        self.typography = typography
        self.spacing = spacing
        self.borderRadius = borderRadius
        self.effects = effects
        
        self.fontSizeBody = fontSizeBody
        self.fontSizeHeadline = fontSizeHeadline
        self.cornerRadius = cornerRadius
        self.spacingS = spacingS
        self.spacingM = spacingM
        self.spacingL = spacingL
        self.shadowRadius = shadowRadius
        self.animationDuration = animationDuration
        self.enableHaptics = enableHaptics
    }
    
    // MARK: - Preset Themes
    
    public static let `default` = Theme()
    
    public static let midnight = Theme(
        primaryColor: Color(red: 0.4, green: 0.2, blue: 0.8),
        secondaryColor: Color(red: 0.6, green: 0.2, blue: 0.6),
        accentColor: .cyan,
        backgroundColor: Color(red: 0.02, green: 0.02, blue: 0.08),
        surfaceColor: Color(red: 0.08, green: 0.08, blue: 0.15)
    )
    
    public static let sunset = Theme(
        primaryColor: Color(red: 1.0, green: 0.4, blue: 0.2),
        secondaryColor: Color(red: 0.9, green: 0.2, blue: 0.4),
        accentColor: .yellow,
        backgroundColor: Color(red: 0.1, green: 0.05, blue: 0.05),
        surfaceColor: Color(red: 0.15, green: 0.08, blue: 0.08)
    )
    
    public static let ocean = Theme(
        primaryColor: Color(red: 0.0, green: 0.6, blue: 0.8),
        secondaryColor: Color(red: 0.0, green: 0.4, blue: 0.6),
        accentColor: .mint,
        backgroundColor: Color(red: 0.02, green: 0.05, blue: 0.1),
        surfaceColor: Color(red: 0.05, green: 0.1, blue: 0.15)
    )
    
    public static let forest = Theme(
        primaryColor: Color(red: 0.2, green: 0.7, blue: 0.4),
        secondaryColor: Color(red: 0.1, green: 0.5, blue: 0.3),
        accentColor: .yellow,
        backgroundColor: Color(red: 0.02, green: 0.08, blue: 0.04),
        surfaceColor: Color(red: 0.05, green: 0.12, blue: 0.06)
    )
    
    public static let neon = Theme(
        primaryColor: Color(red: 1.0, green: 0.0, blue: 0.8),
        secondaryColor: Color(red: 0.0, green: 1.0, blue: 0.8),
        accentColor: .yellow,
        backgroundColor: Color(red: 0.02, green: 0.02, blue: 0.05),
        surfaceColor: Color(red: 0.05, green: 0.05, blue: 0.1)
    )
    
    public static let monochrome = Theme(
        primaryColor: .white,
        secondaryColor: .gray,
        accentColor: .white,
        backgroundColor: .black,
        surfaceColor: Color(white: 0.1),
        textColor: .white,
        textSecondaryColor: .gray
    )
    
    public static let light = Theme(
        primaryColor: .blue,
        secondaryColor: .purple,
        accentColor: .cyan,
        backgroundColor: Color(white: 0.95),
        surfaceColor: .white,
        textColor: .black,
        textSecondaryColor: .gray
    )
    
    // MARK: - Builder Pattern
    
    public func withPrimaryColor(_ color: Color) -> Theme {
        var copy = self
        copy.primaryColor = color
        copy.colors.primary = color
        return copy
    }
    
    public func withSecondaryColor(_ color: Color) -> Theme {
        var copy = self
        copy.secondaryColor = color
        copy.colors.secondary = color
        return copy
    }
    
    public func withAccentColor(_ color: Color) -> Theme {
        var copy = self
        copy.accentColor = color
        copy.colors.accent = color
        return copy
    }
    
    public func withBackgroundColor(_ color: Color) -> Theme {
        var copy = self
        copy.backgroundColor = color
        copy.colors.background = color
        return copy
    }
    
    public func withTypography(_ typography: LuxeTypography) -> Theme {
        var copy = self
        copy.typography = typography
        return copy
    }
    
    public func withSpacing(_ spacing: LuxeSpacing) -> Theme {
        var copy = self
        copy.spacing = spacing
        return copy
    }
    
    public func withEffects(_ effects: LuxeEffects) -> Theme {
        var copy = self
        copy.effects = effects
        return copy
    }
    
    public func withHaptics(_ enabled: Bool) -> Theme {
        var copy = self
        copy.enableHaptics = enabled
        return copy
    }
}

// MARK: - Theme Presets Enum

public enum ThemePreset: String, CaseIterable, Sendable {
    case `default`
    case midnight
    case sunset
    case ocean
    case forest
    case neon
    case monochrome
    case light
    
    public var theme: Theme {
        switch self {
        case .default: return .default
        case .midnight: return .midnight
        case .sunset: return .sunset
        case .ocean: return .ocean
        case .forest: return .forest
        case .neon: return .neon
        case .monochrome: return .monochrome
        case .light: return .light
        }
    }
}
