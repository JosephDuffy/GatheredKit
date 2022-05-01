import CoreGraphics
import Foundation

public final class SizeFormatter: Formatter {
    public var numberFormatter: NumberFormatter

    public var suffix: String

    public init(numberFormatter: NumberFormatter, suffix: String = "") {
        self.numberFormatter = numberFormatter
        self.suffix = suffix
        super.init()
    }

    public override convenience init() {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        self.init(numberFormatter: numberFormatter)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func string(for size: CGSize) -> String {
        let width = numberFormatter.string(from: size.width as NSNumber) ?? "\(size.width)"
        let height = numberFormatter.string(from: size.height as NSNumber) ?? "\(size.height)"
        return width + " × " + height + suffix
    }

    public override func string(for obj: Any?) -> String? {
        guard let size = obj as? CGSize else { return nil }
        return string(for: size)
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `CGSize` is not a class.
        false
    }
}
