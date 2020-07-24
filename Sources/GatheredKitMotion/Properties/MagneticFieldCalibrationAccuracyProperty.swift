#if canImport(CoreMotion)
import CoreMotion
import GatheredKitCore

public typealias CMMagneticFieldCalibrationAccuracyProperty = BasicProperty<
    CMMagneticFieldCalibrationAccuracy, MagneticFieldCalibrationAccuracyFormatter
>
public typealias OptionalCMMagneticFieldCalibrationAccuracyProperty = BasicProperty<
    CMMagneticFieldCalibrationAccuracy?, MagneticFieldCalibrationAccuracyFormatter
>
#endif
