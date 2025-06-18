import Combine
import Foundation

public struct PropertyFormatter<Value> {
    public typealias FormatStyle = Foundation.FormatStyle<Value, String>

    public typealias Formatter = (
        _ property: any Property<Value>,
        _ formatStyleModifier: ((_ formatStyle: inout FormatStyle) -> Void)?
    ) -> String

    public let formatter: Formatter

    public init(formatter: @escaping Formatter) {
        self.formatter = formatter
    }

    func callAsFunction(
        property: any Property<Value>,
        formatStyleModifier: ((_ formatStyle: inout FormatStyle) -> Void)?
    ) -> String {
        formatter(property, formatStyleModifier)
    }
}

public struct PropertyFormatter2<FormatStyle> where FormatStyle: Foundation.FormatStyle, FormatStyle.FormatOutput == String {
    public typealias Formatter = (
        _ property: any Property<FormatStyle.FormatInput>,
        _ formatStyleModifier: ((_ formatStyle: inout FormatStyle) -> Void)?
    ) -> String

    public let formatter: Formatter

    public init(formatter: @escaping Formatter) {
        self.formatter = formatter
    }

    func callAsFunction(
        property: any Property<FormatStyle.FormatInput>,
        formatStyleModifier: ((_ formatStyle: inout FormatStyle) -> Void)?
    ) -> String {
        formatter(property, formatStyleModifier)
    }
}

public protocol Property<Value>: AnyObject, AnySnapshot {
    associatedtype Value

    var id: PropertyIdentifier { get }
    var error: Error? { get }
    var errorsPublisher: AnyPublisher<Error?, Never> { get }
    var snapshot: Snapshot<Value> { get }
    var value: Value { get }
    /// An asynchronous stream of snapshots, starting with the current snapshot.
    var snapshots: AsyncStream<Snapshot<Value>> { get }

    /// A Combine publisher, starting with the current snapshot.
    var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> { get }

    var formatter: PropertyFormatter<Value>? { get }
}

extension Property {
    public var value: Value {
        snapshot.value
    }

    public var formattedValue: String? {
        guard let formatter else { return nil }
        return formatter(property: self, formatStyleModifier: nil)
    }

    /// The date of the latest value.
    public var date: Date {
        snapshot.date
    }

    public var error: Error? {
        nil
    }

    public var errorsPublisher: AnyPublisher<Error?, Never> {
        Just(nil).eraseToAnyPublisher()
    }

    public var snapshots: AsyncStream<Snapshot<Value>> {
        AsyncStream<Snapshot<Value>> { continuation in
            let cancellable = snapshotsPublisher.sink { snapshot in
                continuation.yield(snapshot)
            }
            continuation.onTermination = { @Sendable [cancellable] _ in
                cancellable.cancel()
            }
        }
    }

    /// An asynchronous stream of values, starting with the current value.
    public var values: AsyncStream<Value> {
        AsyncStream<Value> { continuation in
            let cancellable = snapshotsPublisher.sink { snapshot in
                continuation.yield(snapshot.value)
            }
            continuation.onTermination = { @Sendable [cancellable] _ in
                cancellable.cancel()
            }
        }
    }

    /// A Combine publisher, starting with the current value.
    var valuePublisher: AnyPublisher<Value, Never> {
        snapshotsPublisher.map(\.value).eraseToAnyPublisher()
    }

    /// The type-erased current value of the property.
    public var typeErasedValue: Any? {
        snapshot.value
    }

    public var typeErasedSnapshotPublisher: AnyPublisher<AnySnapshot, Never> {
        snapshotsPublisher.map { $0 as AnySnapshot }.eraseToAnyPublisher()
    }
}
