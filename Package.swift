// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "GatheredKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v12), .tvOS(.v12), .watchOS(.v5),
    ],
    products: [
        .library(name: "GatheredKit", targets: ["GatheredKit"]),
        .library(name: "GatheredKitLocation", targets: ["GatheredKitLocation"]),
        .library(name: "GatheredKitMotion", targets: ["GatheredKitMotion"]),
        .library(name: "GatheredKitScreen", targets: ["GatheredKitScreen"]),
        .library(name: "GatheredKitTestHelpers", targets: ["GatheredKitTestHelpers"]),
    ],
    targets: [
        .target(name: "GatheredKit"),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit", "GatheredKitTestHelpers"]),

        .target(name: "GatheredKitLocation", dependencies: ["GatheredKit"]),
        .testTarget(name: "GatheredKitLocationTests", dependencies: ["GatheredKitLocation"]),

        .target(name: "GatheredKitMotion", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitScreen", dependencies: ["GatheredKit"]),
        .testTarget(name: "GatheredKitScreenTests", dependencies: ["GatheredKitScreen", "GatheredKitTestHelpers"]),

        .target(name: "GatheredKitTestHelpers", dependencies: ["GatheredKit"]),
    ]
)
