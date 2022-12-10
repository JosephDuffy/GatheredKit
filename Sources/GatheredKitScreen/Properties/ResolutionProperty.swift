import CoreGraphics
import Combine
import Foundation
import GatheredKit

@propertyWrapper
public final class ResolutionProperty: UpdatableProperty, PropertiesProviding {
    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
        [
            $width,
            $height,
        ]
    }

    public var wrappedValue: ResolutionMeasurement {
        get {
            snapshot.value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: some Property<ResolutionMeasurement> {
        self
    }

    public var size: CGSize {
        measurement.size
    }

    public var unit: UnitResolution {
        measurement.unit
    }

    public let measurement: ResolutionMeasurement

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<ResolutionMeasurement>

    public var snapshotsPublisher: AnyPublisher<Snapshot<ResolutionMeasurement>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Coodinate Properties

    @MeasurementProperty
    public private(set) var width: Measurement<UnitResolution>

    @MeasurementProperty
    public private(set) var height: Measurement<UnitResolution>

    public required init(
        id: PropertyIdentifier,
        measurement: ResolutionMeasurement,
        date: Date = Date()
    ) {
        self.id = id
        self.measurement = measurement
        snapshot = Snapshot(value: measurement, date: date)
        _width = MeasurementProperty(
            id: id.childIdentifierForPropertyId("width"),
            measurement: measurement.width,
            date: date
        )
        _height = MeasurementProperty(
            id: id.childIdentifierForPropertyId("height"),
            measurement: measurement.height,
            date: date
        )
    }

    @discardableResult
    public func updateMeasuredValue(
        _ size: CGSize,
        date: Date = Date()
    ) -> Snapshot<ResolutionMeasurement> {
        _width.updateMeasuredValue(size.width, date: date)
        _height.updateMeasuredValue(size.height, date: date)

        let snapshot = Snapshot(
            value: ResolutionMeasurement(size: size, unit: unit),
            date: date
        )
        self.snapshot = snapshot
        return snapshot
    }

    @discardableResult
    public func updateMeasuredValueIfDifferent(
        _ size: CGSize,
        date: Date = Date()
    ) -> Snapshot<ResolutionMeasurement> {
        guard size != self.size else { return snapshot }

        _width.updateMeasuredValueIfDifferent(size.width, date: date)
        _height.updateMeasuredValueIfDifferent(size.height, date: date)

        let snapshot = Snapshot(
            value: ResolutionMeasurement(size: size, unit: unit),
            date: date
        )
        self.snapshot = snapshot
        return snapshot
    }

    @discardableResult
    public func updateValue(
        _ value: ResolutionMeasurement,
        date: Date = Date()
    ) -> Snapshot<ResolutionMeasurement> {
        _width.updateValueIfDifferent(value.width)
        _height.updateValueIfDifferent(value.height)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
