![GatheredKit](https://josephduffy.github.io/GatheredKit/img/banner.png)

[![Build Status](https://api.travis-ci.com/JosephDuffy/GatheredKit.svg)](https://travis-ci.com/JosephDuffy/GatheredKit)
[![Documentation](https://josephduffy.github.io/GatheredKit/badge.svg)](https://josephduffy.github.io/GatheredKit/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/GatheredKit.svg)](https://cocoapods.org/pods/GatheredKit)
[![MIT License](https://img.shields.io/badge/License-MIT-4BC51D.svg?style=flat)](./LICENSE)
--

GatheredKit is an iOS framework that provides a consistent and easy to use API for various data sources offered by iOS.

The code originated from [Gathered](https://geo.itunes.apple.com/app/gathered/id929726748?mt=8), hense the name and logo.

# Quick Links

 - [Available Sources](#available-sources)
 - [API](#api)
 - [Installation](#installation)
 - [Documentation](#documentation)
 - [Running Tests](#running-tests)
 - [License](#license)

# Available Sources

Every source is a class backed by an equivelent Apple-provided class, but with a simplified and consistent API to receive updates. Below is a list of sources that GatheredKit has to offer. Unticked boxes indicate sources that will be added in the future.

 - [X] Location
 - [X] Wi-Fi
 - [X] Altimeter
 - [ ] Microphone
 - [X] Cell Radio
 - [X] Screen
 - [X] Compass
 - [X] Magnetometer
 - [X] Gyroscope
 - [X] Accelerometer
 - [X] Device Attitude
 - [X] Proximity
 - [X] Battery
 - [X] Advertising
 - [X] Audio Output
 - [X] Device Orientation
 - [X] Bluetooth
 - [X] Storage
 - [X] Memory
 - [X] Device Metadata
 - [X] Operating System
 - [X] CPU
 - [X] Cameras
 - [X] Battery

# API

GatheredKit aims to abstract away the specifics of the various iOS frameworks used to create the sources by wrapping them in an intuitive and consistent API.

## `Source`

The core of GatheredKit is the `Source` protocol.

```swift
/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: class, ValuesProvider {

    /// The availability of the source
    static var availability: SourceAvailability { get }

    /// A user-friendly name that represents the source, e.g. "Location", "Device Attitude"
    static var name: String { get }

    /// Creates a new instance of the source
    init()

}
```

This by itself doesn't provide much, but when combined with `ValuesProvider` it forms the base of all classes in GatheredKit.

## `ValuesProvider`

```swift
/**
 An object that provides values
 */
public protocol ValuesProvider {

    /// An array of all the values provided by this object
    var allValues: [Value] { get }

}
```

Implementations also have individual properties for each of their values, such as the `brightness` property of the `Screen` source.

## `Controllable`

The `Controllable` protocol defines an object that can automatically update its values. These automatic changes can be started and stopped at any time.

```swift
/**
 An object that be started and stopped
 */
public protocol Controllable: class {

    /// A closure that will be called with the latest values
    typealias UpdateListener = (_ latestValues: [Value]) -> Void

    /// A boolean indicating if the `Controllable` is currently performing automatic updates
    var isUpdating: Bool { get }

    /**
     Starts automatic updates. Closures added via `addUpdateListener(_:)` will be
     called when new values are available
     */
    func startUpdating()

    /**
     Stops automatic updates
     */
    func stopUpdating()

    /**
     Adds a closure to the array of closures that will be called when any of the source's
     values are updated. The closure will be called with all values, but not all the values
     will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateListener: The closure to call with updated values
     - parameter queue: The dispatch queue the listener should be called from
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func addUpdateListener(_ updateListener: @escaping UpdateListener, queue: DispatchQueue) -> AnyObject

}

public extension Controllable {

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the source's values are updated. The closure will be called with all values, but
     not all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter queue: The dispatch queue the listener should be called from
     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func startUpdating(sendingUpdatesOn queue: DispatchQueue, to updateListener: @escaping UpdateListener) -> AnyObject

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the source's values are updated. The closure will be called on the main dispatch queue with
     all values, but not all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func startUpdating(sendingUpdatesTo updateListener: @escaping UpdateListener) -> AnyObject

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

public extension CustomisableUpdateIntervalControllable {

    /// A boolean indicating if the source is currently updating its properties every `updateInterval`
    public var isUpdating: Bool

    /**
     Starts performing period updated. The value of the static variable `defaultUpdateInterval` will
     used for the update interval.
     */
    public func startUpdating()

    /**
     Start performing periodic updates, updating every `updateInterval` seconds.

     The passed closure will be added to the array of closures that will be called when any
     of the source's values are updated. The closure will be called with all values, but not
     all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateInterval: The interval between updates, measured in seconds
     - parameter queue: The dispatch queue the listener should be called from
     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    public func startUpdating(every updateInterval: TimeInterval, sendingUpdatesOn queue: DispatchQueue, to updateListener: @escaping UpdateListener) -> AnyObject

}
```

## `ManuallyUpdatableValuesProvider`

A `ManuallyUpdatableValuesProvider` is a `ValuesProvider` that can be manually updated by calling the `updateValues` function.

```swift
/**
 A source that supports its properties being updated at any given time
 */
public protocol ManuallyUpdatableValuesProvider: ValuesProvider {

    /**
     Force the values provider to update its values.

     Note that there is no guarantee that the returned values will be new, even
     if the date has updated

     - returns: The values after the update
     */
    func updateValues() -> [Value]

}
```

# Installation

GatheredKit can be installed using any of the below methods. Once installed, simply `import GatheredKit` to start using it.

## Carthage

To install via Carthage add to following to your `Cartfile`:

```
github "JosephDuffy/GatheredKit"
```

Run `carthage update GatheredKit --platform iOS` to build the framework and then drag the built framework file in to your Xcode project. GatheredKit provides pre-compiled binaries, [which can cause some issues with symbols](https://github.com/Carthage/Carthage#dwarfs-symbol-problem). Use the `--no-use-binaries` flag if this is an issue.

Remember to [add GatheredKit to your Carthage build phase](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos):

```
$(SRCROOT)/Carthage/Build/iOS/GatheredKit.framework
```

and

```
$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/GatheredKit.framework
```

## CocoaPods

To install via [CocoaPods](https://cocoapods.org) add the following line to your Podfile:

```ruby
pod 'GatheredKit'
```

and then run `pod install`.

# Documentation

Documentation for GatheredKit is provided in the source code. Browsable documentation is available at [https://josephduffy.github.io/GatheredKit/](https://josephduffy.github.io/GatheredKit/).

# Running Tests

Running the tests for GatheredKit requires `Quick` and `Nimble`, which can be installed using Carthage:

```bash
carthage build --platform iOS --no-use-binaries
```

Tests can be run via Xcode or `fastlane test`.

# License

The project is released under the MIT license. View the [LICENSE](./LICENSE) file for the full license.
