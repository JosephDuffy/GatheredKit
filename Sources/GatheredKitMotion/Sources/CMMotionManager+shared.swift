import CoreMotion
import Foundation

@available(macOS, unavailable)
private var _sharedCMMotionManager: CMMotionManager?
private let accessLock = NSLock()

@available(macOS, unavailable)
extension CMMotionManager {
    /// A shared instance of ``CMMotionManager`` used by GatheredKitMotion.
    ///
    /// This value MUST NOT be set if any of the following classes have been created
    /// and are using this instance of ``CMMotionManager``:
    ///
    /// - ``Accelerometer``
    /// - ``DeviceMotion``
    /// - ``Gyroscope``
    /// - ``Magnetometer``
    public static var gatheredKitShared: CMMotionManager {
        get {
            accessLock.lock()

            defer {
                accessLock.unlock()
            }

            if let motionManager = _sharedCMMotionManager {
                return motionManager
            } else {
                let motionManager = CMMotionManager()
                _sharedCMMotionManager = motionManager
                return motionManager
            }
        }
        set {
            accessLock.lock()
            _sharedCMMotionManager = newValue
            accessLock.unlock()
        }
    }
}
