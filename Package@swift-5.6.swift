// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "GatheredKit",
    defaultLocalization: "en-gb",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6),
    ],
    products: [
        .library(name: "GatheredKit", targets: ["GatheredKit"]),
        .library(name: "GatheredKitCamera", targets: ["GatheredKitCamera"]),
        .library(name: "GatheredKitLocation", targets: ["GatheredKitLocation"]),
        .library(name: "GatheredKitMotion", targets: ["GatheredKitMotion"]),
        .library(name: "GatheredKitProcessInfo", targets: ["GatheredKitProcessInfo"]),
        .library(name: "GatheredKitScreen", targets: ["GatheredKitScreen"]),
        .library(name: "GatheredKitTestHelpers", targets: ["GatheredKitTestHelpers"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", exact: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GatheredKit",
            exclude: ["README.md"]
        ),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit", "GatheredKitTestHelpers"]),

        .target(name: "GatheredKitCamera", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitLocation", dependencies: ["GatheredKit"]),
        .testTarget(name: "GatheredKitLocationTests", dependencies: ["GatheredKitLocation"]),

        .target(
            name: "GatheredKitMotion",
            dependencies: ["GatheredKit"],
            exclude: ["README.md"]
        ),
        .testTarget(name: "GatheredKitMotionTests", dependencies: ["GatheredKitMotion"]),

            .target(name: "GatheredKitProcessInfo", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitScreen", dependencies: ["GatheredKit"]),
        .testTarget(name: "GatheredKitScreenTests", dependencies: ["GatheredKitScreen", "GatheredKitTestHelpers"]),

        .target(name: "GatheredKitTestHelpers", dependencies: ["GatheredKit"]),
    ]
)
