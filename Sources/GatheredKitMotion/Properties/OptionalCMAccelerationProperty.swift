#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMAccelerationProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CMAcceleration?

    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
        [$x, $y, $z]
    }

    @OptionalAccelerationProperty
    public private(set) var x: Measurement<UnitAcceleration>?

    @OptionalAccelerationProperty
    public private(set) var y: Measurement<UnitAcceleration>?

    @OptionalAccelerationProperty
    public private(set) var z: Measurement<UnitAcceleration>?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: some Property<CMAcceleration?> {
        asReadOnlyProperty
    }

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

        _x = .gravity(
            id: id.childIdentifierForPropertyId("x"),
            value: value?.x,
            date: date
        )
        _y = .gravity(
            id: id.childIdentifierForPropertyId("y"),
            value: value?.y,
            date: date
        )
        _z = .gravity(
            id: id.childIdentifierForPropertyId("z"),
            value: value?.z,
            date: date
        )
    }

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _x.updateMeasuredValue(value?.x, date: date)
        _y.updateMeasuredValue(value?.y, date: date)
        _z.updateMeasuredValue(value?.z, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
