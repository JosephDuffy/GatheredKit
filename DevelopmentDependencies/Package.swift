// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "GatheredKitDevelopmentDependencies",
    platforms: [
        .macOS(.v10_10),
    ],
    dependencies: [
        .package(url: "https://github.com/JosephDuffy/xcutils.git", .branch("master")),
        .package(url: "https://github.com/apple/swift-format.git", .branch("swift-5.2-branch")),
    ],
    targets: [
        .target(name: "DevelopmentDependencies"),
    ]
)
