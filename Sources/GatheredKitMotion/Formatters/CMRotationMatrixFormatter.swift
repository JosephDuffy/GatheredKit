import CoreMotion
import Foundation

@available(macOS, unavailable)
public final class CMRotationMatrixFormatter: Formatter {
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

    public func string(for rotationMatrix: CMRotationMatrix) -> String {
        let m11 = "m11: " + (numberFormatter.string(from: rotationMatrix.m11 as NSNumber) ?? "\(rotationMatrix.m11)")
        let m12 = "m12: " + (numberFormatter.string(from: rotationMatrix.m12 as NSNumber) ?? "\(rotationMatrix.m12)")
        let m13 = "m13: " + (numberFormatter.string(from: rotationMatrix.m13 as NSNumber) ?? "\(rotationMatrix.m13)")
        let m21 = "m21: " + (numberFormatter.string(from: rotationMatrix.m21 as NSNumber) ?? "\(rotationMatrix.m21)")
        let m22 = "m22: " + (numberFormatter.string(from: rotationMatrix.m22 as NSNumber) ?? "\(rotationMatrix.m22)")
        let m23 = "m23: " + (numberFormatter.string(from: rotationMatrix.m23 as NSNumber) ?? "\(rotationMatrix.m23)")
        let m31 = "m31: " + (numberFormatter.string(from: rotationMatrix.m31 as NSNumber) ?? "\(rotationMatrix.m31)")
        let m32 = "m32: " + (numberFormatter.string(from: rotationMatrix.m32 as NSNumber) ?? "\(rotationMatrix.m32)")
        let m33 = "m33: " + (numberFormatter.string(from: rotationMatrix.m33 as NSNumber) ?? "\(rotationMatrix.m33)")
        return [m11, m12, m13, m21, m22, m23, m31, m32, m33].joined(separator: ", ")
    }

    public override func string(for obj: Any?) -> String? {
        guard let rotationMatrix = obj as? CMRotationMatrix else { return nil }
        return string(for: rotationMatrix)
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `CMRotationMatrix` is not a class.
        false
    }
}
