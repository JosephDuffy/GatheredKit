// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GatheredKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6),
    ],
    products: [
        .library(name: "GatheredKit", targets: ["GatheredKit"]),
        .library(name: "GatheredKitCore", targets: ["GatheredKitCore"]),
        .library(name: "GatheredKitLocation", targets: ["GatheredKitLocation"]),
        .library(name: "GatheredKitMotion", targets: ["GatheredKitMotion"]),
        .library(name: "GatheredKitDevice", targets: ["GatheredKitDevice"]),
    ],
    targets: [
//        .target(name: "GatheredKit", path: "Sources", sources: ["GatheredKitCore", "GatheredKitLocation", "GatheredKitMotion", "GatheredKitDevice"]),
        .target(name: "GatheredKit", dependencies: ["GatheredKitCore", "GatheredKitLocation", "GatheredKitMotion", "GatheredKitDevice"]),
        .target(name: "GatheredKitCore"),
        .target(name: "GatheredKitLocation", dependencies: ["GatheredKitCore"]),
        .target(name: "GatheredKitMotion", dependencies: ["GatheredKitCore"]),
        .target(name: "GatheredKitDevice", dependencies: ["GatheredKitCore"]),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit"]),
    ]
)
