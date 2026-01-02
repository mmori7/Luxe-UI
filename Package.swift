// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LuxeUI",
    platforms: [
        .iOS(.v15),   // Enables SwiftUI features
        .macOS(.v12)
    ],
    products: [
        .library(name: "LuxeUI", targets: ["LuxeUI"]),
    ],
    targets: [
        .target(
            name: "LuxeUI",
            dependencies: []
        ),
        .testTarget(
            name: "LuxeUITests",
            dependencies: ["LuxeUI"]
        ),
    ]
)