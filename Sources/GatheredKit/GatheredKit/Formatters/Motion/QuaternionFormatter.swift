import Foundation
import CoreMotion

public final class QuaternionFormatter: Formatter {
    
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
    
    public func string(for quaternion: CMQuaternion) -> String {
        let x = numberFormatter.string(from: quaternion.x as NSNumber) ?? "\(quaternion.x)"
        let y = numberFormatter.string(from: quaternion.y as NSNumber) ?? "\(quaternion.y)"
        let z = numberFormatter.string(from: quaternion.z as NSNumber) ?? "\(quaternion.z)"
        let w = numberFormatter.string(from: quaternion.w as NSNumber) ?? "\(quaternion.w)"
        return [x, y, z, w].joined(separator: ", ")
    }
    
    public override func string(for obj: Any?) -> String? {
        guard let size = obj as? CMQuaternion else { return nil }
        return string(for: size)
    }
    
}
