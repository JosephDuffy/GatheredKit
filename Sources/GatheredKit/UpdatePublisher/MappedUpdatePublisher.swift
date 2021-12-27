import Foundation
#if canImport(Combine)
import Combine
#endif

internal final class MappedUpdatePublisher<Input, Payload>: UpdatePublisher {
    internal typealias UpdateListener = (_ payload: Payload) -> Void

    internal typealias Transformer = (_ input: Input) -> Payload

    #if canImport(Combine)
    /// A publisher that publishes updates when the snapshot updates.
    internal var combinePublisher: AnyPublisher<Payload, Never> {
        combineSubject.eraseToAnyPublisher()
    }

    private typealias PayloadSubject = PassthroughSubject<Payload, Never>

    /// The updates subject that publishes snapshot updates.
    private lazy var combineSubject = PayloadSubject()
    #endif

    private var subscription: Subscription?

    private var updateListeners: [UUID: UpdateListener] = [:]

    internal init<UpdatePublisher: GatheredKit.UpdatePublisher>(
        updatePublisher: UpdatePublisher,
        transform: @escaping Transformer
    ) where UpdatePublisher.Payload == Input {
        subscription = updatePublisher.addUpdateListener { [weak self] input in
            guard let self = self else { return }
            let payload = transform(input)
            self.notifyUpdateListeners(of: payload)
        }
    }

    internal func addUpdateListener(_ updateListener: @escaping UpdateListener) -> Subscription {
        let uuid = UUID()
        updateListeners[uuid] = updateListener

        return Subscription { [weak self] in
            self?.updateListeners.removeValue(forKey: uuid)
        }
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

extension UpdatePublisher {
    internal func map<Output>(_ transform: @escaping (_ payload: Payload) -> Output) -> MappedUpdatePublisher<Payload, Output> {
        MappedUpdatePublisher(updatePublisher: self, transform: transform)
    }
}
