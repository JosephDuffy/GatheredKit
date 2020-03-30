import Foundation
import Combine

public protocol AnyProperty: class, AnySnapshot {
    var typeErasedMetadata: AnyPropertyMetadata { get }
}

public protocol AnyPropertyMetadata: class, AnySnapshot {
    var displayName: String { get }
    var date: Date { get }
    var typeErasedFormatter: Formatter { get }
    // TODO: Change `Never` to `Error`
    var typeErasedPublisher: AnyPublisher<AnySnapshot, Never> { get }
}

public protocol PropertyMetadata: AnyPropertyMetadata {

    associatedtype Snapshot: GatheredKit.Snapshot
    associatedtype Formatter: Foundation.Formatter

    var formatter: Formatter { get }

    var snapshot: Snapshot { get }

}

extension PropertyMetadata {

    public var date: Date {
        return snapshot.date
    }

    public var typeErasedFormatter: Foundation.Formatter {
        return formatter
    }

    public var typeErasedValue: Any? {
        return snapshot.value
    }

}

extension AnyPropertyMetadata {

    public var formattedValue: String? {
        guard type(of: typeErasedFormatter) != Foundation.Formatter.self else {
            // `Formatter.string(for:)` will throw an exception when not overriden
            return nil
        }
        return typeErasedFormatter.string(for: typeErasedValue)
    }

}

extension AnyProperty {

    public var displayName: String {
        return typeErasedMetadata.displayName
    }

    public var date: Date {
        return typeErasedMetadata.date
    }

    public var typeErasedFormatter: Formatter {
        return typeErasedMetadata.typeErasedFormatter
    }

}
