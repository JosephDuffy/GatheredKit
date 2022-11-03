import CoreGraphics
import Combine
import Foundation
import GatheredKit

@propertyWrapper
public final class ResolutionProperty<Unit: UnitResolution>: UpdatableProperty, PropertiesProviding {
    public typealias Value = CGSize

    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
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

    public var projectedValue: some Property {
        self
    }

    public let unit: Unit

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Coodinate Properties

    @MeasurementProperty
    public private(set) var width: Measurement<Unit>

    @MeasurementProperty
    public private(set) var height: Measurement<Unit>

    public required init(
        id: PropertyIdentifier,
        value: CGSize,
        unit: Unit,
        date: Date = Date()
    ) {
        self.id = id
        self.unit = unit
        snapshot = Snapshot(value: value, date: date)
        _width = MeasurementProperty(
            id: id.childIdentifierForPropertyId("width"),
            value: value.width,
            unit: unit,
            date: date
        )
        _height = MeasurementProperty(
            id: id.childIdentifierForPropertyId("height"),
            value: value.height,
            unit: unit,
            date: date
        )
    }

    public func updateValue(_ value: CGSize, date: Date) -> Snapshot<CGSize> {
        _width.updateMeasuredValueIfDifferent(value.width, date: date)
        _height.updateMeasuredValueIfDifferent(value.height, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
