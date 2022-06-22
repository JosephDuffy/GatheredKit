#if canImport(CoreMotion)
import CoreMotion
import Foundation

@available(macOS, unavailable)
public final class CMAccelerationFormatter: Formatter {
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

    public func string(for acceleration: CMAcceleration) -> String {
        let xMeasurement = Measurement(value: acceleration.x, unit: UnitAcceleration.gravity)
        let yMeasurement = Measurement(value: acceleration.y, unit: UnitAcceleration.gravity)
        let zMeasurement = Measurement(value: acceleration.z, unit: UnitAcceleration.gravity)
        let x = measurementFormatter.string(from: xMeasurement)
        let y = measurementFormatter.string(from: yMeasurement)
        let z = measurementFormatter.string(from: zMeasurement)
        return [x, y, z].joined(separator: ", ")
    }

    public override func string(for obj: Any?) -> String? {
        guard let magneticField = obj as? CMMagneticField else { return nil }
        return string(for: magneticField)
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `CMAcceleration` is not a class.
        false
    }
}
#endif
