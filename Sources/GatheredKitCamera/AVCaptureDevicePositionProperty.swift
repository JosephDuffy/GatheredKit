import AVFoundation
import GatheredKit

@available(macOS 10.7, iOS 4, macCatalyst 14, *)
@available(tvOS, unavailable)
public typealias AVCaptureDevicePositionProperty = BasicProperty<AVCaptureDevice.Position, AVCaptureDevicePositionFormatter>

@available(macOS 10.7, iOS 4, macCatalyst 14, *)
@available(tvOS, unavailable)
public typealias OptionalAVCaptureDevicePositionProperty = BasicProperty<AVCaptureDevice.Position?, AVCaptureDevicePositionFormatter>
