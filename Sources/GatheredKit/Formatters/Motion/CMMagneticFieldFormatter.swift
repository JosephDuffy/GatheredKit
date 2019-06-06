import Foundation
import CoreMotion

public final class CMMagneticFieldFormatter: Formatter {
    
    public var measurementFormatter: MeasurementFormatter

    public init(measurementFormatter: MeasurementFormatter) {
        self.measurementFormatter = measurementFormatter
        super.init()
    }
    
    public convenience override init() {
        let measurementFormatter = MeasurementFormatter()
        self.init(measurementFormatter: measurementFormatter)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func string(for magneticField: CMMagneticField) -> String {
        let xMeasurement = Measurement(value: magneticField.x, unit: UnitMagneticField.microTesla)
        let yMeasurement = Measurement(value: magneticField.x, unit: UnitMagneticField.microTesla)
        let zMeasurement = Measurement(value: magneticField.x, unit: UnitMagneticField.microTesla)
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
