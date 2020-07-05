import Foundation
import CoreLocation
import GatheredKitCore

@propertyWrapper
public final class OptionalCoordinateProperty: Property, PropertiesProvider {
    public typealias Value = CLLocationCoordinate2D?

    public var allProperties: [AnyProperty] {
        return [
            $latitude,
            $longitude,
        ]
    }

    public var wrappedValue: CLLocationCoordinate2D? {
        get {
            return snapshot.value
        }
        set {
            update(value: newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<OptionalCoordinateProperty> {
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
    public let formatter: CoordinateFormatter

    public var updatePublisher: AnyUpdatePublisher<Snapshot<Value>> {
        return updateSubject.eraseToAnyUpdatePublisher()
    }

    private let updateSubject: UpdateSubject<Snapshot<Value>>

    // MARK: Coodinate Properties

    @OptionalAngleProperty
    public private(set) var latitude: Measurement<UnitAngle>?

    @OptionalAngleProperty
    public private(set) var longitude: Measurement<UnitAngle>?

    public required init(displayName: String, value: CLLocationCoordinate2D? = nil, formatter: CoordinateFormatter = CoordinateFormatter(), date: Date = Date()) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
        updateSubject = .init()
        _latitude = .degrees(displayName: "Latitude", value: value?.latitude, date: date)
        _longitude = .degrees(displayName: "Longitude", value: value?.longitude, date: date)
    }

    public func update(value: CLLocationCoordinate2D?, date: Date = Date()) {
        _latitude.updateValueIfDifferent(value?.latitude, date: date)
        _longitude.updateValueIfDifferent(value?.longitude, date: date)

        snapshot = Snapshot(value: value, date: date)
    }

}
