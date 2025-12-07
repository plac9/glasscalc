// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrismCalc",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "PrismCalc",
            targets: ["PrismCalc"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PrismCalc",
            dependencies: [],
            path: "Sources/PrismCalc",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "PrismCalcTests",
            dependencies: ["PrismCalc"],
            path: "Tests/PrismCalcTests"
        )
    ]
)
