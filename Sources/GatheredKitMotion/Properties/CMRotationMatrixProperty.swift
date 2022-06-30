#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class CMRotationMatrixProperty: UpdatableProperty, PropertiesProviding, @unchecked Sendable {
    public typealias Value = CMRotationMatrix
    public typealias Formatter = CMRotationMatrixFormatter

    // MARK: `CMRotationMatrix` Properties

    public var allProperties: [AnyProperty] {
        [$m11, $m12, $m13, $m21, $m22, $m23, $m31, $m32, $m33]
    }

    @DoubleProperty
    public private(set) var m11: Double

    @DoubleProperty
    public private(set) var m12: Double

    @DoubleProperty
    public private(set) var m13: Double

    @DoubleProperty
    public private(set) var m21: Double

    @DoubleProperty
    public private(set) var m22: Double

    @DoubleProperty
    public private(set) var m23: Double

    @DoubleProperty
    public private(set) var m31: Double

    @DoubleProperty
    public private(set) var m32: Double

    @DoubleProperty
    public private(set) var m33: Double

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<CMRotationMatrixProperty> {
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
    public let formatter: CMRotationMatrixFormatter

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    private let updatesLock = NSLock()

    // MARK: Initialisers

    public init(
        displayName: String,
        value: CMRotationMatrix,
        formatter: CMRotationMatrixFormatter = CMRotationMatrixFormatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)

        _m11 = .init(displayName: "m11", value: value.m11, date: date)
        _m12 = .init(displayName: "m12", value: value.m12, date: date)
        _m13 = .init(displayName: "m13", value: value.m13, date: date)
        _m21 = .init(displayName: "m21", value: value.m21, date: date)
        _m22 = .init(displayName: "m22", value: value.m22, date: date)
        _m23 = .init(displayName: "m23", value: value.m23, date: date)
        _m31 = .init(displayName: "m31", value: value.m31, date: date)
        _m32 = .init(displayName: "m32", value: value.m32, date: date)
        _m33 = .init(displayName: "m33", value: value.m33, date: date)
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(_ value: CMRotationMatrix, date: Date) -> Snapshot<CMRotationMatrix> {
        updatesLock.lock()
        defer {
            updatesLock.unlock()
        }

        _m11.updateValue(value.m11, date: date)
        _m12.updateValue(value.m12, date: date)
        _m13.updateValue(value.m13, date: date)
        _m21.updateValue(value.m21, date: date)
        _m22.updateValue(value.m22, date: date)
        _m23.updateValue(value.m23, date: date)
        _m31.updateValue(value.m31, date: date)
        _m32.updateValue(value.m32, date: date)
        _m33.updateValue(value.m33, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
