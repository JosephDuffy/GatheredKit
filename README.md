![GatheredKit](https://josephduffy.github.io/GatheredKit/img/banner.png)

[![Build Status](https://api.travis-ci.org/JosephDuffy/GatheredKit.svg)](https://travis-ci.org/JosephDuffy/GatheredKit)
[![Documentation](https://josephduffy.github.io/GatheredKit/badge.svg)](https://josephduffy.github.io/GatheredKit/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/GatheredKit.svg)](https://cocoapods.org/pods/GatheredKit)
[![MIT License](https://img.shields.io/badge/License-MIT-4BC51D.svg?style=flat)](./LICENSE)
--

GatheredKit is an iOS framework that provides a consistent and easy to use API for various data sources offered by iOS.

The code originated from [Gathered](https://geo.itunes.apple.com/app/gathered/id929726748?mt=8), hense the name and logo.

## Available Sources

Every source is a class backed by an equivelent Apple-provided class, but with a simplified and consistent API to receive updates. Below is a list of sources that GatheredKit has to offer. Unticked boxes indicate sources that will be added in the future.

 - [ ] WiFi
 - [ ] GPS
 - [ ] Altimeter
 - [ ] Microphone
 - [ ] Cell Radio
 - [X] Screen
 - [ ] Compass
 - [ ] Magnetometer (corrected for device)
 - [ ] Magnetometer (raw)
 - [ ] Gyrometer (corrected for device)
 - [ ] Gyrometer (raw)
 - [ ] Accelerometer (attitude)
 - [ ] Accelerometer (total acceleration)
 - [ ] Accelerometer (gravity acceleration)
 - [ ] Accelerometer (user acceleration)
 - [ ] Accelerometer (raw)
 - [ ] Proximity
 - [ ] Battery
 - [ ] Bluetooth
 - [ ] Storage
 - [ ] Memory
 - [ ] Device Metadata
 - [ ] Battery

## API

GatheredKit aims to provide an intuitive and consistent API without being complex. Updates to the properties of a source can be handled by passing in a closure and retaining an opaque object. When the opaque object is deallocated the closure will also be deallocated.

### `Source`

The core of GatheredKit is the `Source` protocol.

```swift
protocol Source: class {

    typealias UpdateListener = (_ data: [AnySourceProperty]) -> Void

    static var availability: SourceAvailability { get }

    var latestPropertyValues: [AnySourceProperty] { get }

    init()

    func addUpdateListener(_ updateListener: @escaping UpdateListener) -> AnyObject

}
```

No implementations _only_ conform to `Source`, but rather conform to one or more of the protocols that extend `Source`, shown below.

### `AutomaticallyUpdatingSource`

An `AutomaticallyUpdatingSource` is a `Source` that provides data in real-time, such as the user's location and the proximity sensor.

```swift
protocol AutomaticallyUpdatingSource: Source {

    /// A boolean indicating if the source is currently performing automatic updates
    var isUpdating: Bool { get }

    /**
     Start monitoring for changes. This will start delegate methods to be called
     and notifications to be posted
     */
    func startUpdating()

    /**
     Stop automatically updating
     */
    func stopUpdating()

}
```

An extension is provided to start updating and add a listener in a single call:

```swift
func startUpdating(every updateInterval: TimeInterval, updateListener: @escaping UpdateListener) -> AnyObject
```

### `CustomisableUpdateIntervalSource`

A `CustomisableUpdateIntervalSource` is a `Source` that supports customising the update frequency, e.g. the gyroscope

```swift
protocol CustomisableUpdateIntervalSource: Source {

    /// The time interval between property updates. A value of `nil` indicates that
    /// the source is not performing periodic updates
    var updateInterval: TimeInterval? { get }

    /// A boolean indicating if the source is performing period updates every `updateInterval`
    var isUpdating: Bool { get }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds

     - parameter updateInterval: The interval between updates, measured in seconds
     */
    func startUpdating(every updateInterval: TimeInterval)

    /**
     Stop performing periodic updates
     */
    func stopUpdating()

}
```

An extension is provided to start updating and add a listener in a single call:

```swift
func startUpdating(_ updateListener: @escaping UpdateListener) -> AnyObject
```

### `ManuallyUpdatableSource`

A `ManuallyUpdatableSource` is a `Source` that can only be manually updated. `ManuallyUpdatableSource` extends `CustomisableUpdateIntervalSource`, meaning all `ManuallyUpdatableSource`s at least support updating via polling.

```swift
protocol ManuallyUpdatableSource: CustomisableUpdateIntervalSource {

    /**
     Force the source to update its properties. Note that there is no guarantee that new data
     will be available

     - returns: The property values after the update
     */
    func updateProperties() -> [AnySourceProperty]

}
```

## Installation

GatheredKit can be installed using any of the below methods. Once installed, simply `import GatheredKit` to start using it.

### Carthage

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

### CocoaPods

To install via [CocoaPods](https://cocoapods.org) add the following line to your Podfile:

```ruby
pod 'GatheredKit'
```

and then run `pod install`.

## Documentation

Documentation for GatheredKit is provided in the source code. Browsable documentation is available at [https://josephduffy.github.io/GatheredKit/](https://josephduffy.github.io/GatheredKit/).

## Tests

Running the tests for GatheredKit requires `Quick` and `Nimble`, which can be installed using Carthage:

`carthage build --platform iOS --no-use-binaries`

Tests can be run via Xcode or `fastlane test`.

## License

The project is released under the MIT license. View the [LICENSE](./LICENSE) file for the full license.
