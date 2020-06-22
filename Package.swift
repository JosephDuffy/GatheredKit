// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "GatheredKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v12), .tvOS(.v12), .watchOS(.v5),
    ],
    products: [
        .library(name: "GatheredKit", targets: ["GatheredKit"]),
        .library(name: "GatheredKitCore", targets: ["GatheredKitCore"]),
        .library(name: "GatheredKitLocation", targets: ["GatheredKitLocation"]),
        .library(name: "GatheredKitMotion", targets: ["GatheredKitMotion"]),
        .library(name: "GatheredKitScreen", targets: ["GatheredKitScreen"]),
        .library(name: "GatheredKitTestHelpers", targets: ["GatheredKitTestHelpers"]),
    ],
    targets: [
        .target(name: "GatheredKit", dependencies: ["GatheredKitCore", "GatheredKitLocation", "GatheredKitScreen"]),

        .target(name: "GatheredKitCore"),
        .testTarget(name: "GatheredKitCoreTests", dependencies: ["GatheredKitCore", "GatheredKitTestHelpers"]),

        .target(name: "GatheredKitLocation", dependencies: ["GatheredKitCore"]),
        .testTarget(name: "GatheredKitLocationTests", dependencies: ["GatheredKitLocation"]),

        .target(name: "GatheredKitMotion", dependencies: ["GatheredKitCore"]),

        .target(name: "GatheredKitScreen", dependencies: ["GatheredKitCore"]),
        .testTarget(name: "GatheredKitScreenTests", dependencies: ["GatheredKitScreen", "GatheredKitTestHelpers"]),

        .target(name: "GatheredKitTestHelpers", dependencies: ["GatheredKitCore"]),
    ]
)
