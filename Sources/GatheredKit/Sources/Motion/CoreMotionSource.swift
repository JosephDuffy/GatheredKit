import Foundation
import CoreMotion

open class CoreMotionSource: CustomisableUpdateIntervalControllable, Producer {
    
    public typealias ProducedValue = [AnyProperty]
    
    public static var defaultUpdateInterval: TimeInterval = 1

    private enum State {
        case notMonitoring
        case monitoring(motionManager: CMMotionManager, updatesQueue: OperationQueue)
    }

    public var updateInterval: TimeInterval? {
        return motionManager?.deviceMotionUpdateInterval
    }

    internal var consumers: [AnyConsumer] = []

    private var state: State
    
    // TODO: Make private and add functions to start/stop certain types of motion. Also
    // makes this static and cached across instances, as-per the docs. Store closure on
    // this object to allow for removal of update handler without having to call
    // `stopDeviceMotionUpdates` etc. until the last handler has been removed
    public var motionManager: CMMotionManager? {
        switch state {
        case .monitoring(let motionManager, _):
            return motionManager
        case .notMonitoring:
            return nil
        }
    }

    public init() {
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

extension CoreMotionSource: ConsumersProvider { }
