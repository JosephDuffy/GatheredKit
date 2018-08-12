import Foundation

/**
 A base class that can be used to create sources that can only be polled for updates.

 To benefit from `BasePollingSource` your subclass must implement `ManuallyUpdatableValuesProvider`. This
 will add `CustomisableUpdateIntervalControllable` conformance via an extension.
 */
open class BasePollingSource: BaseSource {

    fileprivate enum State {
        case notMonitoring
        case monitoring(updatesQueue: DispatchQueue, updateInterval: TimeInterval?)
    }

    fileprivate var state: State = .notMonitoring

    fileprivate var updatesQueue: DispatchQueue? {
        switch state {
        case .monitoring(let updatesQueue, _):
            return updatesQueue
        case .notMonitoring:
            return nil
        }
    }

    public final var updateInterval: TimeInterval? {
        switch state {
        case .monitoring(_, let updateInterval):
            return updateInterval
        case .notMonitoring:
            return nil
        }
    }

    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public override init() {
        guard type(of: self) != BasePollingSource.self else {
            fatalError("BasePollingSource must be subclassed")
        }

        super.init()
    }

}

extension Controllable where Self: BasePollingSource, Self: ManuallyUpdatableValuesProvider {

    public func stopUpdating() {
        state = .notMonitoring
    }

    internal func update(on queue: DispatchQueue, after delay: TimeInterval) {
        queue.asyncAfter(deadline: .now() + delay) { [weak self, weak queue] in
            guard let `self` = self else { return }
            guard let queue = queue else { return }
            guard queue == self.updatesQueue else { return }
            guard (self as BasePollingSource).updateInterval == delay else { return }
            guard (self as BasePollingSource).isUpdating else { return }

            let latestPropertyValues = self.updateValues()
            self.notifyUpdateListeners(latestPropertyValues: latestPropertyValues)

            self.update(on: queue, after: delay)
        }
    }

    internal func startUpdating(every updateInterval: TimeInterval) {
        let updatesQueue = DispatchQueue(label: "uk.co.josephduffy.GatheredKit \(type(of: self)) Updates")

        state = .monitoring(updatesQueue: updatesQueue, updateInterval: updateInterval)

        let latestPropertyValues = updateValues()

        update(on: updatesQueue, after: updateInterval)

        notifyUpdateListeners(latestPropertyValues: latestPropertyValues)
    }

}

// swiftlint:disable:next line_length
public extension CustomisableUpdateIntervalControllable where Self: BasePollingSource, Self: ManuallyUpdatableValuesProvider {}
