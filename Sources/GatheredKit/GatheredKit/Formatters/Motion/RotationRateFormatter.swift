import Foundation
import CoreMotion

public final class RotationRateFormatter: Formatter {

    public var numberFormatter: NumberFormatter

    public init(numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
        super.init()
    }

    public convenience override init() {
        let numberFormatter = NumberFormatter()
        self.init(numberFormatter: numberFormatter)
    }

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

}
