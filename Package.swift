// swift-tools-version: 6.1
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "GatheredKit",
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8), .macCatalyst(.v15),
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
        // This could probably go back to 510.0.0 or earlier but it produces a space before the `(`
        // in `private(set)`, which in Swift 6 mode is an error.
        .package(url: "https://github.com/swiftlang/swift-syntax", "600.0.0"..<"602.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GatheredKit",
            exclude: ["README.md"]
        ),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit", "GatheredKitTestHelpers"]),

        .target(
            name: "GatheredKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                "GatheredKit",
                "GatheredKitMacrosMacros",
            ]
        ),
        .macro(
            name: "GatheredKitMacrosMacros",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        .target(name: "GatheredKitCamera", dependencies: ["GatheredKit", "GatheredKitMacros"]),

        .target(name: "GatheredKitDevice", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitExternalAccessory", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitLocation", dependencies: ["GatheredKit", "GatheredKitMacros"]),
        .testTarget(name: "GatheredKitLocationTests", dependencies: ["GatheredKitLocation"]),

        .target(
            name: "GatheredKitMotion",
            dependencies: [
                "GatheredKit",
                "GatheredKitMacros",
            ],
            exclude: ["README.md"]
        ),

        .target(name: "GatheredKitProcessInfo", dependencies: ["GatheredKit"]),

        .target(name: "GatheredKitScreen", dependencies: ["GatheredKit", "GatheredKitMacros"]),
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
