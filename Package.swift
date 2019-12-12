// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "GatheredKit",
    platforms: [
        .macOS(.v10_12), .iOS(.v10),
    ],
    products: [
        .library(name: "GatheredKit", targets: ["GatheredKit"]),
    ],
    targets: [
        .target(name: "GatheredKit"),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit"]),
    ],
    swiftLanguageVersions: [.v5]
)
