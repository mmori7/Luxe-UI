# LuxeUI Examples

This directory contains example projects demonstrating LuxeUI capabilities.

## Available Examples

### 1. Complete Showcase (`LuxeUIDemo`)
Located in the parent directory, this demonstrates all LuxeUI features:
- Refractive glass effects
- Smart springs and magnetic pull
- Predictive layouts
- All premium components
- Interactive demos

To run:
```bash
cd ../LuxeUIDemo
open Package.swift
# Press ⌘R in Xcode
```

### 2. Minimal Example

Create a minimal SwiftUI app:

```swift
import SwiftUI
import LuxeUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .luxeTheme(.midnight)
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            MeshGradientBackground()
            
            VStack(spacing: 24) {
                RefractiveGlassCard {
                    VStack {
                        Image(systemName: "sparkles")
                            .font(.largeTitle)
                        Text("Hello, LuxeUI!")
                            .font(.title)
                    }
                    .padding()
                }
                .frame(width: 300, height: 200)
                
                LuxeButton("Get Started", style: .primary) {
                    print("Tapped!")
                }
            }
        }
    }
}
```

### 3. Form Example

```swift
struct FormExample: View {
    @State private var email = ""
    @State private var password = ""
    
    var completion: Double {
        Double([email, password].filter { !$0.isEmpty }.count) / 2.0
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textFieldStyle(.plain)
                .padding()
                .refractiveGlass()
            
            SecureField("Password", text: $password)
                .textFieldStyle(.plain)
                .padding()
                .refractiveGlass()
            
            SmartFormButton("Login", completionProbability: completion) {
                print("Login tapped")
            }
        }
        .padding()
        .luxeTheme(.midnight)
    }
}
```

## More Examples

Check out our [documentation](../README.md) for more code examples and the [Refractive Glass Guide](../REFRACTIVE_GLASS_GUIDE.md) for advanced effects.
