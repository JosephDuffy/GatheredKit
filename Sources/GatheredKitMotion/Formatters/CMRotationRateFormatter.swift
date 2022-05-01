#if os(iOS) || os(watchOS)
import CoreMotion
import Foundation

public final class CMRotationRateFormatter: Formatter {
    public var numberFormatter: NumberFormatter

    public init(numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
        super.init()
    }

    public override convenience init() {
        let numberFormatter = NumberFormatter()
        self.init(numberFormatter: numberFormatter)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func string(for rotationRate: CMRotationRate) -> String {
        let x = numberFormatter.string(from: rotationRate.x as NSNumber) ?? "\(rotationRate.x)"
        let y = numberFormatter.string(from: rotationRate.y as NSNumber) ?? "\(rotationRate.y)"
        let z = numberFormatter.string(from: rotationRate.z as NSNumber) ?? "\(rotationRate.z)"
        return [x, y, z].joined(separator: ", ")
    }

    public override func string(for obj: Any?) -> String? {
        guard let rotationRate = obj as? CMRotationRate else { return nil }
        return string(for: rotationRate)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `CMRotationRate` is not a class.
        false
    }
}
#endif
