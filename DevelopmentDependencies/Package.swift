// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "GatheredKitDevelopmentDependencies",
    platforms: [
        .macOS(.v10_10),
    ],
    dependencies: [
        .package(name: "SwiftLint", url: "https://github.com/Realm/SwiftLint", .upToNextMinor(from: "0.39.0")),
        .package(url: "https://github.com/JosephDuffy/xcutils.git", .branch("master")),
    ],
    targets: [
        .target(name: "DevelopmentDependencies"),
    ]
)
