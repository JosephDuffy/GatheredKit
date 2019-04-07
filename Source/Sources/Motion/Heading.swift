import Foundation
import CoreMotion

@available(iOS 11.0, *)
public final class Heading: Source, CustomisableUpdateIntervalControllable, ValuesProvider, UpdateConsumersProvider {
    
    public enum ReferenceFrame: CaseIterable {

        case magneticNorth
        case trueNorth
        
        public var rawValue: UInt {
            return asCMAttitudeReferenceFrame.rawValue
        }
        
        public var asCMAttitudeReferenceFrame: CMAttitudeReferenceFrame {
            switch self {
            case .magneticNorth:
                return .xMagneticNorthZVertical
            case .trueNorth:
                return .xTrueNorthZVertical
            }
        }
        
    }
    
    private enum State {
        case notMonitoring
        case monitoring(motionManager: CMMotionManager, updatesQueue: OperationQueue)
    }
    
    public static var defaultUpdateInterval: TimeInterval = 1

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isDeviceMotionAvailable
    }

    public static let name = "source.heading.name"
    
    public static func availableReferenceFrames() -> [ReferenceFrame] {
        let frames = CMMotionManager.availableAttitudeReferenceFrames()
        return ReferenceFrame.allCases.filter({ frames.isSuperset(of: $0.asCMAttitudeReferenceFrame )})
    }

    public var heading: OptionalDoubleValue

    public var allValues: [AnyValue] {
        return [heading]
    }
    
    public var updateConsumers: [UpdatesConsumer]

    public var updateInterval: TimeInterval? {
        return motionManager?.deviceMotionUpdateInterval
    }

    private var state: State
    
    private var motionManager: CMMotionManager? {
        switch state {
        case .monitoring(let motionManager, _):
            return motionManager
        case .notMonitoring:
            return nil
        }
    }

    public init() {
        heading = OptionalDoubleValue(displayName: "source.heading.values.heading.display-name")
        updateConsumers = []
        state = .notMonitoring
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        startUpdating(every: updateInterval, referenceFrame: .magneticNorth)
    }

    public func startUpdating(
        every updateInterval: TimeInterval,
        referenceFrame: ReferenceFrame
    ) {
        if isUpdating {
            stopUpdating()
        }

        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = updateInterval
        let updatesQueue = OperationQueue(name: "uk.co.josephduffy.GatheredKit Heading Updates")
        
        defer {
            state = .monitoring(motionManager: motionManager, updatesQueue: updatesQueue)
        }

        let handler: CMDeviceMotionHandler = { [weak self] (_ data: CMDeviceMotion?, error: Error?) in
            guard let self = self else { return }
            guard self.isUpdating else { return }
            guard let data = data else { return }

            self.heading.update(
                backingValue: data.heading,
                formattedValue: data.heading < 0 ? "source.heading.value.heading.unknown-value" : nil,
                date: data.date
            )

            self.notifyUpdateConsumersOfLatestValues()
        }

        motionManager.startDeviceMotionUpdates(
            using: referenceFrame.asCMAttitudeReferenceFrame,
            to: updatesQueue,
            withHandler: handler
        )
    }
    
    public func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        state = .notMonitoring
    }

}
