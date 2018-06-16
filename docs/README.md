# API

GatheredKit aims to abstract away the specifics of the various iOS frameworks used to create the sources by wrapping them in an intuitive and consistent API.

## `Source`

The core of GatheredKit is the `Source` protocol.

```swift
/**
 An object that can provide data from a specific source on the device
 */
public protocol Source : AnyObject, ValuesProvider {

    /// A closure that will be called with the latest values
    public typealias UpdateListener = (_ latestValues: [AnyValue]) -> Void

    /// The availability of the source
    public static var availability: SourceAvailability { get }

    /// A boolean indicating if the source is currently performing automatic updates
    public var isUpdating: Bool { get }

    /// Creates a new instance of the source
    public init()

    /**
     Adds a closure to the array of closures that will be called when any of the source's
     values are updated. The closure will be called with all values, but not all the values
     will neccessary be new.
     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.
     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    public func addUpdateListener(_ updateListener: @escaping UpdateListener) -> AnyObject

    /**
     Starts automatic updates. Closures added via `addUpdateListener(_:)` will be
     called when new values are available
     */
    public func startUpdating()

    /**
     Stops automatic updates
     */
    public func stopUpdating()
}

public extension Source {

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the source's values are updated. The closure will be called with all values, but
     not all the values will neccessary be new.
     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.
     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    public func startUpdating(sendingUpdatesTo updateListener: @escaping UpdateListener) -> AnyObject
}


/**
 An object that provides values
 */
public protocol ValuesProvider {

    /// An array of all the values provided by this object
    var allValues: [AnyValue] { get }

}
```

Implementations also have individual properties for each of their values, such as the `brightness` property of the `Screen` source.

## `CustomisableUpdateIntervalSource`

A `CustomisableUpdateIntervalSource` is a `Source` that supports customising the update frequency, e.g. the gyroscope

```swift
/**
 A source that supports updating its properties at a given time interval
 */
public protocol CustomisableUpdateIntervalSource : Source {

    /// The default update interval that will be used when calling `startUpdating()`
    /// without specifying the update interval.
    /// This value is unique per-source and does not persist between app runs
    public static var defaultUpdateInterval: TimeInterval { get set }

    /// The time interval between property updates. A value of `nil` indicates that
    /// the source is not performing periodic updates
    public var updateInterval: TimeInterval? { get }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds

     - parameter updateInterval: The interval between updates, measured in seconds
    */
    public func startUpdating(every updateInterval: TimeInterval)
}

public extension CustomisableUpdateIntervalSource {

    /// A boolean indicating if the source is currently updating its properties every `updateInterval`
    public var isUpdating: Bool { get }

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
     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    public func startUpdating(every updateInterval: TimeInterval, sendingUpdatesTo updateListener: @escaping UpdateListener) -> AnyObject
}

```

## `ManuallyUpdatableSource`

A `ManuallyUpdatableSource` is a `Source` that does not provide automatic updates, but must be polled for updates. Timer-based updates are provided to keep the API concistent, but the values update listeners receive may not always contain new values.

```swift
/**
 A source that supports its properties being updated at any given time
 */
public protocol ManuallyUpdatableSource: CustomisableUpdateIntervalSource {

    /**
     Force the source to update its properties. Note that there is no guarantee that new data
     will be available

     - returns: The property values after the update
     */
    func updateProperties() -> [AnyValue]

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

### CocoaPods

To install via [CocoaPods](https://cocoapods.org) add the following line to your Podfile:

```ruby
pod 'GatheredKit'
```

and then run `pod install`.

## Tests

Running the tests for GatheredKit requires `Quick` and `Nimble`, which can be installed using Carthage:

`carthage build --platform iOS --no-use-binaries`

Tests can be run via Xcode or `fastlane test`.

## License

The project is released under the MIT license. View the [LICENSE](./LICENSE) file for the full license.