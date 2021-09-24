![GatheredKit](https://josephduffy.github.io/GatheredKit/img/banner.png)

[![Tests Status](https://github.com/JosephDuffy/GatheredKit/workflows/Tests/badge.svg)](https://launch-editor.github.com/actions?workflowID=Tests&event=push&nwo=JosephDuffy%2FGatheredKit)
[![codecov](https://codecov.io/gh/JosephDuffy/GatheredKit/branch/master/graph/badge.svg)](https://codecov.io/gh/JosephDuffy/GatheredKit)
[![Documentation](https://josephduffy.github.io/GatheredKit/badge.svg)](https://josephduffy.github.io/GatheredKit/)
![Compatible with macOS, iOS, watchOS, and tvOS](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS%20-4BC51D.svg)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![MIT License](https://img.shields.io/badge/License-MIT-4BC51D.svg?style=flat)](./LICENSE)
--

GatheredKit a protocol-based API for various data sources offered by macOS, iOS, watchOS, and tvOS.

The code originated from [Gathered](https://geo.itunes.apple.com/app/gathered/id929726748?mt=8), hence the name and logo.

# Provided Libraries

GatheredKit provides multiple libraries that each provide one or more data sources. This is done to allow the a subset of the data sources to be included, which both reduced bloat and ensures that consumers do not accidentally include APIs that require extra permissions, such as accessing the IDFA.

## [`GatheredKit`](./Sources/GatheredKit/README.md)

The `GatheredKit` library is the core library that provides the types used by data source, but it does not provide any of the data sources itself.

## `GatheredKitLocation`

`GatheredKitLocation` provides the `Location` data source.

## `GatheredKitMotion`

`GatheredKitMotion` provides data sources that utilise the `CoreMotion` framework, such as an `Accelerometer`, `Gyroscope`, and `Magnetometer`.

## `GatheredKitScreen`

`GatheredKitScreen` provides access to the screens associated with the device.

## Future Libraries

Below are the sources that are available in the Gathered app but have not yet been added to this open source project.

- [ ] Compass
- [ ] Wi-Fi
- [ ] Altimeter
- [ ] Microphone
- [ ] Cell Radio
- [ ] Device Attitude
- [ ] Proximity
- [ ] Battery
- [ ] Advertising
- [ ] Audio Output
- [ ] Device Orientation
- [ ] Bluetooth
- [ ] Storage
- [ ] Memory
- [ ] Device Metadata
- [ ] Operating System
- [ ] CPU
- [ ] Cameras
- [ ] Battery

# Installation

## SwiftPM

To install via [SwiftPM](https://github.com/apple/swift-package-manager) add the package to the dependencies section and as the dependency of a target:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/JosephDuffy/GatheredKit.git", from: "0.1.0"),
    ],
    targets: [
        .target(name: "MyApp", dependencies: ["GatheredKit"]),
    ],
    ...
)
```

# Documentation

Documentation for GatheredKit is provided in the source code. Browsable documentation is available at [https://josephduffy.github.io/GatheredKit/](https://josephduffy.github.io/GatheredKit/).

# License

The project is released under the MIT license. View the [LICENSE](./LICENSE) file for the full license.
