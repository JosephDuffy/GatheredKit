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

    public var measurement: Value {
        return value
    }

    public private(set) var unit: Unit

    public var measuredValue: Double? {
        return measurement?.value
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
        unit = measurement.unit
        snapshot = Snapshot(value: measurement, date: date)
        updateSubject = .init()
    }

    public init(
        displayName: String,
        value measuredValue: Double? = nil,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        let measurement: Measurement<Unit>?
        if let measuredValue = measuredValue {
            measurement = Measurement(value: measuredValue, unit: unit)
        } else {
            measurement = nil
        }

        self.displayName = displayName
        self.formatter = formatter
        self.unit = unit
        snapshot = Snapshot(value: measurement, date: date)
        updateSubject = .init()
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(
        _ measurement: Measurement<Unit>?,
        date: Date = Date()
    ) -> Snapshot<Value> {
        let snapshot = Snapshot(value: measurement, date: date)
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

    /**
     Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: The new snapshot, or `nil` if the value was not different.
     */
    @discardableResult
    public func updateMeasuredValueIfDifferent(_ measuredValue: Double?, date: Date = Date()) -> Snapshot<Value>? {
        guard measuredValue != measurement?.value else { return nil }
        return updateMeasuredValue(measuredValue, date: date)
    }
}

extension OptionalMeasurementProperty where Unit: Foundation.Dimension {
    public convenience init(
        displayName: String,
        value measuredValue: Double? = nil,
        dimention: Unit = .baseUnit(),
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        self.init(
            displayName: displayName, value: measuredValue, unit: dimention, formatter: formatter,
            date: date)
    }
}
