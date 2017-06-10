//
//  ProximitySensor.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 10/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import UIKit

/**
 A sensor that detects if an object is close to the sensor. By default it will be backed by `UIDevice.current`, which
 will use the proximity sensor available on iPhones
 */
public final class ProximitySensor: AutomaticallyUpdatingSource {

    private enum State {
        case notMonitoring
        case monitoring(proximityStateChangeObeserver: NSObjectProtocol)
    }

    /// An internal property used to allow for testing the `isAvailable` property
    internal static var defaultBackingData: ProximitySensorBackingData = UIDevice.current

    /// A boolean indicating if a promixity sensor is available on the current device
    public static var isAvailable: Bool {
        let device = defaultBackingData
        let startingValue = device.isProximityMonitoringEnabled
        /*
         To know if the device has a proximity sensor the `isProximityMonitoringEnabled`
         property is set to `true`. If the property is then `true` the device has a proximity
         sensor.
         */
        device.isProximityMonitoringEnabled = true
        let isAvailable = device.isProximityMonitoringEnabled
        // Revert the value to the starting value
        device.isProximityMonitoringEnabled = startingValue

        return isAvailable
    }

    /// A user-friendly name for the source
    public static let displayName: String = "Proximity Sensor"

    /// A count of how many `Promixity` instances are monitoring for changes. This
    /// is used to ensure that `UIDevice.current`'s `isProximityMonitoringEnabled`
    /// property is updated appropriately
    private static var proximityMonitoringEnabledManager = ProximityMonitoringEnabledManager()

    /// A boolean indicating if the proximity sensor is monitoring for nearby objects
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring(_):
            return true
        }
    }

    /// If the `value` is `true` then the sensor has detected an object.
    /// Display Name: Object Detected
    /// Unit: Boolean; true = "Yes"; false = "No"
    public private(set) var objectDetected: SourceProperty<Optional<Bool>>

    /**
     An array of the promixity sensor's properties, in the following order:

     - Object Detected
     */
    public var properties: [AnySourceProperty] {
        return [
            objectDetected.any()
        ]
    }

    /// A delegate that will receive messages about the screen's data changing
    public weak var delegate: SourceDelegate?

    /// The `ProximityBackingData` backing this `ProximitySensor`
    public let backingData: ProximitySensorBackingData

    /// The internal state, indicating if the proximity sensor is monitoring for changes
    private var state: State = .notMonitoring

    /**
     Create a new instance of `ProximitySensor`. It will be backed by `UIDevice.current` by default

     - parameter backingData: The `ProximitySensorBackingData` to get data from. Defaults to `UIDevice.current`
     */
    public required init(backedBy backingData: ProximitySensorBackingData? = nil) {
        self.backingData = backingData ?? ProximitySensor.defaultBackingData
        objectDetected = SourceProperty(displayName: "Object Detected", value: nil, unit: Boolean(trueString: "Yes", falseString: "No"))
    }

    deinit {
        stopMonitoring()
    }

    /**
     Start automatically monitoring for changes to the proximity sensor
     */
    public func startMonitoring() {
        guard !isUpdating else { return }

        guard ProximitySensor.proximityMonitoringEnabledManager.startObservingChanges(to: backingData) else { return }

        let proximityStateChangeObeserver = NotificationCenter.default.addObserver(forName: .UIDeviceProximityStateDidChange, object: backingData, queue: .main) { [weak self] _ in
            guard let `self` = self else { return }

            self.objectDetected.updateData(value: self.backingData.proximityState)

            self.notifyListenersPropertiesUpdated()
        }

        state = .monitoring(proximityStateChangeObeserver: proximityStateChangeObeserver)

        // Get an initial value without this the value would be `nil` until the state changed
        objectDetected.updateData(value: self.backingData.proximityState)

        notifyListenersPropertiesUpdated()
    }

    /**
     Stop automatically monitoring for changes to the proximity sensor
     */
    public func stopMonitoring() {
        guard case .monitoring(let proximityStateChangeObeserver) = state else { return }

        NotificationCenter.default.removeObserver(proximityStateChangeObeserver)

        ProximitySensor.proximityMonitoringEnabledManager.stoppedObservingChanges(to: backingData)

        state = .notMonitoring
    }
}

/**
 The backing data for `ProximitySensor`
 */
public protocol ProximitySensorBackingData: class {

    /// A Boolean value indicating whether proximity monitoring is enabled 
    var isProximityMonitoringEnabled: Bool { get set }

    /// A Boolean value indicating whether the proximity sensor is close to an object
    var proximityState: Bool { get }

}

extension UIDevice: ProximitySensorBackingData {}

/**
 An private struct used to manage the `isProximityMonitoringEnabled` property of a given `ProximitySensorBackingData`. This
 is neccessary to allow for multiple `ProximitySensor` instances to be used at the same time and support the stopping of one
 while the other still recieves updates.
 */
private struct ProximityMonitoringEnabledManager {

    /// The internal counts of how many things are monitoring proximity changes
    private var counts: [UnsafeMutablePointer<ProximitySensorBackingData>: Int]

    init() {
        counts = [:]
    }

    /**
     Tells the `backingData` to start monitoring the proximity sensor. On success, this method will increment an internal counter
     to ensure the `isProximityMonitoringEnabled` is set to `false` appropriately in `stoppedObservingChanges(backingData:`)
     
     - parameter backingData: The backing data that will have `isProximityMonitoringEnabled` set to `true`
     
     - returns: `true` if setting `isProximityMonitoringEnabled` succeeded, otherwise `false`
     */
    mutating func startObservingChanges(to backingData: ProximitySensorBackingData) -> Bool {
        backingData.isProximityMonitoringEnabled = true

        guard backingData.isProximityMonitoringEnabled else { return false }

        let pointer = UnsafeMutablePointer<ProximitySensorBackingData>.allocate(capacity: 1)
        pointer.initialize(to: backingData)
        let count = counts[pointer] ?? 0
        counts[pointer] = count + 1

        return true
    }

    /**
     Decrements the internal counter for the given `backingData`. If this the new value for the internal counter is less than 1
     the `isProximityMonitoringEnabled` property of `backingData` is set to `false`
     
     - parameter backingData: The backing data to decrement the internal counter for and potentially set the `isProximityMonitoringEnabled` property to `false` on
     
     - returns: `true` if the `isProximityMonitoringEnabled` property was set to `false`, otherwise `false`
     */
    @discardableResult
    mutating func stoppedObservingChanges(to backingData: ProximitySensorBackingData) -> Bool {
        let pointer = UnsafeMutablePointer<ProximitySensorBackingData>.allocate(capacity: 1)
        pointer.initialize(to: backingData)
        guard let count = counts[pointer] else { return false }
        let newCount = count - 1
        if newCount < 1 {
            backingData.isProximityMonitoringEnabled = false
            counts.removeValue(forKey: pointer)
            return true
        } else {
            counts[pointer] = newCount
            return false
        }
    }

}
