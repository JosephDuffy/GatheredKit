import Foundation
import CoreMotion

public final class RotationRateFormatter: Formatter {

    public let numberFormatter: NumberFormatter

    public override init() {
        numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        super.init()
    }

    public init(numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func string(for obj: Any?) -> String? {
        guard
            let rotationRate = obj as? CMRotationRate,
            let xString = numberFormatter.string(from: NSNumber(value: rotationRate.x)),
            let yString = numberFormatter.string(from: NSNumber(value: rotationRate.y)),
            let zString = numberFormatter.string(from: NSNumber(value: rotationRate.z))
            else { return nil }
        return xString + ", " + yString + ", " + zString
    }

}
