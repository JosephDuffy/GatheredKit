import CoreGraphics
import Foundation

/// A formatter that returns strings as-is.
public final class PassthroughFormatter: Formatter {
    public override init() {
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func string(for string: String) -> String {
        string
    }

    public override func string(for obj: Any?) -> String? {
        guard let string = obj as? String else { return nil }
        return self.string(for: string)
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        obj?.pointee = NSString(string: string)
        return true
    }
}
