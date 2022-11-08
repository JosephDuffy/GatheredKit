#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMRotationMatrixProperty: UpdatableProperty, PropertiesProviding, Identifiable {
    public typealias Value = CMRotationMatrix?

    public let id: PropertyIdentifier

    // MARK: `CMRotationMatrix` Properties

    public var allProperties: [any Property] {
        [$m11, $m12, $m13, $m21, $m22, $m23, $m31, $m32, $m33]
    }

    @OptionalDoubleProperty
    public private(set) var m11: Double?

    @OptionalDoubleProperty
    public private(set) var m12: Double?

    @OptionalDoubleProperty
    public private(set) var m13: Double?

    @OptionalDoubleProperty
    public private(set) var m21: Double?

    @OptionalDoubleProperty
    public private(set) var m22: Double?

    @OptionalDoubleProperty
    public private(set) var m23: Double?

    @OptionalDoubleProperty
    public private(set) var m31: Double?

    @OptionalDoubleProperty
    public private(set) var m32: Double?

    @OptionalDoubleProperty
    public private(set) var m33: Double?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: some Property<CMRotationMatrix?> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public init(
        id: PropertyIdentifier,
        value: CMRotationMatrix? = nil,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)

        _m11 = .init(
            id: id.childIdentifierForPropertyId("m11"),
            value: value?.m11,
            date: date
        )
        _m12 = .init(
            id: id.childIdentifierForPropertyId("m12"),
            value: value?.m12,
            date: date
        )
        _m13 = .init(
            id: id.childIdentifierForPropertyId("m13"),
            value: value?.m13,
            date: date
        )
        _m21 = .init(
            id: id.childIdentifierForPropertyId("m21"),
            value: value?.m21,
            date: date
        )
        _m22 = .init(
            id: id.childIdentifierForPropertyId("m22"),
            value: value?.m22,
            date: date
        )
        _m23 = .init(
            id: id.childIdentifierForPropertyId("m23"),
            value: value?.m23,
            date: date
        )
        _m31 = .init(
            id: id.childIdentifierForPropertyId("m31"),
            value: value?.m31,
            date: date
        )
        _m32 = .init(
            id: id.childIdentifierForPropertyId("m32"),
            value: value?.m32,
            date: date
        )
        _m33 = .init(
            id: id.childIdentifierForPropertyId("m33"),
            value: value?.m33,
            date: date
        )
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(_ value: CMRotationMatrix?, date: Date) -> Snapshot<CMRotationMatrix?> {
        _m11.updateValue(value?.m11, date: date)
        _m12.updateValue(value?.m12, date: date)
        _m13.updateValue(value?.m13, date: date)
        _m21.updateValue(value?.m21, date: date)
        _m22.updateValue(value?.m22, date: date)
        _m23.updateValue(value?.m23, date: date)
        _m31.updateValue(value?.m31, date: date)
        _m32.updateValue(value?.m32, date: date)
        _m33.updateValue(value?.m33, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
