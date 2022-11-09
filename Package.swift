// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "GatheredKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13),
    ],
    products: [
        .library(name: "GatheredKit", targets: ["GatheredKit"]),
        .library(name: "GatheredKitCamera", targets: ["GatheredKitCamera"]),
        .library(name: "GatheredKitDevice", targets: ["GatheredKitDevice"]),
        .library(name: "GatheredKitExternalAccessory", targets: ["GatheredKitExternalAccessory"]),
        .library(name: "GatheredKitLocation", targets: ["GatheredKitLocation"]),
        .library(name: "GatheredKitMotion", targets: ["GatheredKitMotion"]),
        .library(name: "GatheredKitProcessInfo", targets: ["GatheredKitProcessInfo"]),
        .library(name: "GatheredKitScreen", targets: ["GatheredKitScreen"]),
        .library(name: "GatheredKitSystemStatistics", targets: ["GatheredKitSystemStatistics"]),
        .library(name: "GatheredKitTestHelpers", targets: ["GatheredKitTestHelpers"]),
        .library(name: "GatheredKitUserTracking", targets: ["GatheredKitUserTracking"]),
        .library(name: "GatheredKitWiFi", targets: ["GatheredKitWiFi"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", exact: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GatheredKit",
            exclude: ["README.md"]
        ),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit", "GatheredKitTestHelpers"]),

        .target(name: "GatheredKitCamera", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitDevice", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitExternalAccessory", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitLocation", dependencies: ["GatheredKit"]),
        .testTarget(name: "GatheredKitLocationTests", dependencies: ["GatheredKitLocation"]),

        .target(
            name: "GatheredKitMotion",
            dependencies: ["GatheredKit"],
            exclude: ["README.md"]
        ),

        .target(name: "GatheredKitProcessInfo", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitScreen", dependencies: ["GatheredKit"]),
        .testTarget(name: "GatheredKitScreenTests", dependencies: ["GatheredKitScreen", "GatheredKitTestHelpers"]),

        .target(name: "GatheredKitSystemStatistics", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitTestHelpers", dependencies: ["GatheredKit"]),

        .target(
            name: "GatheredKitUserTracking",
            dependencies: ["GatheredKit"],
            exclude: ["README.md"]
        ),

        .target(
            name: "GatheredKitWiFi",
            dependencies: ["GatheredKit"],
            exclude: ["CLLocationManager+requestAuthorization.swift"]
        ),
    ]
)
