![GatheredKit](https://josephduffy.github.io/GatheredKit/img/banner.png)

[![Tests Status](https://github.com/JosephDuffy/GatheredKit/workflows/Tests/badge.svg)](https://launch-editor.github.com/actions?workflowID=Tests&event=push&nwo=JosephDuffy%2FGatheredKit)
[![codecov](https://codecov.io/gh/JosephDuffy/GatheredKit/branch/master/graph/badge.svg)](https://codecov.io/gh/JosephDuffy/GatheredKit)
[![Documentation](https://josephduffy.github.io/GatheredKit/badge.svg)](https://josephduffy.github.io/GatheredKit/)
![Compatible with macOS, iOS, watchOS, and tvOS](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS%20-4BC51D.svg)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![MIT License](https://img.shields.io/badge/License-MIT-4BC51D.svg?style=flat)](./LICENSE)
--

GatheredKit is an Swift Package that provides a consistent API for various data sources offered by macOS, iOS, watchOS, and tvOS.

The code originated from [Gathered](https://geo.itunes.apple.com/app/gathered/id929726748?mt=8), hence the name and logo.

# Quick Links

- [Available Sources](#available-sources)
- [API](#api)
- [Installation](#installation)
- [Documentation](#documentation)
- [Running Tests](#running-tests)
- [License](#license)

# Available Sources

Every source is a class backed by an equivalent Apple-provided class, but with a simplified and consistent API to receive updates. Below is a list of sources that GatheredKit has to offer. Unticked boxes indicate sources that will be added in the future.

- [x] Location
- [ ] Compass
- [ ] Wi-Fi
- [ ] Altimeter
- [ ] Microphone
- [ ] Cell Radio
- [x] Screen
- [x] Magnetometer
- [x] Gyroscope
- [x] Accelerometer
- [x] Device Motion
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

# API

GatheredKit aims to abstract away the specifics of the various iOS frameworks used to create the sources by wrapping them in an intuitive and consistent API.

## `Source`

The core of GatheredKit is the `Source` protocol.

```swift
/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: ValuesProvider {

    /// The availability of the source
    static var availability: SourceAvailability { get }

    /// A user-friendly name that represents the source, e.g. "Location", "Device Attitude"
    static var name: String { get }

}
```

This by itself doesn't provide much, but when combined with `ValuesProvider` it forms the base of all classes in GatheredKit.

## `ValuesProvider`

```swift
/**
 An object that provides values
 */
public protocol ValuesProvider: PropertiesProvider {

    /// An array of all the values provided by this object
    var allValues: [Value] { get }

}
```

Implementations also have individual properties for each of the properties they offer, such as the `brightness` property of the `Screen` source.

## `Controllable`

The `Controllable` protocol defines an object that can automatically update its properties. These automatic changes can be started and stopped at any time.

```swift
/**
 An object that be started and stopped
 */
public protocol Controllable: class {

    /// A boolean indicating if the `Controllable` is currently performing automatic updates
    var isUpdating: Bool { get }

    /**
     Starts automatic updates. Closures added via `addUpdateListener(_:)` will be
     called when new properties are available
     */
    func startUpdating()

    /**
     Stops automatic updates
     */
    func stopUpdating()

}
```

## `CustomisableUpdateIntervalControllable`

`CustomisableUpdateIntervalControllable` is a `Controllable` that has one or more values that must be polled for updates.

```swift
/**
 A source that supports updating its properties at a given time interval
 */
public protocol CustomisableUpdateIntervalControllable: Controllable {

    /// The default update interval that will be used when calling `startUpdating()`
    /// without specifying the update interval.
    /// This value is unique per-source and does not persist between app runs
    static var defaultUpdateInterval: TimeInterval { get set }

    /// The time interval between property updates. A value of `nil` indicates that
    /// the source is not performing periodic updates
    var updateInterval: TimeInterval? { get }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds

     - parameter updateInterval: The interval between updates, measured in seconds
     */
    func startUpdating(every updateInterval: TimeInterval)

}
```

## `ManuallyUpdatableValuesProvider`

A `ManuallyUpdatableValuesProvider` is a `ValuesProvider` that can be manually updated by calling the `updateValues` function.

```swift
/**
 A property provider that supports its properties being updated at any given time.
 */
public protocol ManuallyUpdatablePropertiesProvider: PropertiesProvider {

    /**
     Force the properties provider to update its properties.

     Note that there is no guarantee that the returned properties will be new, even
     if the date has updated.

     - Returns: The properties after the update.
     */
    func updateValues() -> [AnyProperty]

}

```

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

## Carthage

To install via [Carthage](https://github.com/Carthage/Carthage) add to following to your `Cartfile`:

```
github "JosephDuffy/GatheredKit"
```

Run `carthage update GatheredKit` to build the framework and then drag the built framework file in to your Xcode project. GatheredKit provides pre-compiled binaries, [which can cause some issues with symbols](https://github.com/Carthage/Carthage#dwarfs-symbol-problem). Use the `--no-use-binaries` flag if this is an issue.

Remember to [add GatheredKit to your Carthage build phase](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos):

```
$(SRCROOT)/Carthage/Build/iOS/GatheredKit.framework
```

and

```
$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/GatheredKit.framework
```

## CocoaPods

To install via [CocoaPods](https://cocoapods.org) add the following to your Podfile:

```ruby
pod 'GatheredKit'
```

and then run `pod install`.

# Running Tests

Running the tests for GatheredKit requires `Quick` and `Nimble`, which can be installed using Carthage:

```bash
carthage build --platform iOS --no-use-binaries
```

Tests can be run via Xcode or `fastlane test`.

# License

The project is released under the MIT license. View the [LICENSE](./LICENSE) file for the full license.
