#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKitCore

// TODO: Add rotationMatrix

@propertyWrapper
public final class CMAttitudeProperty: Property, PropertiesProvider {
    public typealias Value = CMAttitude
    public typealias Formatter = CMAttitudeFormatter

    // MARK: `CMAttitude` Properties

    public var allProperties: [AnyProperty] {
        return [$roll, $pitch, $yaw, $quaternion]
    }

    @AngleProperty
    public private(set) var roll: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var pitch: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var yaw: Measurement<UnitAngle>

    @CMQuaternionProperty
    public private(set) var quaternion: CMQuaternion

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<CMAttitudeProperty> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// The latest snapshot of data.
    public internal(set) var snapshot: Snapshot<Value> {
        didSet {
            updateSubject.notifyUpdateListeners(of: snapshot)
        }
    }

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: Formatter

    public var updatePublisher: AnyUpdatePublisher<Snapshot<Value>> {
        return updateSubject.eraseToAnyUpdatePublisher()
    }

    private let updateSubject: UpdateSubject<Snapshot<Value>>

    // MARK: Initialisers

    public init(displayName: String, value: CMAttitude, formatter: CMAttitudeFormatter = CMAttitudeFormatter(), date: Date = Date()) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
        updateSubject = .init()

        _roll = .radians(displayName: "Roll", value: value.roll, date: date)
        _pitch = .radians(displayName: "Pitch", value: value.pitch, date: date)
        _yaw = .radians(displayName: "Yaw", value: value.yaw, date: date)
        _quaternion = .init(displayName: "Quaternion", value: value.quaternion, date: date)
    }

    // MARK: Update Functions

    public func updateValue(_ value: CMAttitude, date: Date = Date()) {
        _roll.updateValueIfDifferent(value.roll, date: date)
        _pitch.updateValueIfDifferent(value.pitch, date: date)
        _yaw.updateValueIfDifferent(value.yaw, date: date)
        _quaternion.updateValue(value.quaternion, date: date)

        snapshot = Snapshot(value: value, date: date)
    }
}
#endif
