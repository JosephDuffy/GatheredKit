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
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "2.0.0"), // dev
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.0"), // dev
    ],
    targets: [
        .target(name: "GatheredKit"),
        .testTarget(name: "GatheredKitTests", dependencies: ["GatheredKit", "Quick", "Nimble"]), // dev
    ],
    swiftLanguageVersions: [.v5]
)
