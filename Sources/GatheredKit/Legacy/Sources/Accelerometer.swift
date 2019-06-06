import Foundation
import CoreMotion

public final class Accelerometer: CoreMotionSource, Source, PropertiesProvider {

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isAccelerometerAvailable
    }

    public static let name = "Accelerometer"

    public let totalAcceletation: AccelerationValue

    public let gravitationalAcceletation: AccelerationValue

    public let userAcceleration: AccelerationValue

    public let rawAcceleration: AccelerationValue

    public var allProperties: [AnyProperty] {
        return [
            totalAcceletation,
            gravitationalAcceletation,
            userAcceleration,
            rawAcceleration
        ]
    }

    public override init() {
        totalAcceletation = AccelerationValue(
            displayName: "Gravitational Acceleration"
        )
        gravitationalAcceletation = AccelerationValue(
            displayName: "Gravitational Acceleration"
        )
        userAcceleration = AccelerationValue(
            displayName: "User Acceleration"
        )
        rawAcceleration = AccelerationValue(
            displayName: "Raw Acceleration"
        )
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        super.startUpdating(every: updateInterval) { motionManager, updatesQueue in
            let deviceMotionHandler: CMDeviceMotionHandler = { [weak self] (_ data: CMDeviceMotion?, error: Error?) in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                guard let data = data else { return }
                
                let total: CMAcceleration?
                
                if
                    let gravity = data?.gravity,
                    let userAcceleration = data?.userAcceleration
                {
                    total = gravity + userAcceleration
                } else {
                    total = nil
                }
                
                self.totalAcceletation.update(
                    value: data.rotationRate,
                    date: data.date
                )
                self.gravitationalAcceletation.update(
                    value: data?.gravity,
                    date: date
                )
                self.userAcceleration.update(
                    value: data?.userAcceleration,
                    date: date
                )
                
                self.notifyUpdateConsumersOfLatestValues()
            }
            
            let rawHandler: CMAccelerometerHandler = { [weak self] (_ data: CMAccelerometerData?, error: Error?) in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                
                self.rawAcceleration.update(
                    value: data?.acceleration,
                    date: data?.date ?? Date()
                )
                
                self.notifyUpdateConsumersOfLatestValues()
            }
            
            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.accelerometerUpdateInterval = updateInterval
            motionManager.showsDeviceMovementDisplay = true
            
            motionManager.startDeviceMotionUpdates(
                to: updatesQueue,
                withHandler: deviceMotionHandler
            )
            motionManager.startAccelerometerUpdates(
                to: updatesQueue,
                withHandler: rawHandler
            )
        }
    }
    
    public override func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager?.stopAccelerometerUpdates()
        super.stopUpdating()
    }

}

private extension CMAcceleration {

    static func + (lhs: CMAcceleration, rhs: CMAcceleration) -> CMAcceleration {
        return CMAcceleration(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y,
            z: lhs.z + rhs.z
        )
    }

}
