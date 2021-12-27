import Foundation

#if canImport(Combine)
import Combine
#endif

open class UpdateSubject<Payload>: UpdatePublisher {
    public typealias UpdateListener = (_ payload: Payload) -> Void

    internal private(set) var updateListeners: [UUID: UpdateListener] = [:]

    #if canImport(Combine)
    /// A publisher that publishes updates when the snapshot updates.
    public var combinePublisher: AnyPublisher<Payload, Never> {
        combineSubject.eraseToAnyPublisher()
    }

    private typealias PayloadSubject = PassthroughSubject<Payload, Never>

    /// The updates subject that publishes snapshot updates.
    private lazy var combineSubject = PayloadSubject()
    #endif

    public init() {}

    @available(*, deprecated, renamed: "notifyUpdateListeners(of:)")
    public func send(_ payload: Payload) {
        notifyUpdateListeners(of: payload)
    }

    open func notifyUpdateListeners(of payload: Payload) {
        updateListeners.lazy.map(\.value).forEach { $0(payload) }

        #if canImport(Combine)
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            combineSubject.send(payload)
        }
        #endif
    }

    public final func addUpdateListener(_ updateListener: @escaping UpdateListener) -> Subscription
    {
        let uuid = UUID()
        updateListeners[uuid] = updateListener

        return Subscription { [weak self] in
            self?.updateListeners.removeValue(forKey: uuid)
        }
    }
}
