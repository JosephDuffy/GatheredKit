# API

GatheredKit aims to provide an intuitive and consistent API without being complex. Updates to the properties of a source can be handled by passing in a closure and retaining an opaque object. When the opaque object is deallocated the closure will also be deallocated.

## `Source`

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

## `AutomaticallyUpdatingSource`

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

## `CustomisableUpdateIntervalSource`

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

## `ManuallyUpdatableSource`

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

## Carthage

To install via Carthage add to following to your `Cartfile`:

```
github "JosephDuffy/GatheredKit"
```

Run `carthage update GatheredKit` to build the framework and then drag the built framework file in to your Xcode project.

If you plan to submit an app to Apple that uses GatheredKit, remember to add GatheredKit to your [script build phase to work around an App Store Submission bug](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos):

```
$(SRCROOT)/Carthage/Build/iOS/GatheredKit.framework
```

and

```
$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/GatheredKit.framework
```

## Tests

Running the tests for GatheredKit requires `Quick` and `Nimble`, which can be installed using Carthage:

`carthage build --platform iOS --no-use-binaries`

Alternatively running `fastlane test` will install the dependencies and run the tests.

## License

The project is released under the MIT license. View the [LICENSE](./LICENSE) file for the full license.
