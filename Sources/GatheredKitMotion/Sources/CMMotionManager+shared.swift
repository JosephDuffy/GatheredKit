#if canImport(CoreMotion)
import CoreMotion
import Foundation

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
    @MainActor
    public static var gatheredKitShared: CMMotionManager {
        get {
            if let motionManager = _gatheredKitShared {
                return motionManager
            } else {
                let motionManager = CMMotionManager()
                _gatheredKitShared = motionManager
                return motionManager
            }
        }
        set {
            _gatheredKitShared = newValue
        }
    }

    @MainActor
    private static var _gatheredKitShared: CMMotionManager?
}
#endif
