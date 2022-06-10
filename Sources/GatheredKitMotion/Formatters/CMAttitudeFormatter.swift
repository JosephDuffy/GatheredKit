import CoreMotion
import Foundation

@available(macOS, unavailable)
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

    public func string(for attitude: CMAttitude) -> String {
        let roll = measurementFormatter.string(
            from: Measurement(value: attitude.roll, unit: UnitAngle.radians)
        )
        let pitch = measurementFormatter.string(
            from: Measurement(value: attitude.pitch, unit: UnitAngle.radians)
        )
        let yaw = measurementFormatter.string(
            from: Measurement(value: attitude.yaw, unit: UnitAngle.radians)
        )
        return [roll, pitch, yaw].joined(separator: ", ")
    }

    public override func string(for obj: Any?) -> String? {
        guard let attitude = obj as? CMAttitude else { return nil }
        return string(for: attitude)
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // It's not possible to construct a `CMAttitude`.
        false
    }
}
