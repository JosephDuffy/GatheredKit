import Foundation
import Combine

@available(*, deprecated, renamed: "ReadOnlyProperty")
public typealias PropertyMetadata = ReadOnlyProperty

@available(*, deprecated, renamed: "AnyProperty")
public typealias AnyPropertyMetadata = AnyProperty

open class ReadOnlyProperty<Value, Formatter: Foundation.Formatter>: AnyProperty {

    public struct Snapshot: GatheredKitCore.Snapshot {
        public let value: Value
        public let date: Date

        public init(value: Value, date: Date) {
            self.value = value
            self.date = date
        }
    }

    public let displayName: String

    @Published
    public internal(set) var snapshot: Snapshot

    public internal(set) var value: Value {
        get {
            return snapshot.value
        }
        set {
            snapshot = Snapshot(value: newValue, date: Date())
        }
    }

    public var typeErasedValue: Any? {
        return snapshot.value
    }

    public var date: Date {
        return snapshot.date
    }

    public var formatter: Formatter

    public var typeErasedFormatter: Foundation.Formatter {
        return formatter
    }

    public var publisher: Published<Snapshot>.Publisher {
        return $snapshot
    }

    public var typeErasedPublisher: AnyPublisher<AnySnapshot, Never> {
        return $snapshot.map { $0 as AnySnapshot }.eraseToAnyPublisher()
    }

    public required init(displayName: String, value: Value, formatter: Formatter = Formatter(), date: Date = Date()) {
        self.displayName = displayName
        self.formatter = formatter
        self.snapshot = Snapshot(value: value, date: date)
    }

}

extension ReadOnlyProperty: Equatable where Value: Equatable {
    public static func == (lhs: ReadOnlyProperty<Value, Formatter>, rhs: ReadOnlyProperty<Value, Formatter>) -> Bool {
        return
            lhs.displayName == rhs.displayName &&
            lhs.value == rhs.value &&
            lhs.date == rhs.date
    }
}

extension ReadOnlyProperty where Value: ExpressibleByNilLiteral {

    public convenience init(
        displayName: String,
        optionalValue: Value = nil,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.init(displayName: displayName, value: optionalValue, formatter: formatter, date: date)
    }

}
