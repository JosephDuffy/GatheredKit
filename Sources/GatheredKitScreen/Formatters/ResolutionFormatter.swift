import CoreGraphics
import Foundation

public final class ResolutionFormatter: Formatter {
    public var numberFormatter: NumberFormatter

    public let unit: UnitResolution

    public init(numberFormatter: NumberFormatter, unit: UnitResolution) {
        self.numberFormatter = numberFormatter
        self.unit = unit
        super.init()
    }

    public convenience init(unit: UnitResolution) {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        self.init(numberFormatter: numberFormatter, unit: unit)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func string(for size: CGSize) -> String {
        let width = numberFormatter.string(from: size.width as NSNumber) ?? "\(size.width)"
        let height = numberFormatter.string(from: size.height as NSNumber) ?? "\(size.height)"
        return width + " × " + height + " " + unit.symbol
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
