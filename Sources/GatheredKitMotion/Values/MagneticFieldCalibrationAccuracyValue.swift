#if canImport(CoreMotion)
import CoreMotion
import GatheredKitCore

public final class MagneticFieldCalibrationAccuracyValue: Property<CMMagneticFieldCalibrationAccuracy, MagneticFieldCalibrationAccuracyFormatter> { }
public final class OptionalMagneticFieldCalibrationAccuracyValue: OptionalProperty<CMMagneticFieldCalibrationAccuracy?, MagneticFieldCalibrationAccuracyFormatter> { }
#endif
