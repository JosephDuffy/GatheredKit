import CoreMotion
import Foundation

@available(macOS, unavailable)
open class CMCalibratedMagneticFieldFormatter: Formatter {
    public var magneticFieldFormatter: CMMagneticFieldFormatter

    public var magneticFieldCalibrationAccuracyFormatter: MagneticFieldCalibrationAccuracyFormatter

    public required init(
        magneticFieldFormatter: CMMagneticFieldFormatter,
        magneticFieldCalibrationAccuracyFormatter: MagneticFieldCalibrationAccuracyFormatter
    ) {
        self.magneticFieldFormatter = magneticFieldFormatter
        self.magneticFieldCalibrationAccuracyFormatter = magneticFieldCalibrationAccuracyFormatter

        super.init()
    }

    public convenience init(
        measurementFormatter: MeasurementFormatter,
        magneticFieldCalibrationAccuracyFormatter: MagneticFieldCalibrationAccuracyFormatter
    ) {
        let magneticFieldFormatter = CMMagneticFieldFormatter(
            measurementFormatter: measurementFormatter
        )
        self.init(
            magneticFieldFormatter: magneticFieldFormatter,
            magneticFieldCalibrationAccuracyFormatter: magneticFieldCalibrationAccuracyFormatter
        )
    }

    public override convenience init() {
        let magneticFieldFormatter = CMMagneticFieldFormatter()
        let magneticFieldCalibrationAccuracyFormatter = MagneticFieldCalibrationAccuracyFormatter()
        self.init(
            magneticFieldFormatter: magneticFieldFormatter,
            magneticFieldCalibrationAccuracyFormatter: magneticFieldCalibrationAccuracyFormatter
        )
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func string(for magneticField: CMCalibratedMagneticField) -> String {
        let field = magneticFieldFormatter.string(for: magneticField.field)
        return field + " (" + magneticFieldCalibrationAccuracyFormatter.string(for: magneticField.accuracy) + " accuracy)"
    }

    public override func string(for obj: Any?) -> String? {
        guard let magneticField = obj as? CMCalibratedMagneticField else { return nil }
        return string(for: magneticField)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `CMCalibratedMagneticField` is not a class.
        false
    }
}
