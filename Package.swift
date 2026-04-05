// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CompassUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CompassUI",
            targets: ["CompassUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.0"),
    ],
    targets: [
        .target(
            name: "CompassUI",
            swiftSettings: [
                .enableExperimentalFeature("ApproachableConcurrency"),
                .defaultIsolation(MainActor.self),
                .swiftLanguageMode(.v6)
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "CompassUITests",
            dependencies: ["CompassUI"],
            swiftSettings: [
                .enableExperimentalFeature("ApproachableConcurrency"),
                .defaultIsolation(MainActor.self),
                .swiftLanguageMode(.v6)
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
