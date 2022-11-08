#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMQuaternionProperty: UpdatableProperty, PropertiesProviding, Identifiable {
    public typealias Value = CMQuaternion?

    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
        [
            $x,
            $y,
            $z,
            $w,
        ]
    }

    @OptionalDoubleProperty
    public private(set) var x: Double?

    @OptionalDoubleProperty
    public private(set) var y: Double?

    @OptionalDoubleProperty
    public private(set) var z: Double?

    @OptionalDoubleProperty
    public private(set) var w: Double?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: some Property<CMQuaternion?> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        id: PropertyIdentifier,
        value: Value = nil,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)

        _x = .init(
            id: id.childIdentifierForPropertyId("x"),
            value: value?.x,
            date: date
        )
        _y = .init(
            id: id.childIdentifierForPropertyId("y"),
            value: value?.y,
            date: date
        )
        _z = .init(
            id: id.childIdentifierForPropertyId("z"),
            value: value?.z,
            date: date
        )
        _w = .init(
            id: id.childIdentifierForPropertyId("w"),
            value: value?.w,
            date: date
        )
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _x.updateValue(value?.x, date: date)
        _y.updateValue(value?.y, date: date)
        _z.updateValue(value?.z, date: date)
        _w.updateValue(value?.w, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
