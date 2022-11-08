#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMMagneticFieldProperty: UpdatableProperty, PropertiesProviding {
    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
        [$x, $y, $z]
    }

    @OptionalMagneticFieldProperty
    public private(set) var x: Measurement<UnitMagneticField>?

    @OptionalMagneticFieldProperty
    public private(set) var y: Measurement<UnitMagneticField>?

    @OptionalMagneticFieldProperty
    public private(set) var z: Measurement<UnitMagneticField>?

    // MARK: Property Wrapper Properties

    public var wrappedValue: CMMagneticField? {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: some Property<CMMagneticField?> {
        asReadOnlyProperty
    }

    @Published
    public internal(set) var snapshot: Snapshot<CMMagneticField?>

    public var snapshotsPublisher: AnyPublisher<Snapshot<CMMagneticField?>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        id: PropertyIdentifier,
        value: CMMagneticField? = nil,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)

        _x = .microTesla(
            id: id.childIdentifierForPropertyId("x"),
            value: value?.x,
            date: date
        )
        _y = .microTesla(
            id: id.childIdentifierForPropertyId("y"),
            value: value?.y,
            date: date
        )
        _z = .microTesla(
            id: id.childIdentifierForPropertyId("z"),
            value: value?.z,
            date: date
        )
    }

    @discardableResult
    public func updateValue(_ value: CMMagneticField?, date: Date) -> Snapshot<Value> {
        _x.updateMeasuredValue(value?.x, date: date)
        _y.updateMeasuredValue(value?.y, date: date)
        _z.updateMeasuredValue(value?.z, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
