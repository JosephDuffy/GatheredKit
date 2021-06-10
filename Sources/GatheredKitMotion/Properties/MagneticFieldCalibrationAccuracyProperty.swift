#if canImport(CoreMotion)
import CoreMotion
import GatheredKit

public typealias CMMagneticFieldCalibrationAccuracyProperty = BasicProperty<
    CMMagneticFieldCalibrationAccuracy, MagneticFieldCalibrationAccuracyFormatter
>
public typealias OptionalCMMagneticFieldCalibrationAccuracyProperty = BasicProperty<
    CMMagneticFieldCalibrationAccuracy?, MagneticFieldCalibrationAccuracyFormatter
>
#endif
