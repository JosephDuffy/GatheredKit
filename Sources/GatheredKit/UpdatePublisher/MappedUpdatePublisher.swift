import Foundation

#if canImport(Combine)
import Combine
#endif

public final class MappedUpdatePublisher<Input, Payload>: UpdatePublisher {
    public typealias UpdateListener = (_ payload: Payload) -> Void

    public typealias Transformer = (_ input: Input) -> Payload

    #if canImport(Combine)
    /// A publisher that publishes updates when the snapshot updates.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) public var combinePublisher:
        AnyPublisher<Payload, Never>
    { return combineSubject.eraseToAnyPublisher() }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) private typealias PayloadSubject =
        PassthroughSubject<Payload, Never>

    /// The updates subject that publishes snapshot updates.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) private var combineSubject:
        PayloadSubject
    { return _combineSubject as! PayloadSubject }

    private lazy var _combineSubject: Any = {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            return PayloadSubject()
        } else {
            preconditionFailure("Should not be accessed")
        }
    }()
    #endif

    private var subscription: Subscription?

    private var updateListeners: [UUID: UpdateListener] = [:]

    public init<UpdatePublisher: GatheredKit.UpdatePublisher>(
        updatePublisher: UpdatePublisher,
        transform: @escaping Transformer
    ) where UpdatePublisher.Payload == Input {
        subscription = updatePublisher.addUpdateListener { [weak self] input in
            guard let self = self else { return }
            let payload = transform(input)
            self.notifyUpdateListeners(of: payload)
        }
    }

    public final func addUpdateListener(_ updateListener: @escaping UpdateListener) -> Subscription
    {
        let uuid = UUID()
        updateListeners[uuid] = updateListener

        return Subscription { [weak self] in self?.updateListeners.removeValue(forKey: uuid) }
    }

    private func notifyUpdateListeners(of payload: Payload) {
        updateListeners.lazy.map(\.value).forEach { $0(payload) }

        #if canImport(Combine)
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            combineSubject.send(payload)
        }
        #endif
    }
}
