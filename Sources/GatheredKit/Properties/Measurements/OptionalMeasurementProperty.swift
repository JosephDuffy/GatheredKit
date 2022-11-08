import Combine
import Foundation

@propertyWrapper
public final class OptionalMeasurementProperty<Unit: Foundation.Unit>: UpdatableProperty, Hashable {
    public typealias Value = Measurement<Unit>?

    public static func == (
        lhs: OptionalMeasurementProperty<Unit>,
        rhs: OptionalMeasurementProperty<Unit>
    ) -> Bool {
        lhs.id == rhs.id && lhs.snapshot == rhs.snapshot
    }

    public let id: PropertyIdentifier

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: some Property<Measurement<Unit>?> {
        asReadOnlyProperty
    }

    @Published
    public internal(set) var snapshot: Snapshot<Value>

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Measurement Properties

    public var measurement: Value {
        value
    }

    public let unit: Unit

    public var measuredValue: Double? {
        measurement?.value
    }

    // MARK: Initialisers

    public init(
        id: PropertyIdentifier,
        measurement: Measurement<Unit>,
        date: Date = Date()
    ) {
        self.id = id
        unit = measurement.unit
        snapshot = Snapshot(value: measurement, date: date)
    }

    public init(
        id: PropertyIdentifier,
        unit: Unit,
        value measuredValue: Double? = nil,
        date: Date = Date()
    ) {
        self.id = id
        self.unit = unit

        let measurement: Measurement<Unit>?
        if let measuredValue = measuredValue {
            measurement = Measurement(value: measuredValue, unit: unit)
        } else {
            measurement = nil
        }

        snapshot = Snapshot(value: measurement, date: date)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(snapshot)
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(_ value: Measurement<Unit>?, date: Date) -> Snapshot<Measurement<Unit>?> {
        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }

    @discardableResult
    public func updateMeasuredValue(
        _ measuredValue: Double?,
        date: Date = Date()
    ) -> Snapshot<Value> {
        if let measuredValue = measuredValue {
            return updateValue(Measurement(value: measuredValue, unit: unit), date: date)
        } else {
            return updateValue(nil, date: date)
        }
    }
}

extension OptionalMeasurementProperty where Unit: Foundation.Dimension {
    public convenience init(
        id: PropertyIdentifier,
        value measuredValue: Double? = nil,
        dimension: Unit = .baseUnit(),
        date: Date = Date()
    ) {
        self.init(
            id: id,
            unit: dimension,
            value: measuredValue,
            date: date
        )
    }
}
