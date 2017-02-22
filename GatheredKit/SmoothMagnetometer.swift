//
//  SmoothMagnetometer.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 11/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation
import CoreMotion

/**
 A sensor that measure magnetic fields. This will report values that have been corrected for the bias introduced
 by the device and its electronic components
 */
public final class SmoothMagnetometer: DeviceMotionDataSourceBase, CustomisableUpdateIntervalDataSource {

    /// A boolean indicating if a magnetometer with values corrected for the device's bias is available on the current device
    public static var isAvailable: Bool {
        return CMMotionManager().isDeviceMotionAvailable && CMMotionManager().isMagnetometerAvailable
    }

    /// A user-friendly name for the magnetometer
    public static var displayName = "Magnetometer (corrected for device)"

    /**
     An array of the data reported by the magnetometer, in the following order:

      - x
      - y
      - z
      - Accuracy
     */
    public var data: [DataSourceData] {
        return [
            x,
            y,
            z,
            accuracy,
        ]
    }

    /// X-axis magnetic field, measured in microteslas
    public private(set) var x: TypedDataSourceData<Optional<Double>>

    /// Y-axis magnetic field, measured in microteslas
    public private(set) var y: TypedDataSourceData<Optional<Double>>

    /// Z-axis magnetic field, measured in microteslas
    public private(set) var z: TypedDataSourceData<Optional<Double>>

    /// The accuracy of the magnetic field estimate
    public private(set) var accuracy: TypedDataSourceData<Optional<CMMagneticFieldCalibrationAccuracy>>

    /// The reference frame to
    public let referenceFrame: CMAttitudeReferenceFrame?

    /**
     Create a new `SmoothMagnetometer`
     
     - parameter referenceFrame: The frame to use for device motion updates. See `CMAttitudeReferenceFrame` for info. Default is `nil`
     */
    public required init(referenceFrame: CMAttitudeReferenceFrame? = nil) {
        x = TypedDataSourceData(displayName: "x", value: nil, unit: Microtesla())
        y = TypedDataSourceData(displayName: "y", value: nil, unit: Microtesla())
        z = TypedDataSourceData(displayName: "z", value: nil, unit: Microtesla())
        accuracy = TypedDataSourceData(displayName: "Accuracy", value: nil)
        self.referenceFrame = referenceFrame
    }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds
     
     **N.B.**
     
     This method will cause motion updates will be performed on the main operation queue, which could cause performance issues. To avoid
     this, provide an `OperationQueue` using the `operationQueue` parameter

     - parameter updateInterval: The interval between data refreshes, measured in seconds
     */
    public func startUpdating(every updateInterval: TimeInterval) {
        self.startUpdating(every: updateInterval, operationQueue: .main)
    }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds
     
     - parameter updateInterval: The interval to perform data refreshes
     - parameter operationQueue: The queue that motion updates will be performed on. This can be high frequency so it's recommend that the main queue is not used
     */
    public func startUpdating(every updateInterval: TimeInterval, operationQueue: OperationQueue) {
        super.startRefreshing(every: updateInterval, operationQueue: operationQueue, referenceFrame: referenceFrame, dataRefreshedHandler: self.refreshed(motionData:))
    }

    /**
     A function intended to be used as the handler for when motion data refreshes. This method will update the data and notify listeners
     
     - parameter motionData: The new motion data
    */
    private func refreshed(motionData: CMDeviceMotion) {
        let date = Date(timeIntervalSinceReferenceDate: motionData.timestamp)
        let magneticField = motionData.magneticField
        let field = magneticField.field

        x.updateData(value: field.x, date: date)
        y.updateData(value: field.y, date: date)
        z.updateData(value: field.z, date: date)

        let accuracyFormattedValue: String = {
            switch magneticField.accuracy {
            case .uncalibrated:
                return "Uncalibrated"
            case .low:
                return "Low"
            case .medium:
                return "Medium"
            case .high:
                return "High"
            }
        }()

        accuracy.updateData(value: magneticField.accuracy, formattedValue: accuracyFormattedValue, date: date)
        
        notifyListenersDataUpdated()
    }

}
