#if canImport(Combine)
import Combine
#endif

public final class AnyUpdatePublisher<Payload>: UpdatePublisher {
    public typealias UpdateListener = (_ payload: Payload) -> Void

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public var combinePublisher: AnyPublisher<Payload, Never> {
        return (boxedCombinePublisher as! BoxedCombinePublisher)()
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    private typealias BoxedCombinePublisher = () -> AnyPublisher<Payload, Never>

    private let boxedCombinePublisher: Any

    private let boxedAddUpdateListener: (_ updateListener: @escaping UpdateListener) -> Subscription

    public init<UpdatePublisher: GatheredKitCore.UpdatePublisher>(updatePublisher: UpdatePublisher) where UpdatePublisher.Payload == Payload {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            boxedCombinePublisher = {
                return updatePublisher.combinePublisher
            } as BoxedCombinePublisher
        } else {
            boxedCombinePublisher = {
                fatalError("boxedCombinePublisher unavailable")
            }
        }

        boxedAddUpdateListener = { updateListener in
            return updatePublisher.addUpdateListener(updateListener)
        }
    }

    public func addUpdateListener(_ updateListener: @escaping UpdateListener) -> Subscription {
        return boxedAddUpdateListener(updateListener)
    }
}
