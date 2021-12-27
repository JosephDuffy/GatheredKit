import Foundation

/// A base class that can be used to create sources that can only be polled for updates.
///
/// To benefit from `BasePollingSource` your subclass must implement `ManuallyUpdatablePropertiesProvider`. This
/// will add `CustomisableUpdateIntervalSource` conformance via an extension.
open class BasePollingSource: UpdatingSource {
    public typealias ProducedValue = [AnyProperty]

    fileprivate enum State {
        case notMonitoring
        case monitoring(updatesQueue: DispatchQueue, updateInterval: TimeInterval?)
    }

    open var availability: SourceAvailability {
        .available
    }

    open var name: String {
        ""
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

    public var allProperties: [AnyProperty] = []

    public var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> {
        sourceEventsSubject.eraseToAnyUpdatePublisher()
    }

    internal let sourceEventsSubject: UpdateSubject<SourceEvent>

    fileprivate var state: State = .notMonitoring

    private var updatesQueue: DispatchQueue? {
        switch state {
        case .monitoring(let updatesQueue, _):
            return updatesQueue
        case .notMonitoring:
            return nil
        }
    }

    public required init() {
        guard type(of: self) != BasePollingSource.self else {
            fatalError("BasePollingSource must be subclassed")
        }

        sourceEventsSubject = .init()
    }
}

extension CustomisableUpdateIntervalControllable
    where Self: BasePollingSource, Self: ManuallyUpdatablePropertiesProvider
{
    public func stopUpdating() {
        state = .notMonitoring
    }
}

extension CustomisableUpdateIntervalControllable
    where Self: BasePollingSource, Self: ManuallyUpdatablePropertiesProvider {}