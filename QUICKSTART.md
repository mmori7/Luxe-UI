# LuxeUI Quick Start Guide

Get up and running with LuxeUI in 5 minutes!

## Step 1: Installation

### Option A: Swift Package Manager (Recommended)

1. In Xcode, go to **File → Add Packages...**
2. Enter the repository URL: `https://github.com/yourusername/luxeUI`
3. Select version `1.0.0` or later
4. Click "Add Package"

### Option B: Package.swift

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/luxeUI.git", from: "1.0.0")
]
```

## Step 2: Import & Setup Theme

```swift
import SwiftUI
import LuxeUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .luxeTheme(.midnight)  // Choose: .default, .midnight, .sunset, .ocean, .monochrome
        }
    }
}
```

## Step 3: Use Components

### Basic Card
```swift
struct ContentView: View {
    var body: some View {
        LuxeCard {
            VStack {
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                Text("My First LuxeUI Card")
                    .font(.headline)
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}
```

### Refractive Glass (The Wow Factor!)
```swift
RefractiveGlassCard {
    VStack {
        Image(systemName: "sparkles")
            .font(.system(size: 50))
        Text("Liquid Glass Effect")
            .font(.title)
    }
    .padding()
}
.frame(width: 350, height: 250)
```

### Premium Button
```swift
LuxeButton("Click Me", style: .primary) {
    print("Button tapped!")
}
```

### Progress Indicator
```swift
@State private var progress: Double = 0.75

CircularProgressBar(
    progress: progress,
    showPercentage: true,
    gradient: true
)
.frame(width: 150, height: 150)
```

## Step 4: Add Background

```swift
ZStack {
    MeshGradientBackground(colors: [
        Color(red: 0.4, green: 0.2, blue: 0.8),
        Color(red: 0.8, green: 0.2, blue: 0.6),
        Color(red: 0.2, green: 0.4, blue: 0.9)
    ])
    
    // Your content here
    VStack {
        RefractiveGlassCard { /* ... */ }
    }
}
```

## Step 5: Advanced Features

### Smart Form with Predictive Button
```swift
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var formCompletion: Double {
        Double([email, password].filter { !$0.isEmpty }.count) / 2.0
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .padding()
                .refractiveGlass()
            
            SecureField("Password", text: $password)
                .padding()
                .refractiveGlass()
            
            SmartFormButton("Login", completionProbability: formCompletion) {
                print("Login!")
            }
        }
        .padding()
    }
}
```

### Velocity-Aware Interactions
```swift
RefractiveGlassCard {
    Text("Drag me fast!")
        .font(.headline)
        .padding()
}
.smartSprings(sensitivity: 1.2)  // Responds to drag velocity!
```

### Magnetic Pull Effect
```swift
LuxeButton("Hover Near Me", style: .primary) {
    print("Tapped!")
}
.magneticPull(radius: 100, strength: 0.3)  // Tilts toward cursor
```

## Common Patterns

### Dashboard Card
```swift
LuxeCard {
    VStack(alignment: .leading, spacing: 16) {
        HStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.title)
            Spacer()
            LuxeBadge("LIVE", color: .green)
        }
        
        Text("Revenue")
            .font(.headline)
        
        Text("$124,500")
            .font(.system(size: 36, weight: .bold))
        
        HStack {
            Image(systemName: "arrow.up")
            Text("+12.5%")
        }
        .foregroundColor(.green)
    }
    .padding()
}
.frame(width: 300)
```

### Profile Card with Refractive Glass
```swift
RefractiveGlassCard(distortionIntensity: 0.2) {
    VStack(spacing: 16) {
        Circle()
            .fill(Color.purple)
            .frame(width: 80, height: 80)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        
        Text("John Doe")
            .font(.title2.bold())
        
        Text("UI Designer")
            .font(.caption)
            .opacity(0.7)
        
        HStack(spacing: 12) {
            LuxeButton("Follow", style: .primary) { }
            LuxeButton("Message", style: .secondary) { }
        }
    }
    .padding(24)
}
```

## Next Steps

1. **Explore the Demo App**: Run `LuxeUIDemo` to see all features
2. **Read the Guides**:
   - [Refractive Glass Guide](REFRACTIVE_GLASS_GUIDE.md)
   - [Full README](README.md)
3. **Join the Community**: [GitHub Discussions](https://github.com/yourusername/luxeui/discussions)

## Troubleshooting

### Component not appearing?
- Check that you applied `.luxeTheme()` at the root level
- Verify import statement: `import LuxeUI`

### Animations stuttering?
- Ensure you're testing on device/simulator, not preview
- Check system is macOS 12+ / iOS 15+

### Build errors?
- Clean build folder: ⌘⇧K in Xcode
- Update to latest LuxeUI version

## Resources

- [Full Documentation](README.md)
- [API Reference](https://github.com/yourusername/luxeui/wiki)
- [Examples](Examples/README.md)
- [Contributing](CONTRIBUTING.md)

---

Ready to build amazing UIs! 
