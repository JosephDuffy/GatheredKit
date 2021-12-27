#if canImport(Combine)
import Combine
#endif

/// A type that publishes
public protocol UpdatePublisher: AnyObject {
    associatedtype Payload

    typealias UpdateListener = (_ payload: Payload) -> Void

    #if canImport(Combine)
    var combinePublisher: AnyPublisher<Payload, Never> { get }
    #endif

    func addUpdateListener(_ updateListener: @escaping UpdateListener) -> Subscription
}

extension UpdatePublisher {
    public func eraseToAnyUpdatePublisher() -> AnyUpdatePublisher<Payload> {
        AnyUpdatePublisher(updatePublisher: self)
    }
}
