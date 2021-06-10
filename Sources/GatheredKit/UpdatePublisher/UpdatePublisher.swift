#if canImport(Combine)
import Combine
#endif

public protocol UpdatePublisher {
    associatedtype Payload

    typealias UpdateListener = (_ payload: Payload) -> Void

    #if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) var combinePublisher:
        AnyPublisher<Payload, Never>
    { get }
    #endif

    func addUpdateListener(_ updateListener: @escaping UpdateListener) -> Subscription
}

extension UpdatePublisher {
    public func eraseToAnyUpdatePublisher() -> AnyUpdatePublisher<Payload> {
        return AnyUpdatePublisher(updatePublisher: self)
    }

    public func map<Output>(_ transform: @escaping (_ payload: Payload) -> Output)
        -> MappedUpdatePublisher<Payload, Output>
    { return MappedUpdatePublisher(updatePublisher: self, transform: transform) }
}
