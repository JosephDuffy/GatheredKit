// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "GatheredKitDevelopmentDependencies",
    platforms: [
        .macOS(.v10_12),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.41.2"),
        .package(url: "https://github.com/JosephDuffy/xcutils.git", .branch("master")),
    ],
    targets: [
        .target(name: "DevelopmentDependencies", path: ""),
    ]
)
