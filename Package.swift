// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swift-screenshot-scribbler",
    products: [
        .executable(name: "scrscr", targets: ["ScreenshotScribblerCLI"]),
        .library(name: "ScreenshotScribbler", targets: ["ScreenshotScribbler"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "ScreenshotScribblerCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ScreenshotScribbler",
            ]),
        .target(
            name: "ScreenshotScribbler",
            dependencies: []),
        .testTarget(
            name: "ScreenshotScribblerTests",
            dependencies: ["ScreenshotScribbler"]),
    ]
)
