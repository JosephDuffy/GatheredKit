import Foundation

@propertyWrapper
public final class MeasurementProperty<Unit: Foundation.Unit>: UpdatableProperty, Equatable {
    public typealias Value = Measurement<Unit>

    public static func == (lhs: MeasurementProperty<Unit>, rhs: MeasurementProperty<Unit>) -> Bool {
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

    public var projectedValue: ReadOnlyProperty<MeasurementProperty<Unit>> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    public internal(set) var snapshot: Snapshot<Value> {
        didSet {
            updateSubject.notifyUpdateListeners(of: snapshot)
        }
    }

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: MeasurementFormatter

    public var updatePublisher: AnyUpdatePublisher<Snapshot<Value>> {
        updateSubject.eraseToAnyUpdatePublisher()
    }

    private let updateSubject: UpdateSubject<Snapshot<Value>>

    // MARK: Measurement Properties

    public var measurement: Measurement<Unit> {
        value
    }

    public var unit: Unit {
        measurement.unit
    }

    public var measuredValue: Double {
        measurement.value
    }

    // MARK: Initialisers

    public init(
        displayName: String,
        measurement: Measurement<Unit>,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: measurement, date: date)
        updateSubject = .init()
    }

    public convenience init(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: unit)
        self.init(
            displayName: displayName, measurement: measurement, formatter: formatter, date: date
        )
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(
        _ value: Measurement<Unit>,
        date: Date
    ) -> Snapshot<Value> {
        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }

    @discardableResult
    public func updateMeasuredValue(
        _ measuredValue: Double,
        date: Date = Date()
    ) -> Snapshot<Value> {
        let measurement = Measurement(value: measuredValue, unit: measurement.unit)
        return updateValue(measurement, date: date)
    }

    /**
     Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: The new snapshot, or `nil` if the value was not different.
     */
    @discardableResult
    public func updateMeasuredValueIfDifferent(_ measuredValue: Double, date: Date = Date()) -> Snapshot<Value>? {
        guard measuredValue != self.measuredValue else { return nil }
        return updateMeasuredValue(measuredValue, date: date)
    }
}
