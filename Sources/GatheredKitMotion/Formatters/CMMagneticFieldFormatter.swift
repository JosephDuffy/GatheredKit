#if os(iOS) || os(watchOS)
import CoreMotion
import Foundation
import GatheredKit

public final class CMMagneticFieldFormatter: Formatter {
    public var measurementFormatter: MeasurementFormatter

    public init(measurementFormatter: MeasurementFormatter) {
        self.measurementFormatter = measurementFormatter
        super.init()
    }

    public override convenience init() {
        let measurementFormatter = MeasurementFormatter()
        self.init(measurementFormatter: measurementFormatter)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func string(for magneticField: CMMagneticField) -> String {
        let xMeasurement = Measurement(value: magneticField.x, unit: UnitMagneticField.microTesla)
        let yMeasurement = Measurement(value: magneticField.y, unit: UnitMagneticField.microTesla)
        let zMeasurement = Measurement(value: magneticField.z, unit: UnitMagneticField.microTesla)
        let x = measurementFormatter.string(from: xMeasurement)
        let y = measurementFormatter.string(from: yMeasurement)
        let z = measurementFormatter.string(from: zMeasurement)
        return [x, y, z].joined(separator: ", ")
    }

    public override func string(for obj: Any?) -> String? {
        guard let magneticField = obj as? CMMagneticField else { return nil }
        return string(for: magneticField)
    }
}
#endif
