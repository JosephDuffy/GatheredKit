import CoreMotion

/// A shim around `CMAbsoluteAltitudeData`. This object can only be initialised
/// on iOS 15 and watchOS 8 or higher.
@available(macOS, unavailable)
public final class CMAbsoluteAltitudeDataShim: CMLogItem {
    /// The absolute altitude of the device in meters relative to sea level; could be positive or negative.
    public var altitude: Double {
        if #available(iOS 15, watchOS 8, *) {
            return cmAbsoluteAltitudeData.altitude
        } else {
            return 0
        }
    }

    /// The accuracy of the altitude estimate, in meters.
    public var accuracy: Double {
        if #available(iOS 15, watchOS 8, *) {
            return cmAbsoluteAltitudeData.accuracy
        } else {
            return 0
        }
    }

    /// The precision of the altitude estimate, in meters.
    public var precision: Double {
        if #available(iOS 15, watchOS 8, *) {
            return cmAbsoluteAltitudeData.precision
        } else {
            return 0
        }
    }

    public override var timestamp: TimeInterval {
        if #available(iOS 15, watchOS 8, *) {
            return cmAbsoluteAltitudeData.timestamp
        } else {
            return 0
        }
    }

    @available(iOS 15, watchOS 8, *)
    public var cmAbsoluteAltitudeData: CMAbsoluteAltitudeData {
        backingData as! CMAbsoluteAltitudeData
    }

    private let backingData: Any

    @available(iOS 15.0, watchOS 8, *)
    public init(cmAbsoluteAltitudeData: CMAbsoluteAltitudeData) {
        self.backingData = cmAbsoluteAltitudeData

        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
