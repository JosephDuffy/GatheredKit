//
//  DeviceMotionDataSourceBase.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 11/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation
import CoreMotion

/**
 A base class to aid the creation of `CMMotionManager`-based data sources
 */
public class DeviceMotionDataSourceBase {

    /// A closure that will be notified of new data
    internal typealias DataRefreshHandler = (CMDeviceMotion) -> Void

    /// How frequently the data source will refresh. A value of `nil` indicates that
    /// the data source is not performing automatic periodic refreshes
    public var updateInterval: Double? {
        return motionManager?.deviceMotionUpdateInterval
    }

    /// A boolean indicating if the data source is currently refreshing its data every `updateInterval`
    public var isUpdating: Bool {
        return motionManager != nil
    }

    /// A delegate that will receive a message when new data is available
    public weak var delegate: DataSourceDelegate?

    /// The `CMMotionManager` that is backing this device motion data source
    private var motionManager: CMMotionManager?

    /**
     If `referenceFrame` is `nil`, `CMMotionManager.attitudeReferenceFrame` is used
     
     - parameter updateInterval: The interval between data updates
     - parameter operationQueue: The queue that motion updates will be performed on. This can be high frequency so it's recommend that the main queue is not used
     - parameter referenceFrame: A constant identifying the reference frame to use for device-motion updates
     - parameter dataRefreshedHandler: A closure that will be notified of new data
     */
    internal func startRefreshing(every updateInterval: TimeInterval, operationQueue: OperationQueue, referenceFrame: CMAttitudeReferenceFrame?, dataRefreshedHandler closure: @escaping DataRefreshHandler) {
        guard !isUpdating else { return }

        let motionManager = CMMotionManager()
        self.motionManager = motionManager
        motionManager.deviceMotionUpdateInterval = updateInterval

        let handler = createHandler(closure: closure)

        if let referenceFrame = referenceFrame {
            motionManager.startDeviceMotionUpdates(using: referenceFrame, to: operationQueue, withHandler: handler)
        } else {
            motionManager.startDeviceMotionUpdates(to: operationQueue, withHandler: handler)
        }
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
    private func createHandler(closure: @escaping DataRefreshHandler) -> CMDeviceMotionHandler {
        return { [weak self] (data: CMDeviceMotion?, error: Error?) in
            if let error = error {
                (self as? DataSource)?.notifyDelegate(errorOccurred: error)
            } else if let data = data {
                closure(data)
            } else {
                (self as? DataSource)?.notifyDelegate(errorOccurred: nil)
            }
        }
    }

}
