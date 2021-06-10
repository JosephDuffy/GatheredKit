# `GatheredKit`

`GatheredKit` provides the core protocols, classes, and structs that are used to build data sources. This library can be used by itself to create custom data sources

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
