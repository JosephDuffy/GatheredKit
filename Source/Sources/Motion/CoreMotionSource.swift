import Foundation
import CoreMotion

open class CoreMotionSource: CustomisableUpdateIntervalControllable, UpdateConsumersProvider {
    
    public static var defaultUpdateInterval: TimeInterval = 1

    private enum State {
        case notMonitoring
        case monitoring(motionManager: CMMotionManager, updatesQueue: OperationQueue)
    }
    
    public var updateConsumers: [UpdatesConsumer]

    public var updateInterval: TimeInterval? {
        return motionManager?.deviceMotionUpdateInterval
    }

    private var state: State
    
    public var motionManager: CMMotionManager? {
        switch state {
        case .monitoring(let motionManager, _):
            return motionManager
        case .notMonitoring:
            return nil
        }
    }

    public init() {
        updateConsumers = []
        state = .notMonitoring
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        startUpdating(every: updateInterval, motionManagerConfigurator: nil)
    }
    
    public func startUpdating(every updateInterval: TimeInterval, motionManagerConfigurator: ((CMMotionManager, OperationQueue) -> Void)?) {
        if isUpdating {
            stopUpdating()
        }

        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = updateInterval
        let updatesQueue = OperationQueue(name: "uk.co.josephduffy.GatheredKit \(type(of: self)) Updates")
        
        motionManagerConfigurator?(motionManager, updatesQueue)
        
        state = .monitoring(motionManager: motionManager, updatesQueue: updatesQueue)
    }
    
    public func stopUpdating() {
        state = .notMonitoring
    }

}
