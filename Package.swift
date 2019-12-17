// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GatheredKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13),
    ],
    products: [
        .library(name: "GatheredKit", targets: ["GatheredKit"]),
    ],
    targets: [
        .target(name: "GatheredKit"),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit"]),
    ]
)
