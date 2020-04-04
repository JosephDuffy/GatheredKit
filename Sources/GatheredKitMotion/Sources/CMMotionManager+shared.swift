#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion

private var _sharedCMMotionManager: CMMotionManager?

extension CMMotionManager {
    internal static var shared: CMMotionManager {
        if let motionManager = _sharedCMMotionManager {
            return motionManager
        } else {
            let motionManager = CMMotionManager()
            _sharedCMMotionManager = motionManager
            return motionManager
        }
    }
}

#endif
