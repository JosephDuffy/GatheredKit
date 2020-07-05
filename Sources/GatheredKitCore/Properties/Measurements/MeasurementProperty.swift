import Foundation

@propertyWrapper
public final class MeasurementProperty<Unit: Foundation.Unit>: Property, Equatable {
    public typealias Value = Measurement<Unit>

    public static func == (lhs: MeasurementProperty<Unit>, rhs: MeasurementProperty<Unit>) -> Bool {
        lhs.displayName == rhs.displayName &&
            lhs.snapshot == rhs.snapshot
    }

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            update(measurement: newValue)
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
        return updateSubject.eraseToAnyUpdatePublisher()
    }

    private let updateSubject: UpdateSubject<Snapshot<Value>>

    // MARK: Measurement Properties

    public var measurement: Measurement<Unit> {
        return value
    }

    public var unit: Unit {
        return measurement.unit
    }

    public var measuredValue: Double {
        return measurement.value
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
        self.init(displayName: displayName, measurement: measurement, formatter: formatter, date: date)
    }

    // MARK: Update Functions

    public func update(
        measurement: Measurement<Unit>,
        date: Date = Date()
    ) {
        snapshot = Snapshot(value: measurement, date: date)
    }

    public func update(
        value: Double,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: self.measurement.unit)
        self.update(measurement: measurement, date: date)
    }

    /**
    Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: `true` if the value was updated, otherwise `false`.
     */
    @discardableResult
    public func updateValueIfDifferent(_ value: Double, date: Date = Date()) -> Bool {
        guard value != measurement.value else { return false }
        update(value: value, date: date)
        return true
    }

}
