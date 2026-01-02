import SwiftUI

/// A comprehensive theme model that defines the visual design system for LuxeUI components.
/// This is the core of the theming system - all colors, typography, spacing, and styling come from here.
public struct Theme: Sendable {
    
    // MARK: - Color Palette
    
    /// Primary brand color used for main actions and emphasis
    public let primaryColor: Color
    
    /// Secondary brand color for supporting elements
    public let secondaryColor: Color
    
    /// Accent color for highlights and calls-to-action
    public let accentColor: Color
    
    /// Background color for main surfaces
    public let backgroundColor: Color
    
    /// Secondary background for cards, containers, etc.
    public let secondaryBackgroundColor: Color
    
    /// Primary text color
    public let textPrimary: Color
    
    /// Secondary text color for less prominent text
    public let textSecondary: Color
    
    /// Tertiary text color for hints and placeholders
    public let textTertiary: Color
    
    /// Error/destructive action color
    public let errorColor: Color
    
    /// Success state color
    public let successColor: Color
    
    /// Warning state color
    public let warningColor: Color
    
    // MARK: - Typography
    
    /// Large title font size
    public let fontSizeLargeTitle: CGFloat
    
    /// Title font size
    public let fontSizeTitle: CGFloat
    
    /// Headline font size
    public let fontSizeHeadline: CGFloat
    
    /// Body text font size
    public let fontSizeBody: CGFloat
    
    /// Subheadline font size
    public let fontSizeSubheadline: CGFloat
    
    /// Caption text font size
    public let fontSizeCaption: CGFloat
    
    /// Font weight for regular text
    public let fontWeightRegular: Font.Weight
    
    /// Font weight for medium emphasis
    public let fontWeightMedium: Font.Weight
    
    /// Font weight for bold text
    public let fontWeightBold: Font.Weight
    
    // MARK: - Spacing System
    
    /// Extra small spacing (4pt)
    public let spacingXS: CGFloat
    
    /// Small spacing (8pt)
    public let spacingS: CGFloat
    
    /// Medium spacing (16pt)
    public let spacingM: CGFloat
    
    /// Large spacing (24pt)
    public let spacingL: CGFloat
    
    /// Extra large spacing (32pt)
    public let spacingXL: CGFloat
    
    /// Extra extra large spacing (48pt)
    public let spacingXXL: CGFloat
    
    // MARK: - Corner Radius
    
    /// Small corner radius for subtle rounding
    public let cornerRadiusSmall: CGFloat
    
    /// Medium corner radius for standard components
    public let cornerRadiusMedium: CGFloat
    
    /// Large corner radius for prominent elements
    public let cornerRadiusLarge: CGFloat
    
    /// Extra large corner radius for very rounded elements
    public let cornerRadiusXLarge: CGFloat
    
    // MARK: - Shadows & Effects
    
    /// Shadow radius for subtle elevation
    public let shadowRadiusSmall: CGFloat
    
    /// Shadow radius for medium elevation
    public let shadowRadiusMedium: CGFloat
    
    /// Shadow radius for prominent elevation
    public let shadowRadiusLarge: CGFloat
    
    /// Shadow opacity
    public let shadowOpacity: Double
    
    // MARK: - Animation
    
    /// Standard animation duration
    public let animationDuration: Double
    
    /// Animation spring response
    public let animationSpring: Double
    
    // MARK: - Initializer
    
    public init(
        primaryColor: Color = .blue,
        secondaryColor: Color = .purple,
        accentColor: Color = .pink,
        backgroundColor: Color = Color(red: 0.98, green: 0.98, blue: 0.98),
        secondaryBackgroundColor: Color = Color(red: 0.95, green: 0.95, blue: 0.95),
        textPrimary: Color = .primary,
        textSecondary: Color = .secondary,
        textTertiary: Color = Color.gray.opacity(0.6),
        errorColor: Color = .red,
        successColor: Color = .green,
        warningColor: Color = .orange,
        fontSizeLargeTitle: CGFloat = 34,
        fontSizeTitle: CGFloat = 28,
        fontSizeHeadline: CGFloat = 17,
        fontSizeBody: CGFloat = 15,
        fontSizeSubheadline: CGFloat = 13,
        fontSizeCaption: CGFloat = 11,
        fontWeightRegular: Font.Weight = .regular,
        fontWeightMedium: Font.Weight = .medium,
        fontWeightBold: Font.Weight = .bold,
        spacingXS: CGFloat = 4,
        spacingS: CGFloat = 8,
        spacingM: CGFloat = 16,
        spacingL: CGFloat = 24,
        spacingXL: CGFloat = 32,
        spacingXXL: CGFloat = 48,
        cornerRadiusSmall: CGFloat = 4,
        cornerRadiusMedium: CGFloat = 8,
        cornerRadiusLarge: CGFloat = 16,
        cornerRadiusXLarge: CGFloat = 24,
        shadowRadiusSmall: CGFloat = 2,
        shadowRadiusMedium: CGFloat = 8,
        shadowRadiusLarge: CGFloat = 16,
        shadowOpacity: Double = 0.1,
        animationDuration: Double = 0.3,
        animationSpring: Double = 0.6
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.errorColor = errorColor
        self.successColor = successColor
        self.warningColor = warningColor
        self.fontSizeLargeTitle = fontSizeLargeTitle
        self.fontSizeTitle = fontSizeTitle
        self.fontSizeHeadline = fontSizeHeadline
        self.fontSizeBody = fontSizeBody
        self.fontSizeSubheadline = fontSizeSubheadline
        self.fontSizeCaption = fontSizeCaption
        self.fontWeightRegular = fontWeightRegular
        self.fontWeightMedium = fontWeightMedium
        self.fontWeightBold = fontWeightBold
        self.spacingXS = spacingXS
        self.spacingS = spacingS
        self.spacingM = spacingM
        self.spacingL = spacingL
        self.spacingXL = spacingXL
        self.spacingXXL = spacingXXL
        self.cornerRadiusSmall = cornerRadiusSmall
        self.cornerRadiusMedium = cornerRadiusMedium
        self.cornerRadiusLarge = cornerRadiusLarge
        self.cornerRadiusXLarge = cornerRadiusXLarge
        self.shadowRadiusSmall = shadowRadiusSmall
        self.shadowRadiusMedium = shadowRadiusMedium
        self.shadowRadiusLarge = shadowRadiusLarge
        self.shadowOpacity = shadowOpacity
        self.animationDuration = animationDuration
        self.animationSpring = animationSpring
    }
}

// MARK: - Preset Themes

extension Theme {
    /// Default LuxeUI theme with blue and purple accents
    public static let `default` = Theme()
    
    /// Dark, mysterious theme with deep purples and blacks
    public static let midnight = Theme(
        primaryColor: Color(red: 0.4, green: 0.2, blue: 0.8),
        secondaryColor: Color(red: 0.2, green: 0.1, blue: 0.4),
        accentColor: Color(red: 0.8, green: 0.4, blue: 1.0),
        backgroundColor: Color(red: 0.05, green: 0.05, blue: 0.1),
        secondaryBackgroundColor: Color(red: 0.1, green: 0.1, blue: 0.15),
        textPrimary: .white,
        textSecondary: Color.white.opacity(0.7),
        textTertiary: Color.white.opacity(0.5)
    )
    
    /// Vibrant, energetic theme with warm colors
    public static let sunset = Theme(
        primaryColor: Color(red: 1.0, green: 0.4, blue: 0.2),
        secondaryColor: Color(red: 1.0, green: 0.6, blue: 0.0),
        accentColor: Color(red: 1.0, green: 0.2, blue: 0.4),
        backgroundColor: Color(red: 1.0, green: 0.98, blue: 0.95),
        secondaryBackgroundColor: Color(red: 1.0, green: 0.95, blue: 0.9),
        textPrimary: Color(red: 0.2, green: 0.1, blue: 0.1),
        textSecondary: Color(red: 0.4, green: 0.3, blue: 0.3)
    )
    
    /// Clean, modern theme with mint and teal accents
    public static let ocean = Theme(
        primaryColor: Color(red: 0.0, green: 0.7, blue: 0.8),
        secondaryColor: Color(red: 0.0, green: 0.5, blue: 0.6),
        accentColor: Color(red: 0.2, green: 0.9, blue: 0.7),
        backgroundColor: Color(red: 0.95, green: 0.98, blue: 1.0),
        secondaryBackgroundColor: Color(red: 0.9, green: 0.95, blue: 0.98)
    )
    
    /// Monochromatic theme for minimalist designs
    public static let monochrome = Theme(
        primaryColor: Color.black,
        secondaryColor: Color.gray,
        accentColor: Color(red: 0.3, green: 0.3, blue: 0.3),
        backgroundColor: .white,
        secondaryBackgroundColor: Color(red: 0.95, green: 0.95, blue: 0.95),
        textPrimary: .black,
        textSecondary: Color.gray,
        textTertiary: Color.gray.opacity(0.6)
    )
}
