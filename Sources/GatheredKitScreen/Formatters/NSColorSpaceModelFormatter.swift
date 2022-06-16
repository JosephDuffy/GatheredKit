#if os(macOS)
import AppKit

open class NSColorSpaceModelFormatter: Formatter {
    public override init() {
        super.init()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func string(for colorSpaceModel: NSColorSpace.Model) -> String {
        switch colorSpaceModel {
        case .unknown:
            return "Unknown"
        case .gray:
            return "Gray"
        case .rgb:
            return "RGB"
        case .cmyk:
            return "CMYK"
        case .lab:
            return "L*a*b*"
        case .deviceN:
            return "DeviceN"
        case .indexed:
            return "Indexed"
        case .patterned:
            return "Patterned"
        @unknown default:
            return "Unknown"
        }
    }

    public override func string(for obj: Any?) -> String? {
        guard let colorSpaceModel = obj as? NSColorSpace.Model else { return nil }
        return string(for: colorSpaceModel)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `NSColorSpace.Model` is not a class.
        false
    }
}
#endif
