// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "GatheredKitDevelopmentDependencies",
    platforms: [
        .macOS(.v10_10),
    ],
    dependencies: [
        .package(url: "https://github.com/JosephDuffy/xcutils.git", .branch("master")),
        .package(url: "https://github.com/apple/swift-format.git", .exact("0.50400.0")),
    ],
    targets: [
        .target(name: "DevelopmentDependencies"),
    ]
)
