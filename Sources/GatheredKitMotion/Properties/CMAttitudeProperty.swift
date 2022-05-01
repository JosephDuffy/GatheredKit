#if os(iOS) || os(watchOS)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@propertyWrapper
public final class CMAttitudeProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CMAttitude
    public typealias Formatter = CMAttitudeFormatter

    // MARK: `CMAttitude` Properties

    public var allProperties: [AnyProperty] {
        [$roll, $pitch, $yaw, $quaternion]
    }

    @AngleProperty
    public private(set) var roll: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var pitch: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var yaw: Measurement<UnitAngle>

    @CMQuaternionProperty
    public private(set) var quaternion: CMQuaternion

    @CMRotationMatrixProperty
    public private(set) var rotationMatrix: CMRotationMatrix

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
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: Formatter

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public init(
        displayName: String, value: CMAttitude,
        formatter: CMAttitudeFormatter = CMAttitudeFormatter(), date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)

        _roll = .radians(displayName: "Roll", value: value.roll, date: date)
        _pitch = .radians(displayName: "Pitch", value: value.pitch, date: date)
        _yaw = .radians(displayName: "Yaw", value: value.yaw, date: date)
        _quaternion = .init(displayName: "Quaternion", value: value.quaternion, date: date)
        _rotationMatrix = .init(displayName: "Rotation Matrix", value: value.rotationMatrix, date: date)
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(_ value: CMAttitude, date: Date) -> Snapshot<Value> {
        _roll.updateMeasuredValue(value.roll, date: date)
        _pitch.updateMeasuredValue(value.pitch, date: date)
        _yaw.updateMeasuredValue(value.yaw, date: date)
        _quaternion.updateValue(value.quaternion, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
