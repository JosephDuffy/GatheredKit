#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKitCore

@propertyWrapper
public final class CMCalibratedMagneticFieldProperty: BasicProperty<CMCalibratedMagneticField, CMMagneticFieldFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$accuracy, $field]
    }

    @CMMagneticFieldCalibrationAccuracyProperty
    public private(set) var accuracy: CMMagneticFieldCalibrationAccuracy

    @CMMagneticFieldProperty
    public private(set) var field: CMMagneticField

    public override var wrappedValue: CMCalibratedMagneticField {
           get {
               return super.wrappedValue
           }
           set {
               super.wrappedValue = newValue
           }
       }

    public override var projectedValue: ReadOnlyProperty<CMCalibratedMagneticField, CMMagneticFieldFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMCalibratedMagneticField, formatter: CMMagneticFieldFormatter = CMMagneticFieldFormatter(), date: Date = Date()) {
        _accuracy = .init(displayName: "Accuracy", value: value.accuracy, date: date)
        _field = .init(displayName: "Field", value: value.field, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMCalibratedMagneticField, date: Date = Date()) {
        _accuracy.updateValueIfDifferent(value.accuracy, date: date)
        _field.update(value: value.field, date: date)

        super.update(value: value, date: date)
    }

}

@propertyWrapper
public final class OptionalCMCalibratedMagneticFieldProperty: BasicProperty<CMCalibratedMagneticField?, CMMagneticFieldFormatter>, PropertiesProvider {

        public var allProperties: [AnyProperty] {
            return [$accuracy, $field]
        }

        @OptionalCMMagneticFieldCalibrationAccuracyProperty
        public private(set) var accuracy: CMMagneticFieldCalibrationAccuracy?

        @OptionalCMMagneticFieldProperty
        public private(set) var field: CMMagneticField?

        public override var wrappedValue: CMCalibratedMagneticField? {
               get {
                   return super.wrappedValue
               }
               set {
                   super.wrappedValue = newValue
               }
           }

        public override var projectedValue: ReadOnlyProperty<CMCalibratedMagneticField?, CMMagneticFieldFormatter> { return super.projectedValue }

        public required init(displayName: String, value: CMCalibratedMagneticField? = nil, formatter: CMMagneticFieldFormatter = CMMagneticFieldFormatter(), date: Date = Date()) {
            _accuracy = .init(displayName: "Accuracy", value: value?.accuracy, date: date)
            _field = .init(displayName: "Field", value: value?.field, date: date)

            super.init(displayName: displayName, value: value, formatter: formatter, date: date)
        }

        public override func update(value: CMCalibratedMagneticField?, date: Date = Date()) {
            _accuracy.updateValueIfDifferent(value?.accuracy, date: date)
            _field.update(value: value?.field, date: date)

            super.update(value: value, date: date)
        }

    }
#endif
