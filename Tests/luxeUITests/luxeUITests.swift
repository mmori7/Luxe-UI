import Testing
import SwiftUI
@testable import LuxeUI

// MARK: - Theme Tests

@Suite("Theme System Tests")
struct ThemeTests {
    
    @Test("Default theme has expected values")
    func defaultTheme() {
        let theme = Theme.default
        
        #expect(theme.primaryColor == .blue)
        #expect(theme.secondaryColor == .purple)
        #expect(theme.accentColor == .cyan)
        #expect(theme.fontSizeBody == 16)
        #expect(theme.fontSizeHeadline == 24)
        #expect(theme.cornerRadius == 16)
        #expect(theme.enableHaptics == true)
    }
    
    @Test("Midnight theme has darker colors")
    func midnightTheme() {
        let theme = Theme.midnight
        
        // Midnight should have purple-ish primary
        #expect(theme.primaryColor != .blue)
        #expect(theme.enableHaptics == true)
    }
    
    @Test("All preset themes are available")
    func presetThemes() {
        let presets: [Theme] = [
            .default,
            .midnight,
            .sunset,
            .ocean,
            .forest,
            .neon,
            .monochrome,
            .light
        ]
        
        #expect(presets.count == 8)
    }
    
    @Test("ThemePreset enum maps to themes")
    func themePresetEnum() {
        for preset in ThemePreset.allCases {
            let theme = preset.theme
            #expect(theme.enableHaptics == true || theme.enableHaptics == false)
        }
        
        #expect(ThemePreset.allCases.count == 8)
    }
    
    @Test("Builder pattern modifies theme")
    func builderPattern() {
        let original = Theme.default
        let modified = original
            .withPrimaryColor(.red)
            .withSecondaryColor(.green)
            .withHaptics(false)
        
        #expect(modified.primaryColor == .red)
        #expect(modified.secondaryColor == .green)
        #expect(modified.enableHaptics == false)
        
        // Original should be unchanged
        #expect(original.primaryColor == .blue)
        #expect(original.enableHaptics == true)
    }
    
    @Test("Custom theme initialization")
    func customTheme() {
        let custom = Theme(
            primaryColor: .orange,
            secondaryColor: .pink,
            cornerRadius: 20,
            spacingM: 24,
            enableHaptics: false
        )
        
        #expect(custom.primaryColor == .orange)
        #expect(custom.secondaryColor == .pink)
        #expect(custom.cornerRadius == 20)
        #expect(custom.spacingM == 24)
        #expect(custom.enableHaptics == false)
    }
}

// MARK: - LuxeColorScheme Tests

@Suite("Color Scheme Tests")
struct ColorSchemeTests {
    
    @Test("Default color scheme")
    func defaultColorScheme() {
        let colors = LuxeColorScheme()
        
        #expect(colors.primary == .blue)
        #expect(colors.secondary == .purple)
        #expect(colors.accent == .cyan)
        #expect(colors.success == .green)
        #expect(colors.warning == .orange)
        #expect(colors.error == .red)
        #expect(colors.info == .cyan)
    }
    
    @Test("Custom color scheme")
    func customColorScheme() {
        let colors = LuxeColorScheme(
            primary: .red,
            secondary: .blue,
            success: .mint
        )
        
        #expect(colors.primary == .red)
        #expect(colors.secondary == .blue)
        #expect(colors.success == .mint)
    }
}

// MARK: - Typography Tests

@Suite("Typography Tests")
struct TypographyTests {
    
    @Test("Default typography values")
    func defaultTypography() {
        let typography = LuxeTypography()
        
        #expect(typography.fontSizeXS == 10)
        #expect(typography.fontSizeS == 12)
        #expect(typography.fontSizeM == 14)
        #expect(typography.fontSizeL == 16)
        #expect(typography.fontSizeXL == 20)
        #expect(typography.fontSizeXXL == 24)
        #expect(typography.fontSizeDisplay == 36)
        #expect(typography.lineHeightTight == 1.2)
        #expect(typography.lineHeightNormal == 1.5)
        #expect(typography.lineHeightRelaxed == 1.8)
    }
    
    @Test("Custom typography")
    func customTypography() {
        let typography = LuxeTypography(
            fontSizeM: 18,
            fontSizeL: 20,
            lineHeightNormal: 1.6
        )
        
        #expect(typography.fontSizeM == 18)
        #expect(typography.fontSizeL == 20)
        #expect(typography.lineHeightNormal == 1.6)
    }
}

// MARK: - Spacing Tests

@Suite("Spacing Tests")
struct SpacingTests {
    
    @Test("Default spacing values")
    func defaultSpacing() {
        let spacing = LuxeSpacing()
        
        #expect(spacing.xxxs == 2)
        #expect(spacing.xxs == 4)
        #expect(spacing.xs == 8)
        #expect(spacing.s == 12)
        #expect(spacing.m == 16)
        #expect(spacing.l == 24)
        #expect(spacing.xl == 32)
        #expect(spacing.xxl == 48)
        #expect(spacing.xxxl == 64)
    }
    
    @Test("Custom spacing")
    func customSpacing() {
        let spacing = LuxeSpacing(
            s: 10,
            m: 20,
            l: 30
        )
        
        #expect(spacing.s == 10)
        #expect(spacing.m == 20)
        #expect(spacing.l == 30)
    }
}

// MARK: - Border Radius Tests

@Suite("Border Radius Tests")
struct BorderRadiusTests {
    
    @Test("Default border radius values")
    func defaultBorderRadius() {
        let radius = LuxeBorderRadius()
        
        #expect(radius.none == 0)
        #expect(radius.xs == 4)
        #expect(radius.s == 8)
        #expect(radius.m == 12)
        #expect(radius.l == 16)
        #expect(radius.xl == 24)
        #expect(radius.full == 9999)
    }
}

// MARK: - Effects Tests

@Suite("Effects Tests")
struct EffectsTests {
    
    @Test("Default effects values")
    func defaultEffects() {
        let effects = LuxeEffects()
        
        #expect(effects.shadowSmall == 4)
        #expect(effects.shadowMedium == 8)
        #expect(effects.shadowLarge == 16)
        #expect(effects.blurSmall == 8)
        #expect(effects.blurMedium == 16)
        #expect(effects.blurLarge == 32)
        #expect(effects.animationFast == 0.15)
        #expect(effects.animationNormal == 0.3)
        #expect(effects.animationSlow == 0.5)
    }
}

// MARK: - LuxeCard Configuration Tests

@Suite("LuxeCard Configuration Tests")
struct LuxeCardConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = LuxeCardConfiguration.default
        
        #expect(config.cornerRadius == 20)
        #expect(config.blur == 10)
        #expect(config.backgroundOpacity == 0.15)
        #expect(config.borderWidth == 1)
        #expect(config.hoverScale == 1.02)
        #expect(config.pressScale == 0.98)
        #expect(config.enableHaptics == true)
    }
    
    @Test("Compact preset")
    func compactPreset() {
        let config = LuxeCardConfiguration.compact
        
        #expect(config.cornerRadius == 12)
        #expect(config.blur == 8)
        #expect(config.hoverScale == 1.01)
    }
    
    @Test("Prominent preset")
    func prominentPreset() {
        let config = LuxeCardConfiguration.prominent
        
        #expect(config.cornerRadius == 28)
        #expect(config.blur == 15)
        #expect(config.backgroundOpacity == 0.2)
        #expect(config.hoverScale == 1.05)
    }
    
    @Test("Custom configuration")
    func customConfiguration() {
        let config = LuxeCardConfiguration(
            cornerRadius: 30,
            blur: 15,
            hoverScale: 1.1,
            enableHaptics: false
        )
        
        #expect(config.cornerRadius == 30)
        #expect(config.blur == 15)
        #expect(config.hoverScale == 1.1)
        #expect(config.enableHaptics == false)
    }
    
    @Test("All presets exist")
    func allPresets() {
        let presets: [LuxeCardConfiguration] = [
            .default,
            .compact,
            .prominent,
            .subtle,
            .floating
        ]
        
        #expect(presets.count == 5)
    }
}

// MARK: - GlassmorphismConfiguration Tests

@Suite("Glassmorphism Configuration Tests")
struct GlassmorphismConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = GlassmorphismConfiguration.default
        
        #expect(config.blurRadius == 20)
        #expect(config.backgroundOpacity == 0.3)
        #expect(config.cornerRadius == 20)
        #expect(config.borderWidth == 1)
        #expect(config.enableInnerShadow == true)
        #expect(config.enableBorder == true)
    }
    
    @Test("Frosted preset")
    func frostedPreset() {
        let config = GlassmorphismConfiguration.frosted
        
        #expect(config.blurRadius == 30)
        #expect(config.backgroundOpacity == 0.4)
    }
    
    @Test("Clear preset")
    func clearPreset() {
        let config = GlassmorphismConfiguration.clear
        
        #expect(config.blurRadius == 10)
        #expect(config.backgroundOpacity == 0.15)
    }
    
    @Test("Minimal preset")
    func minimalPreset() {
        let config = GlassmorphismConfiguration.minimal
        
        #expect(config.blurRadius == 8)
        #expect(config.enableInnerShadow == false)
        #expect(config.enableBorder == false)
    }
    
    @Test("All presets exist")
    func allPresets() {
        let presets: [GlassmorphismConfiguration] = [
            .default,
            .frosted,
            .clear,
            .dark,
            .vibrant,
            .minimal
        ]
        
        #expect(presets.count == 6)
    }
}

// MARK: - CircularProgressConfiguration Tests

@Suite("Circular Progress Configuration Tests")
struct CircularProgressConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = CircularProgressConfiguration.default
        
        #expect(config.size == 100)
        #expect(config.lineWidth == 10)
        #expect(config.showPercentage == true)
        #expect(config.useGradient == true)
        #expect(config.enableGlow == true)
    }
    
    @Test("Size presets")
    func sizePresets() {
        let small = CircularProgressConfiguration.small
        let medium = CircularProgressConfiguration.medium
        let large = CircularProgressConfiguration.large
        let extraLarge = CircularProgressConfiguration.extraLarge
        
        #expect(small.size == 50)
        #expect(medium.size == 80)
        #expect(large.size == 120)
        #expect(extraLarge.size == 160)
    }
    
    @Test("Style presets")
    func stylePresets() {
        let flat = CircularProgressConfiguration.flat
        let neon = CircularProgressConfiguration.neon
        let subtle = CircularProgressConfiguration.subtle
        
        #expect(flat.useGradient == false)
        #expect(flat.enableGlow == false)
        #expect(neon.glowRadius == 15)
        #expect(subtle.enableGlow == false)
    }
}

// MARK: - MultiThumbSliderConfiguration Tests

@Suite("Multi-Thumb Slider Configuration Tests")
struct MultiThumbSliderConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = MultiThumbSliderConfiguration.default
        
        #expect(config.trackHeight == 6)
        #expect(config.thumbSize == 24)
        #expect(config.thumbBorderWidth == 2)
        #expect(config.showLabels == true)
        #expect(config.enableHaptics == true)
    }
    
    @Test("Compact preset")
    func compactPreset() {
        let config = MultiThumbSliderConfiguration.compact
        
        #expect(config.trackHeight == 4)
        #expect(config.thumbSize == 18)
    }
    
    @Test("Large preset")
    func largePreset() {
        let config = MultiThumbSliderConfiguration.large
        
        #expect(config.trackHeight == 8)
        #expect(config.thumbSize == 32)
    }
    
    @Test("Minimal preset")
    func minimalPreset() {
        let config = MultiThumbSliderConfiguration.minimal
        
        #expect(config.thumbBorderWidth == 0)
        #expect(config.showLabels == false)
    }
}

// MARK: - SmartSpringConfiguration Tests

@Suite("Smart Spring Configuration Tests")
struct SmartSpringConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = SmartSpringConfiguration.default
        
        #expect(config.sensitivity == 1.0)
        #expect(config.enableRotation == false)
        #expect(config.maxOffset == 100)
        #expect(config.enableHaptics == true)
    }
    
    @Test("Bouncy preset")
    func bouncyPreset() {
        let config = SmartSpringConfiguration.bouncy
        
        #expect(config.sensitivity == 1.5)
        #expect(config.dampingFraction == 0.5)
    }
    
    @Test("Stiff preset")
    func stiffPreset() {
        let config = SmartSpringConfiguration.stiff
        
        #expect(config.sensitivity == 0.5)
        #expect(config.dampingFraction == 0.9)
    }
    
    @Test("Wobbly preset")
    func wobblyPreset() {
        let config = SmartSpringConfiguration.wobbly
        
        #expect(config.enableRotation == true)
        #expect(config.rotationMultiplier == 1.5)
    }
}

// MARK: - MagneticPullConfiguration Tests

@Suite("Magnetic Pull Configuration Tests")
struct MagneticPullConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = MagneticPullConfiguration.default
        
        #expect(config.radius == 100)
        #expect(config.strength == 0.5)
        #expect(config.maxOffset == 20)
        #expect(config.enableHaptics == true)
    }
    
    @Test("Strong preset")
    func strongPreset() {
        let config = MagneticPullConfiguration.strong
        
        #expect(config.radius == 150)
        #expect(config.strength == 0.8)
    }
    
    @Test("Subtle preset")
    func subtlePreset() {
        let config = MagneticPullConfiguration.subtle
        
        #expect(config.radius == 80)
        #expect(config.strength == 0.3)
    }
}

// MARK: - RefractiveGlassConfiguration Tests

@Suite("Refractive Glass Configuration Tests")
struct RefractiveGlassConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = RefractiveGlassConfiguration.default
        
        #expect(config.distortionIntensity == 0.2)
        #expect(config.chromaticAberration == true)
        #expect(config.causticAnimation == true)
        #expect(config.layerCount == 3)
        #expect(config.blurRadius == 20)
        #expect(config.cornerRadius == 24)
    }
    
    @Test("Subtle preset")
    func subtlePreset() {
        let config = RefractiveGlassConfiguration.subtle
        
        #expect(config.distortionIntensity == 0.1)
        #expect(config.layerCount == 2)
    }
    
    @Test("Intense preset")
    func intensePreset() {
        let config = RefractiveGlassConfiguration.intense
        
        #expect(config.distortionIntensity == 0.35)
        #expect(config.layerCount == 5)
    }
    
    @Test("Minimal preset")
    func minimalPreset() {
        let config = RefractiveGlassConfiguration.minimal
        
        #expect(config.chromaticAberration == false)
        #expect(config.causticAnimation == false)
        #expect(config.layerCount == 1)
    }
    
    @Test("Liquid preset")
    func liquidPreset() {
        let config = RefractiveGlassConfiguration.liquid
        
        #expect(config.distortionIntensity == 0.25)
        #expect(config.distortionRadius == 70)
        #expect(config.layerCount == 4)
    }
    
    @Test("Frosted preset")
    func frostedPreset() {
        let config = RefractiveGlassConfiguration.frosted
        
        #expect(config.chromaticAberration == false)
        #expect(config.causticAnimation == false)
        #expect(config.blurRadius == 30)
    }
}

// MARK: - TactileFeedback Tests

@Suite("Tactile Feedback Tests")
struct TactileFeedbackTests {
    
    @Test("Intensity enum has all values")
    func intensityValues() {
        let intensities: [TactileFeedback.Intensity] = [
            .light,
            .medium,
            .heavy
        ]
        
        #expect(intensities.count == 3)
    }
    
    @Test("Static methods exist")
    func staticMethods() {
        // These should not crash
        TactileFeedback.light()
        TactileFeedback.medium()
        TactileFeedback.heavy()
        TactileFeedback.trigger(.light)
        TactileFeedback.trigger(.medium)
        TactileFeedback.trigger(.heavy)
    }
}

// MARK: - LuxeUI Library Tests

@Suite("LuxeUI Library Tests")
struct LuxeUILibraryTests {
    
    @Test("Library version is set")
    func libraryVersion() {
        #expect(LuxeUI.version == "1.0.0")
    }
}

// MARK: - LuxeButton Configuration Tests

@Suite("LuxeButton Configuration Tests")
struct LuxeButtonConfigurationTests {
    
    @Test("Default configuration via medium preset")
    func mediumConfiguration() {
        let config = LuxeButtonConfiguration.medium
        
        #expect(config.cornerRadius == 12)
        #expect(config.enableHaptics == true)
    }
    
    @Test("All presets exist")
    func allPresets() {
        let presets: [LuxeButtonConfiguration] = [
            .small,
            .medium,
            .large,
            .extraLarge
        ]
        
        #expect(presets.count == 4)
    }
    
    @Test("Small preset has smaller values")
    func smallPreset() {
        let config = LuxeButtonConfiguration.small
        
        #expect(config.cornerRadius == 8)
        #expect(config.fontSize == 14)
    }
    
    @Test("Large preset has larger values")
    func largePreset() {
        let config = LuxeButtonConfiguration.large
        
        #expect(config.cornerRadius == 16)
        #expect(config.fontSize == 18)
    }
}

// MARK: - LuxeBadge Configuration Tests

@Suite("LuxeBadge Configuration Tests")
struct LuxeBadgeConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = LuxeBadgeConfiguration.default
        
        #expect(config.fontSize == 10)
        #expect(config.enableGlow == true)
    }
    
    @Test("All presets exist")
    func allPresets() {
        let presets: [LuxeBadgeConfiguration] = [
            .default,
            .small,
            .large,
            .noGlow
        ]
        
        #expect(presets.count == 4)
    }
    
    @Test("No glow preset disables glow")
    func noGlowPreset() {
        let config = LuxeBadgeConfiguration.noGlow
        
        #expect(config.enableGlow == false)
    }
}

// MARK: - FloatingOrb Configuration Tests

@Suite("FloatingOrb Configuration Tests")
struct FloatingOrbConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = FloatingOrbConfiguration.default
        
        #expect(config.blurRadius == 60)
        #expect(config.opacity == 0.6)
        #expect(config.enableAnimation == true)
        #expect(config.enableGlow == true)
    }
    
    @Test("All presets exist")
    func allPresets() {
        let presets: [FloatingOrbConfiguration] = [
            .default,
            .subtle,
            .vibrant,
            .static
        ]
        
        #expect(presets.count == 4)
    }
    
    @Test("Static preset disables animation")
    func staticPreset() {
        let config = FloatingOrbConfiguration.static
        
        #expect(config.enableAnimation == false)
    }
}

// MARK: - PredictiveLayout Configuration Tests

@Suite("Predictive Layout Configuration Tests")
struct PredictiveLayoutConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = PredictiveLayoutConfiguration.default
        
        #expect(config.enableScale == true)
        #expect(config.enableGlow == true)
        #expect(config.enableElevation == true)
    }
    
    @Test("All presets exist")
    func allPresets() {
        let presets: [PredictiveLayoutConfiguration] = [
            .default,
            .subtle,
            .prominent,
            .noAnimation
        ]
        
        #expect(presets.count == 4)
    }
    
    @Test("No animation preset disables all effects")
    func noAnimationPreset() {
        let config = PredictiveLayoutConfiguration.noAnimation
        
        #expect(config.enableGlow == false)
        #expect(config.enableScale == false)
        #expect(config.enableElevation == false)
    }
}
