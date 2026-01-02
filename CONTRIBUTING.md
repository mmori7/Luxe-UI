# Contributing to LuxeUI

Thank you for your interest in contributing to LuxeUI! 🎉

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- macOS/iOS version
- Xcode version

### Suggesting Features

We love new ideas! Open an issue with:
- Clear description of the feature
- Use cases and examples
- Why it fits LuxeUI's philosophy (premium 2026 UI design)

### Submitting Pull Requests

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-component`
3. **Make your changes**:
   - Follow the existing code style
   - Add documentation comments
   - Ensure components work on macOS 12+ and iOS 15+
4. **Test thoroughly**:
   - Run the demo app
   - Test on multiple screen sizes
   - Verify animations are smooth
5. **Commit with clear messages**: `git commit -m "Add: Holographic button component"`
6. **Push and create PR**: `git push origin feature/amazing-component`

## Code Style Guidelines

### SwiftUI Best Practices
- Use `@Environment` for theme injection
- Create reusable `ViewModifier` types
- Document all public APIs with `///` comments
- Use `@ViewBuilder` for flexible composition
- Ensure `Sendable` conformance for Swift 6

### Component Design Principles
- **Premium First**: Every component should feel luxurious
- **Smooth Animations**: 60 FPS minimum, use spring physics
- **Theme-Aware**: All components respect the global theme
- **Cross-Platform**: Support both macOS and iOS where possible
- **Accessibility**: Consider VoiceOver and keyboard navigation

### Example Component Structure

```swift
/// A premium button with advanced effects
///
/// Example:
/// ```swift
/// LuxeButton("Click Me", style: .primary) {
///     print("Tapped!")
/// }
/// ```
public struct LuxeButton: View {
    @Environment(\.luxeTheme) private var theme
    
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
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
        // Implementation
    }
}
```

## Component Checklist

Before submitting a new component:

- [ ] Public API is well-documented
- [ ] Works with all 5 preset themes
- [ ] Includes usage example in docs
- [ ] Tested on macOS 12+ / iOS 15+
- [ ] Smooth 60 FPS animations
- [ ] Respects system accessibility settings
- [ ] Added to demo app showcase
- [ ] No compiler warnings

## Testing

Run the demo app to test your changes:

```bash
cd LuxeUIDemo
swift build
# Then open in Xcode and press ⌘R
```

## Questions?

Open a GitHub Discussion or reach out to the maintainers!

---

**Remember**: LuxeUI is about creating the most beautiful, premium UI components for 2026 and beyond. Every contribution should raise the bar! ✨
