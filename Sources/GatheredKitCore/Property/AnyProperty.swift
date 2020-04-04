import Foundation
import Combine

public protocol AnyProperty: class, AnySnapshot {
    var displayName: String { get }
    var date: Date { get }
    var typeErasedFormatter: Formatter { get }
    // TODO: Change `Never` to `Error`
    var typeErasedPublisher: AnyPublisher<AnySnapshot, Never> { get }
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
