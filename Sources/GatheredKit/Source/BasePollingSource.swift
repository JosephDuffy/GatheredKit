import Combine
import Foundation

/// A base class that can be used to create sources that can only be polled for updates.
///
/// To benefit from `BasePollingSource` your subclass must implement `ManuallyUpdatablePropertiesProvider`. This
/// will add `CustomisableUpdateIntervalSource` conformance via an extension.
open class BasePollingSource: UpdatingSource {
    fileprivate enum State {
        case notMonitoring
        case monitoring(updatesQueue: DispatchQueue, updateInterval: TimeInterval?)
    }

    open var availability: SourceAvailability {
        .available
    }

    public final let id: SourceIdentifier

    public final var updateInterval: TimeInterval? {
        switch state {
        case .monitoring(_, let updateInterval):
            return updateInterval
        case .notMonitoring:
            return nil
        }
    }

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    public var allProperties: [any Property] = []

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    internal let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    fileprivate var state: State = .notMonitoring {
        didSet {
            switch state {
            case .notMonitoring:
                isUpdating = false
            case .monitoring:
                isUpdating = true
            }
        }
    }

    public init(id: SourceIdentifier) {
        guard type(of: self) != BasePollingSource.self else {
            fatalError("BasePollingSource must be subclassed")
        }

        self.id = id
    }
}

extension CustomisableUpdateIntervalControllable where Self: BasePollingSource, Self: ManuallyUpdatablePropertiesProvider {
    public func stopUpdating() {
        state = .notMonitoring
    }
}
