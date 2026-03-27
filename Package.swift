// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NavigationLibrary",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "NavigationLibrary",
            targets: ["NavigationLibrary"]
        ),
    ],
    targets: [
        .target(
            name: "NavigationLibrary"
        ),
        .testTarget(
            name: "NavigationLibraryTests",
            dependencies: ["NavigationLibrary"]
        ),
    ]
)
