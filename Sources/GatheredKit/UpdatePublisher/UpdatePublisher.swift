#if canImport(Combine)
import Combine
#endif

/// A type that publishes
public protocol UpdatePublisher: AnyObject {
    associatedtype Payload

    typealias UpdateListener = (_ payload: Payload) -> Void

    #if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    var combinePublisher: AnyPublisher<Payload, Never> { get }
    #endif

    func addUpdateListener(_ updateListener: @escaping UpdateListener) -> Subscription
}

extension UpdatePublisher {
    public func eraseToAnyUpdatePublisher() -> AnyUpdatePublisher<Payload> {
        AnyUpdatePublisher(updatePublisher: self)
    }
}
