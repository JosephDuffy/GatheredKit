#if os(macOS)
import AppKit

open class NSColorSpaceFormatter: Formatter {
    open var modelFormatter: NSColorSpaceModelFormatter

    public required init(modelFormatter: NSColorSpaceModelFormatter) {
        self.modelFormatter = modelFormatter

        super.init()
    }

    public override convenience init() {
        self.init(modelFormatter: NSColorSpaceModelFormatter())
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func string(for colorSpace: NSColorSpace) -> String {
        modelFormatter.string(for: colorSpace.colorSpaceModel)
    }

    public override func string(for obj: Any?) -> String? {
        guard let colorSpace = obj as? NSColorSpace else { return nil }
        return string(for: colorSpace)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // This _could_ be implemented, but the output string would need to
        // include more information to be accurate.
        false
    }
}
#endif
