![GatheredKit](https://josephduffy.github.io/GatheredKit/img/banner.png)

[![Tests Status](https://github.com/JosephDuffy/GatheredKit/workflows/Tests/badge.svg)](https://launch-editor.github.com/actions?workflowID=Tests&event=push&nwo=JosephDuffy%2FGatheredKit)
[![codecov](https://codecov.io/gh/JosephDuffy/GatheredKit/branch/main/graph/badge.svg)](https://codecov.io/gh/JosephDuffy/GatheredKit)
![Compatible with macOS, iOS, watchOS, and tvOS](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS%20-4BC51D.svg)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![MIT License](https://img.shields.io/badge/License-MIT-4BC51D.svg?style=flat)](./LICENSE)
--

> :warning: GatheredKit it currently in a pre-release beta. The API is unstable, although the only large planned breaking fix is to introduce structured concurrency for thread safety.

GatheredKit a consistent protocol-oriented API for various data sources offered by macOS, iOS, watchOS, and tvOS.

The code originated from [Gathered](https://geo.itunes.apple.com/app/gathered/id929726748?mt=8), hence the name and logo. Prior to version 2.0 Gathered used a closed-source version of GatheredKit. [Version 2.0 is currently in beta and can accessed via TestFlight](https://testflight.apple.com/join/gsVcyywY).

[Documentation is available online](https://swiftpackageindex.com/josephduffy/gatheredkit/main/documentation/gatheredkit). This documentation is compiled against iOS. This doesn't quite cover all symbols in the project so please checkout the project to view documentation for other platforms.

# Features

- Consistent API between types
  - Updating properties are marked `@Published`
  - Where reasonable, types have the same properties across platforms, using `@available` to mark properties as unavailable on some platforms
- Protocol-oriented API
  - The Gathered app is protocol-driven, enabling the private packages to only depend on `GatheredKit`, enabling support for recording and remote sources of unknown types
- Batteries included
  - Core library provides many types to help make new sources easily, such as properties for common types
- Localised
  - Currently localisation is only provided for British English. Contributions are welcome!

# Provided Libraries

The core library, [`GatheredKit`](./Sources/GatheredKit/README.md), provides the protocols used by the other libraries, along with various convenience types such as `BasicProperty`.

The remaining libraries each provide one or more data sources. This is done to allow the a subset of the data sources to be included, which aids with documentation, discovery, and prevents accidentally include APIs that require extra permissions, such as accessing the IDFA.

Each of these libraries roughly correlates to one of Apple's frameworks.

## [`GatheredKitCamera`](./Sources/GatheredKitCamera/README.md)

`GatheredKitCamera` provides access to cameras, both built-in and external. The `CameraProvider` can be used to query for connected cameras. It wraps the [`AVFoundation` framework](https://developer.apple.com/documentation/avfoundation/).

## [`GatheredKitDevice`](./Sources/GatheredKitDevice/README.md)

`GatheredKitDevice` provides various sources relating to the current device.

On iOS this wraps the [`UIKit` framework](https://developer.apple.com/documentation/uikit/), specifically [`UIDevice`](https://developer.apple.com/documentation/uikit/uidevice).

## [`GatheredKitLocation`](./Sources/GatheredKitLocation/README.md)

`GatheredKitLocation` provides the `Location` data source, which is used to access location-based information provided by the GPS and associated sensors. It relies on the [Core Location framework](https://developer.apple.com/documentation/corelocation).

## `GatheredKitMotion`

`GatheredKitMotion` provides data sources that utilise the `CoreMotion` framework, such as an `Accelerometer`, `Gyroscope`, and `Magnetometer`.

## [`GatheredKitProcessInfo`](./Sources/GatheredKitProcessInfo/README.md)

`GatheredKitProcessInfo` provides information relating to the computer the process is running on.

## `GatheredKitScreen`

`GatheredKitScreen` provides access to the screens associated with the device.

## Future Libraries

Below are the sources that are available in the Gathered app but have not yet been added to this open source project.

- [ ] Compass
- [ ] Microphone
- [ ] Cell Radio
- [ ] Device Attitude
- [ ] Proximity
- [ ] Audio Output
- [ ] Device Orientation
- [ ] Bluetooth
- [ ] Storage
- [ ] Memory
- [ ] Device Metadata
- [ ] Operating System
- [ ] CPU

# Installation

## SwiftPM

To install via [SwiftPM](https://github.com/apple/swift-package-manager) add the package to the dependencies section and as the dependency of a target:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/JosephDuffy/GatheredKit.git", branch: "main"),
    ],
    targets: [
        .target(name: "MyApp", dependencies: ["GatheredKit"]),
    ],
    ...
)
```

# License

The project is released under the MIT license. View the [LICENSE](./LICENSE) file for the full license.
