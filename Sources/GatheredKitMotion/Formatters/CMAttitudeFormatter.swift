#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion

public final class CMAttitudeFormatter: Formatter {

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

    public func string(for acceleration: CMAttitude) -> String {
        let property = CMAttitudeProperty(displayName: "", value: acceleration)
        let roll = measurementFormatter.string(from: property.$roll.measurement)
        let pitch = measurementFormatter.string(from: property.$pitch.measurement)
        let yaw = measurementFormatter.string(from: property.$yaw.measurement)
        return [roll, pitch, yaw].joined(separator: ", ")
    }

    public override func string(for obj: Any?) -> String? {
        guard let magneticField = obj as? CMMagneticField else { return nil }
        return string(for: magneticField)
    }

}
#endif
