import Foundation

#if swift(>=4.2)
#else

extension UIScreen {
    static let brightnessDidChangeNotification: NSNotification.Name = .UIScreenBrightnessDidChange
}

extension UIDevice {
    static let batteryLevelDidChangeNotification: NSNotification.Name = .UIDeviceBatteryLevelDidChange
    static let batteryStateDidChangeNotification: NSNotification.Name = .UIDeviceBatteryStateDidChange
    static let proximityStateDidChangeNotification: NSNotification.Name = .UIDeviceProximityStateDidChange
    static let orientationDidChangeNotification: NSNotification.Name = .UIDeviceOrientationDidChange
}

#endif
