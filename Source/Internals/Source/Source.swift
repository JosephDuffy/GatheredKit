import Foundation

/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: ValuesProvider {

    /// The availability of the source
    static var availability: SourceAvailability { get }

    /// A user-friendly name that represents the source, e.g. "Location", "Device Attitude"
    static var name: String { get }

    /// Creates a new instance of the source
    init()
    
}

extension Source where Self: Producer {
    
    public func consumeUpdates(
        sendingUpdatesOn queue: OperationQueue = .main,
        to updateListener: @escaping ClosureConsumer<ProducedValue, Self>.UpdatesClosure
    ) -> ClosureConsumer<ProducedValue, Self> {
        let consumer = ClosureConsumer(queue: queue, closure: updateListener)
        add(consumer: consumer)
        return consumer
    }
    
}
