// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CompassUI",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CompassUI",
            targets: ["CompassUI"]
        ),
    ],
    targets: [
        .target(
            name: "CompassUI"
        ),
        .testTarget(
            name: "CompassUITests",
            dependencies: ["CompassUI"]
        ),
    ]
)
