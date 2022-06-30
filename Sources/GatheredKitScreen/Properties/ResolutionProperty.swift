import CoreGraphics
import Combine
import Foundation
import GatheredKit

@propertyWrapper
public final class ResolutionProperty<Unit: UnitResolution>: UpdatableProperty, PropertiesProviding {
    public typealias Value = CGSize

    public var allProperties: [AnyProperty] {
        [
            $width,
            $height,
        ]
    }

    public var wrappedValue: CGSize {
        get {
            snapshot.value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<ResolutionProperty> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: ResolutionFormatter

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Coodinate Properties

    @MeasurementProperty<UnitResolution>
    public private(set) var width: Measurement<UnitResolution>

    @MeasurementProperty<UnitResolution>
    public private(set) var height: Measurement<UnitResolution>

    public required init(
        displayName: String,
        value: CGSize,
        formatter: ResolutionFormatter,
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
        _width = MeasurementProperty(displayName: "Width", value: value.width, unit: formatter.unit, date: date)
        _height = MeasurementProperty(displayName: "Height", value: value.height,unit: formatter.unit, date: date)
    }

    public convenience init(
        displayName: String,
        value: CGSize,
        unit: UnitResolution,
        date: Date = Date()
    ) {
        self.init(displayName: displayName, value: value, formatter: ResolutionFormatter(unit: unit), date: date)
    }

    public func updateValue(_ value: CGSize, date: Date) -> Snapshot<CGSize> {
        _width.updateMeasuredValueIfDifferent(value.width, date: date)
        _height.updateMeasuredValueIfDifferent(value.height, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
