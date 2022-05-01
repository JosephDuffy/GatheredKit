#if os(iOS) || os(watchOS)
import CoreMotion
import Foundation

public final class CMAttitudeFormatter: Formatter {
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

    public func string(for property: CMAttitudeProperty) -> String {
        let roll = measurementFormatter.string(from: property.$roll.measurement)
        let pitch = measurementFormatter.string(from: property.$pitch.measurement)
        let yaw = measurementFormatter.string(from: property.$yaw.measurement)
        return [roll, pitch, yaw].joined(separator: ", ")
    }

    public override func string(for obj: Any?) -> String? {
        guard let magneticField = obj as? CMMagneticField else { return nil }
        return string(for: magneticField)
    }

    public override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        #warning("TODO: Implement")
        fatalError("Unimplemented")
    }
}
#endif
