#if os(iOS) || os(watchOS)
import CoreMotion
import Foundation
import GatheredKit

// TODO: Add rotationMatrix

@propertyWrapper
public final class OptionalCMAttitudeProperty: UpdatableProperty, PropertiesProvider {
    public typealias Value = CMAttitude?
    public typealias Formatter = CMAttitudeFormatter

    // MARK: `CMAttitude` Properties

    public var allProperties: [AnyProperty] {
        [$roll, $pitch, $yaw, $quaternion]
    }

    @OptionalAngleProperty
    public private(set) var roll: Measurement<UnitAngle>?

    @OptionalAngleProperty
    public private(set) var pitch: Measurement<UnitAngle>?

    @OptionalAngleProperty
    public private(set) var yaw: Measurement<UnitAngle>?

    @OptionalCMQuaternionProperty
    public private(set) var quaternion: CMQuaternion?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<OptionalCMAttitudeProperty> {
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
        updateSubject.eraseToAnyUpdatePublisher()
    }

    private let updateSubject: UpdateSubject<Snapshot<Value>>

    // MARK: Initialisers

    public init(
        displayName: String, value: Value = nil,
        formatter: CMAttitudeFormatter = CMAttitudeFormatter(), date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
        updateSubject = .init()

        _roll = .radians(displayName: "Roll", value: value?.roll, date: date)
        _pitch = .radians(displayName: "Pitch", value: value?.pitch, date: date)
        _yaw = .radians(displayName: "Yaw", value: value?.yaw, date: date)
        _quaternion = .init(displayName: "Quaternion", value: value?.quaternion, date: date)
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(_ value: Value, date: Date = Date()) -> Snapshot<Value> {
        _roll.updateMeasuredValue(value?.roll, date: date)
        _pitch.updateMeasuredValue(value?.pitch, date: date)
        _yaw.updateMeasuredValue(value?.yaw, date: date)
        _quaternion.updateValue(value?.quaternion, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
