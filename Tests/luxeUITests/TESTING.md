# Testing Guide

LuxeUI uses the Swift Testing framework for comprehensive test coverage. This guide covers how to run tests, understand the test structure, and contribute new tests.

## Quick Start

```bash
# Run all tests
swift test

# Run tests with verbose output
swift test --verbose

# Run specific test suite
swift test --filter "ThemeTests"

# Run smoke tests only
swift test --filter "SmokeTests"
```

## Test Summary

| Category | Suites | Tests | Description |
|----------|--------|-------|-------------|
| **Unit Tests** | 19 | 60 | Detailed component behavior tests |
| **Smoke Tests** | 15 | 43 | Quick sanity checks for all features |
| **Total** | 34 | 103 | Full test coverage |

## Test Structure

```
Tests/
└── luxeUITests/
    ├── luxeUITests.swift    # Unit tests (60 tests)
    └── SmokeTests.swift     # Smoke tests (43 tests)
```

## Complete Test List

### Unit Tests (luxeUITests.swift)

| # | Suite | Test Name | Description |
|---|-------|-----------|-------------|
| 1 | Theme System Tests | Default theme has expected values | Verifies default theme colors and settings |
| 2 | Theme System Tests | Midnight theme has darker colors | Validates midnight preset |
| 3 | Theme System Tests | All preset themes are available | Checks all 8 theme presets exist |
| 4 | Theme System Tests | ThemePreset enum maps to themes | Validates enum → theme mapping |
| 5 | Theme System Tests | Builder pattern modifies theme | Tests fluent builder API |
| 6 | Theme System Tests | Custom theme initialization | Validates custom theme creation |
| 7 | Color Scheme Tests | Default color scheme | Checks default LuxeColorScheme |
| 8 | Color Scheme Tests | Custom color scheme | Tests custom color overrides |
| 9 | Typography Tests | Default typography values | Validates font size scale |
| 10 | Typography Tests | Custom typography | Tests custom font sizes |
| 11 | Spacing Tests | Default spacing values | Checks spacing scale (xxxs→xxxl) |
| 12 | Spacing Tests | Custom spacing | Tests custom spacing values |
| 13 | Border Radius Tests | Default border radius values | Validates radius scale |
| 14 | Effects Tests | Default effects values | Checks shadow/blur/animation values |
| 15 | LuxeCard Configuration | Default configuration | Tests LuxeCard defaults |
| 16 | LuxeCard Configuration | Compact preset | Validates compact card preset |
| 17 | LuxeCard Configuration | Prominent preset | Validates prominent card preset |
| 18 | LuxeCard Configuration | Custom configuration | Tests custom card config |
| 19 | LuxeCard Configuration | All presets exist | Verifies all 5 card presets |
| 20 | Glassmorphism Configuration | Default configuration | Tests glass container defaults |
| 21 | Glassmorphism Configuration | Frosted preset | Validates frosted glass effect |
| 22 | Glassmorphism Configuration | Clear preset | Validates clear glass effect |
| 23 | Glassmorphism Configuration | Minimal preset | Tests minimal glass styling |
| 24 | Glassmorphism Configuration | All presets exist | Verifies all 6 glass presets |
| 25 | Circular Progress Configuration | Default configuration | Tests progress bar defaults |
| 26 | Circular Progress Configuration | Size presets | Validates small/medium/large/xl |
| 27 | Circular Progress Configuration | Style presets | Tests flat/neon/subtle styles |
| 28 | Circular Progress Configuration | Custom configuration | Tests custom progress config |
| 29 | Multi-Thumb Slider Configuration | Default configuration | Tests slider defaults |
| 30 | Multi-Thumb Slider Configuration | Compact preset | Validates compact slider |
| 31 | Multi-Thumb Slider Configuration | Large preset | Validates large slider |
| 32 | Multi-Thumb Slider Configuration | Minimal preset | Tests minimal slider styling |
| 33 | Smart Spring Configuration | Default configuration | Tests spring physics defaults |
| 34 | Smart Spring Configuration | Bouncy preset | Validates bouncy spring |
| 35 | Smart Spring Configuration | Stiff preset | Validates stiff spring |
| 36 | Smart Spring Configuration | Wobbly preset | Tests wobbly spring with rotation |
| 37 | Smart Spring Configuration | All presets exist | Verifies all spring presets |
| 38 | Magnetic Pull Configuration | Default configuration | Tests magnetic pull defaults |
| 39 | Magnetic Pull Configuration | Strong preset | Validates strong magnetic pull |
| 40 | Magnetic Pull Configuration | Subtle preset | Validates subtle magnetic pull |
| 41 | Magnetic Pull Configuration | All presets exist | Verifies all magnetic presets |
| 42 | Refractive Glass Configuration | Default configuration | Tests liquid glass defaults |
| 43 | Refractive Glass Configuration | Subtle preset | Validates subtle distortion |
| 44 | Refractive Glass Configuration | Intense preset | Validates intense distortion |
| 45 | Refractive Glass Configuration | Minimal preset | Tests performance-optimized preset |
| 46 | Refractive Glass Configuration | Liquid preset | Validates water-like effect |
| 47 | Refractive Glass Configuration | Frosted preset | Tests frosted glass preset |
| 48 | Predictive Layout Configuration | Default configuration | Tests adaptive layout defaults |
| 49 | Predictive Layout Configuration | All presets exist | Verifies all layout presets |
| 50 | Predictive Layout Configuration | No animation preset | Tests disabled animations |
| 51 | Predictive Layout Configuration | Custom configuration | Tests custom adaptive config |
| 52 | Tactile Feedback Tests | Intensity enum has all values | Checks light/medium/heavy |
| 53 | Tactile Feedback Tests | Static methods exist | Verifies haptic trigger methods |
| 54 | LuxeUI Library Tests | Library version is set | Validates version string |
| 55 | LuxeButton Configuration | Default configuration | Tests button size defaults |
| 56 | LuxeButton Configuration | All presets exist | Verifies small/medium/large/xl |
| 57 | LuxeButton Configuration | Small preset | Validates small button |
| 58 | LuxeButton Configuration | Large preset | Validates large button |
| 59 | LuxeBadge Configuration | Default configuration | Tests badge defaults |
| 60 | LuxeBadge Configuration | No glow preset | Tests glow-disabled badge |

### Smoke Tests (SmokeTests.swift)

| # | Suite | Test Name | Description |
|---|-------|-----------|-------------|
| 1 | Theme Smoke Tests | All theme presets can be instantiated | Loads all 8 themes |
| 2 | Theme Smoke Tests | Theme builder chain works | Tests fluent API chain |
| 3 | Theme Smoke Tests | All ThemePreset enum values exist | Validates enum count |
| 4 | Design Token Smoke Tests | LuxeColorScheme initializes | Tests color scheme init |
| 5 | Design Token Smoke Tests | LuxeTypography initializes | Tests typography init |
| 6 | Design Token Smoke Tests | LuxeSpacing initializes | Tests spacing init |
| 7 | Design Token Smoke Tests | LuxeBorderRadius initializes | Tests radius init |
| 8 | Design Token Smoke Tests | LuxeEffects initializes | Tests effects init |
| 9 | LuxeCard Smoke Tests | All LuxeCard presets exist | Verifies 5 presets |
| 10 | LuxeCard Smoke Tests | LuxeCard can be configured | Tests custom config |
| 11 | LuxeCard Smoke Tests | LuxeCard view can be instantiated | Creates view instance |
| 12 | Glassmorphism Smoke Tests | All presets exist | Verifies 6 presets |
| 13 | Glassmorphism Smoke Tests | Container can be configured | Tests custom config |
| 14 | Glassmorphism Smoke Tests | Container view can be instantiated | Creates view instance |
| 15 | Refractive Glass Smoke Tests | All presets exist | Verifies 6 presets |
| 16 | Refractive Glass Smoke Tests | Can be configured with all options | Tests full config |
| 17 | Refractive Glass Smoke Tests | Chromatic aberration can be disabled | Tests option toggle |
| 18 | Circular Progress Smoke Tests | All size presets exist | Verifies size presets |
| 19 | Circular Progress Smoke Tests | All style presets exist | Verifies style presets |
| 20 | Circular Progress Smoke Tests | Can be configured | Tests custom config |
| 21 | Circular Progress Smoke Tests | View can be instantiated | Creates view instance |
| 22 | MultiThumbSlider Smoke Tests | All presets exist | Verifies 5 presets |
| 23 | MultiThumbSlider Smoke Tests | Can be configured | Tests custom config |
| 24 | MultiThumbSlider Smoke Tests | Haptic settings can be customized | Tests haptic options |
| 25 | SmartSpring Smoke Tests | All presets exist | Verifies 5 presets |
| 26 | SmartSpring Smoke Tests | Can be configured | Tests custom config |
| 27 | SmartSpring Smoke Tests | Spring physics values are valid | Validates physics |
| 28 | MagneticPull Smoke Tests | All presets exist | Verifies 4 presets |
| 29 | MagneticPull Smoke Tests | Can be configured | Tests custom config |
| 30 | PredictiveLayout Smoke Tests | All presets exist | Verifies 4 presets |
| 31 | PredictiveLayout Smoke Tests | Can be configured | Tests custom config |
| 32 | PredictiveLayout Smoke Tests | noAnimation preset disables all | Validates preset |
| 33 | Premium Components Smoke Tests | LuxeButton presets exist | Verifies 4 presets |
| 34 | Premium Components Smoke Tests | LuxeBadge presets exist | Verifies 4 presets |
| 35 | Premium Components Smoke Tests | FloatingOrb presets exist | Verifies 4 presets |
| 36 | TactileFeedback Smoke Tests | All intensity levels exist | Checks 3 levels |
| 37 | TactileFeedback Smoke Tests | Static methods are callable | Tests haptic calls |
| 38 | Library Smoke Tests | LuxeUI version is defined | Validates version |
| 39 | View Modifier Smoke Tests | Theme modifier exists | Tests .luxeTheme() |
| 40 | View Modifier Smoke Tests | Custom theme modifier exists | Tests custom theme |
| 41 | Integration Smoke Tests | Components can be nested | Tests view nesting |
| 42 | Integration Smoke Tests | Theme flows through hierarchy | Tests theme propagation |
| 43 | Integration Smoke Tests | All configurations can coexist | Tests config compatibility |



### Theme System

| Suite | Tests | Coverage |
|-------|-------|----------|
| Theme System Tests | 6 | Theme presets, builder pattern, custom themes |
| Color Scheme Tests | 2 | Default and custom color schemes |
| Typography Tests | 2 | Font sizes and line heights |
| Spacing Tests | 2 | Spacing scale values |
| Border Radius Tests | 1 | Radius presets |
| Effects Tests | 1 | Shadows, blur, animations |

### Component Configurations

| Suite | Tests | Coverage |
|-------|-------|----------|
| LuxeCard Configuration | 5 | All card presets and custom config |
| Glassmorphism Configuration | 5 | Glass effect presets |
| Circular Progress Configuration | 4 | Size and style presets |
| Multi-Thumb Slider Configuration | 4 | Slider presets |
| Smart Spring Configuration | 5 | Spring physics presets |
| Magnetic Pull Configuration | 4 | Magnetic interaction presets |
| Refractive Glass Configuration | 6 | Liquid glass effect presets |
| Predictive Layout Configuration | 4 | Adaptive UI presets |
| LuxeButton Configuration | 4 | Button size presets |
| LuxeBadge Configuration | 4 | Badge presets |
| FloatingOrb Configuration | 4 | Orb animation presets |
| Tactile Feedback Tests | 2 | Haptic feedback intensities |
| LuxeUI Library Tests | 1 | Version metadata |

## Smoke Test Suites

Smoke tests verify that all components can be instantiated without errors:

| Suite | Tests | What's Verified |
|-------|-------|-----------------|
| Theme Smoke Tests | 3 | All 8 theme presets load correctly |
| Design Token Smoke Tests | 5 | Color, typography, spacing, radius, effects |
| LuxeCard Smoke Tests | 3 | Card presets, config, view creation |
| Glassmorphism Smoke Tests | 3 | Glass presets, config, view creation |
| Refractive Glass Smoke Tests | 3 | All 6 liquid glass presets |
| Circular Progress Smoke Tests | 4 | Size/style presets, view creation |
| MultiThumbSlider Smoke Tests | 3 | Slider presets and haptic settings |
| SmartSpring Smoke Tests | 3 | Spring physics and presets |
| MagneticPull Smoke Tests | 2 | Magnetic interaction presets |
| PredictiveLayout Smoke Tests | 3 | Adaptive layout presets |
| Premium Components Smoke Tests | 3 | Button, Badge, FloatingOrb |
| TactileFeedback Smoke Tests | 2 | Haptic intensity levels |
| Library Smoke Tests | 1 | Version string validation |
| View Modifier Smoke Tests | 2 | Theme modifier application |
| Integration Smoke Tests | 3 | Nested components, theme flow |

## Running Tests in CI

Tests run automatically on every push and PR via GitHub Actions:

### Workflows

| Workflow | Trigger | What Runs |
|----------|---------|-----------|
| `swift.yml` | Push/PR | `swift build` + `swift test` |
| `tests.yml` | Push/PR | `swift test --parallel` |
| `smoke-tests.yml` | Push/PR | `swift test --filter SmokeTests --parallel` |

### CI Badges

![Swift CI](https://github.com/Ronitsabhaya75/Luxe-UI/actions/workflows/swift.yml/badge.svg)
![Tests](https://github.com/Ronitsabhaya75/Luxe-UI/actions/workflows/tests.yml/badge.svg)
![Smoke Tests](https://github.com/Ronitsabhaya75/Luxe-UI/actions/workflows/smoke-tests.yml/badge.svg)

## Writing New Tests

### Unit Test Example

```swift
import Testing
@testable import LuxeUI

@Suite("My Component Tests")
struct MyComponentTests {
    
    @Test("Default configuration has expected values")
    func defaultConfiguration() {
        let config = MyConfiguration.default
        
        #expect(config.size == 100)
        #expect(config.enabled == true)
    }
    
    @Test("Custom configuration works")
    func customConfiguration() {
        let config = MyConfiguration(size: 200, enabled: false)
        
        #expect(config.size == 200)
        #expect(config.enabled == false)
    }
}
```

### Smoke Test Example

```swift
@Suite("My Component Smoke Tests")
struct MyComponentSmokeTests {
    
    @Test("All presets exist")
    func presets() {
        let presets: [MyConfiguration] = [
            .default,
            .compact,
            .large
        ]
        
        #expect(presets.count == 3)
        
        for preset in presets {
            #expect(preset.size > 0)
        }
    }
    
    @Test("View can be instantiated")
    func viewInstantiation() {
        let view = MyComponent {
            Text("Content")
        }
        #expect(view != nil)
    }
}
```

### Best Practices

1. **Use descriptive test names** - Test names should describe what's being tested
2. **One assertion per concept** - Keep tests focused on a single behavior
3. **Test all presets** - Ensure every configuration preset is covered
4. **Test edge cases** - Include boundary conditions and invalid inputs
5. **Keep tests fast** - Avoid slow operations; use mocks when needed

## Test Categories

### Configuration Tests
Test that configuration structs:
- Have valid default values
- Support custom initialization
- Have all documented presets

### View Tests
Test that SwiftUI views:
- Can be instantiated with default config
- Can be instantiated with custom config
- Accept content builders correctly

### Integration Tests
Test that components:
- Can be nested within each other
- Receive theme from parent views
- Work with all theme presets

## Debugging Failed Tests

```bash
# Run with verbose output
swift test --verbose

# Run single failing test
swift test --filter "testName"

# Show test output on failure
swift test 2>&1 | tee test-output.log
```

## Code Coverage

To generate code coverage reports:

```bash
swift test --enable-code-coverage

# Find coverage data
xcrun llvm-cov report \
  .build/debug/luxeUIPackageTests.xctest/Contents/MacOS/luxeUIPackageTests \
  -instr-profile=.build/debug/codecov/default.profdata
```

## Contributing Tests

When adding new features:

1. **Add unit tests** in `luxeUITests.swift` for detailed behavior
2. **Add smoke tests** in `SmokeTests.swift` for quick validation
3. **Run full suite** before submitting PR: `swift test`
4. **Ensure CI passes** - Check GitHub Actions status


