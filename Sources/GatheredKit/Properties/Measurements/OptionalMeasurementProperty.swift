import Combine
import Foundation

@propertyWrapper
public final class OptionalMeasurementProperty<Unit: Foundation.Unit>: UpdatableProperty, Equatable {
    public typealias Value = Measurement<Unit>?

    public static func == (
        lhs: OptionalMeasurementProperty<Unit>, rhs: OptionalMeasurementProperty<Unit>
    ) -> Bool {
        lhs.displayName == rhs.displayName && lhs.snapshot == rhs.snapshot
    }

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<OptionalMeasurementProperty<Unit>> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    /// A human-friendly display name that describes the property.
    public let displayName: String

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
        displayName: String,
        measurement: Measurement<Unit>,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        unit = measurement.unit
        snapshot = Snapshot(value: measurement, date: date)
    }

    public init(
        displayName: String,
        value measuredValue: Double? = nil,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.unit = unit

        let measurement: Measurement<Unit>?
        if let measuredValue = measuredValue {
            measurement = Measurement(value: measuredValue, unit: unit)
        } else {
            measurement = nil
        }

        snapshot = Snapshot(value: measurement, date: date)
    }

    public init(
        unit: Unit,
        value measuredValue: Double? = nil,
        date: Date = Date()
    ) {
        self.displayName = ""
        self.unit = unit

        let measurement: Measurement<Unit>?
        if let measuredValue = measuredValue {
            measurement = Measurement(value: measuredValue, unit: unit)
        } else {
            measurement = nil
        }

        snapshot = Snapshot(value: measurement, date: date)
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
        displayName: String,
        value measuredValue: Double? = nil,
        dimension: Unit = .baseUnit(),
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        self.init(
            displayName: displayName,
            value: measuredValue,
            unit: dimension,
            formatter: formatter,
            date: date
        )
    }
}
