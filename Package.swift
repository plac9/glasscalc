// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GlassCalc",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "GlassCalc",
            targets: ["GlassCalc"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GlassCalc",
            dependencies: [],
            path: "Sources/GlassCalc",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "GlassCalcTests",
            dependencies: ["GlassCalc"],
            path: "Tests/GlassCalcTests"
        )
    ]
)
