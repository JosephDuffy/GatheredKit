#if canImport(CoreMotion)
import CoreMotion
import GatheredKit

@available(macOS, unavailable)
public typealias CMMagneticFieldCalibrationAccuracyProperty = BasicProperty<CMMagneticFieldCalibrationAccuracy, MagneticFieldCalibrationAccuracyFormatter>

@available(macOS, unavailable)
public typealias OptionalCMMagneticFieldCalibrationAccuracyProperty = BasicProperty<CMMagneticFieldCalibrationAccuracy?, MagneticFieldCalibrationAccuracyFormatter>
#endif
