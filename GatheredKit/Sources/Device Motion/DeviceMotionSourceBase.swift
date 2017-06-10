//
//  DeviceMotionSourceBase.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 11/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation
import CoreMotion

/**
 A base class to aid the creation of `CMMotionManager`-based sources
 */
public class DeviceMotionSourceBase {

    /// A closure that will be notified of new data
    internal typealias DataUpdatedHandler = (CMDeviceMotion) -> Void

    /// How frequently the source will refresh. A value of `nil` indicates that
    /// the source is not performing periodic refreshes
    public var updateInterval: Double? {
        return motionManager?.deviceMotionUpdateInterval
    }

    /// A boolean indicating if the source is currently refreshing its data every `updateInterval`
    public var isUpdating: Bool {
        return motionManager != nil
    }

    /// A delegate that will receive a message when new data is available
    public weak var delegate: SourceDelegate?

    /// The `CMMotionManager` that is backing this device motion source
    private var motionManager: CMMotionManager?

    /**
     Start performing periodic device motion updates
     
     - parameter updateInterval: The interval between data updates
     - parameter operationQueue: The queue that motion updates will be performed on. This can be high frequency so it's recommend that the main queue is not used
     - parameter referenceFrame: A constant identifying the reference frame to use for device-motion updates. Defaults to `CMMotionManager.attitudeReferenceFrame`
     - parameter handler: A closure that will be notified of new data
     */
    internal func startUpdating(every updateInterval: TimeInterval, to operationQueue: OperationQueue, referenceFrame: CMAttitudeReferenceFrame? = nil, handler: @escaping DataUpdatedHandler) {
        guard !isUpdating else { return }

        let motionManager = CMMotionManager()
        self.motionManager = motionManager
        motionManager.deviceMotionUpdateInterval = updateInterval

        let handler = createHandler(closure: handler)

        motionManager.startDeviceMotionUpdates(using: referenceFrame ?? motionManager.attitudeReferenceFrame, to: operationQueue, withHandler: handler)
    }

    /**
     Stop performing periodic device motion updates
     */
    public func stopUpdating() {
        guard isUpdating else { return }

        motionManager?.stopDeviceMotionUpdates()
        motionManager = nil
    }

    /**
     Creates and returns a `CMDeviceMotionHandler` that will call `closure` on success and will notify the delegate
     on error
     
     - parameter closure: The closure to be called on success
     
     - returns: The newly created `CMDeviceMotionHandler`
     */
    private func createHandler(closure: @escaping DataUpdatedHandler) -> CMDeviceMotionHandler {
        return { [weak self] (data: CMDeviceMotion?, error: Error?) in
            if let error = error {
                (self as? Source)?.notifyDelegate(errorOccurred: error)
            } else if let data = data {
                closure(data)
            } else {
                (self as? Source)?.notifyDelegate(errorOccurred: nil)
            }
        }
    }

}
