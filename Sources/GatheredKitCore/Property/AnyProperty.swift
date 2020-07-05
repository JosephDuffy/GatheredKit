import Foundation
import Combine

public protocol AnyProperty: class, AnySnapshot {
    typealias AnyUpdateListener = (_ snapshot: AnySnapshot) -> Void

    var displayName: String { get }
    var date: Date { get }
    var typeErasedFormatter: Formatter { get }
    var typeErasedUpdatePublisher: AnyUpdatePublisher<AnySnapshot> { get }
}

extension AnyProperty {

    public var formattedValue: String? {
        guard type(of: typeErasedFormatter) != Foundation.Formatter.self else {
            // `Formatter.string(for:)` will throw an exception when not overriden
            return nil
        }
        return typeErasedFormatter.string(for: typeErasedValue)
    }

}
