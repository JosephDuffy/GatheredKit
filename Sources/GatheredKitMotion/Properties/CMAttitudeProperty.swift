#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class CMAttitudeProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CMAttitude

    public let id: PropertyIdentifier

    // MARK: `CMAttitude` Properties

    public var allProperties: [any Property] {
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

    @Published
    public internal(set) var snapshot: Snapshot<Value>

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public init(
        id: PropertyIdentifier,
        value: CMAttitude,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)

        _roll = .radians(
            id: id.childIdentifierForPropertyId("roll"),
            value: value.roll,
            date: date
        )
        _pitch = .radians(
            id: id.childIdentifierForPropertyId("pitch"),
            value: value.pitch,
            date: date
        )
        _yaw = .radians(
            id: id.childIdentifierForPropertyId("yaw"),
            value: value.yaw,
            date: date
        )
        _quaternion = .init(
            id: id.childIdentifierForPropertyId("quaternion"),
            value: value.quaternion,
            date: date
        )
        _rotationMatrix = .init(
            id: id.childIdentifierForPropertyId("rotationMatrix"),
            value: value.rotationMatrix,
            date: date
        )
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
