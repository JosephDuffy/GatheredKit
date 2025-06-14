// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "GatheredKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13),
    ],
    products: [
        .library(name: "GatheredKit", targets: ["GatheredKit"]),
        .library(name: "GatheredKitSubscriptions", targets: ["GatheredKitSubscriptions"]),
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
            dependencies: [
                "GatheredKitSubscriptions",
            ],
            exclude: ["README.md"],
            swiftSettings: [
                .unsafeFlags([
                    "-warn-concurrency",
                ]),
            ]
        ),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit", "GatheredKitTestHelpers"]),

        .target(
            name: "GatheredKitSubscriptions",
            swiftSettings: [
                .unsafeFlags([
                    "-warn-concurrency",
                ]),
            ]
        ),
        .testTarget(name: "GatheredKitSubscriptionsTests", dependencies: ["GatheredKitSubscriptions"]),

        .target(
            name: "GatheredKitCamera",
            dependencies: ["GatheredKit"],
            swiftSettings: [
                .unsafeFlags([
                    "-warn-concurrency",
                ])
            ]
        ),

            .target(name: "GatheredKitDevice", dependencies: ["GatheredKit"],
                    swiftSettings: [
                        .unsafeFlags([
                            "-warn-concurrency",
                        ])
                    ]),

            .target(name: "GatheredKitExternalAccessory", dependencies: ["GatheredKit"],
                    swiftSettings: [
                        .unsafeFlags([
                            "-warn-concurrency",
                        ])
                    ]),

            .target(name: "GatheredKitLocation", dependencies: ["GatheredKit"],
                    swiftSettings: [
                        .unsafeFlags([
                            "-warn-concurrency",
                        ])
                    ]),
        .testTarget(name: "GatheredKitLocationTests", dependencies: ["GatheredKitLocation"]),

        .target(
            name: "GatheredKitMotion",
            dependencies: ["GatheredKit"],
            exclude: ["README.md"],
            swiftSettings: [
                .unsafeFlags([
                    "-warn-concurrency",
                ])
            ]
        ),

            .target(name: "GatheredKitProcessInfo", dependencies: ["GatheredKit"],
                    swiftSettings: [
                        .unsafeFlags([
                            "-warn-concurrency",
                        ])
                    ]),

            .target(name: "GatheredKitScreen", dependencies: ["GatheredKit"],
                    swiftSettings: [
                        .unsafeFlags([
                            "-warn-concurrency",
                        ])
                    ]),
        .testTarget(name: "GatheredKitScreenTests", dependencies: ["GatheredKitScreen", "GatheredKitTestHelpers"]),

            .target(name: "GatheredKitSystemStatistics", dependencies: ["GatheredKit"],
                    swiftSettings: [
                        .unsafeFlags([
                            "-warn-concurrency",
                        ])
                    ]),

            .target(name: "GatheredKitTestHelpers", dependencies: ["GatheredKit"],
                    swiftSettings: [
                        .unsafeFlags([
                            "-warn-concurrency",
                        ])
                    ]),

        .target(
            name: "GatheredKitUserTracking",
            dependencies: ["GatheredKit"],
            exclude: ["README.md"],
            swiftSettings: [
                .unsafeFlags([
                    "-warn-concurrency",
                ])
            ]
        ),

        .target(
            name: "GatheredKitWiFi",
            dependencies: ["GatheredKit"],
            exclude: ["CLLocationManager+requestAuthorization.swift"],
            swiftSettings: [
                .unsafeFlags([
                    "-warn-concurrency",
                ])
            ]
        ),
    ]
)
