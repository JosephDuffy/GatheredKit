import Foundation

public final class MockFormatter: Formatter {
    public typealias StringFormatter = (_ obj: Any?) -> String?

    public var stringFormatter: StringFormatter?

    public override func string(for obj: Any?) -> String? {
        (stringFormatter ?? { _ in nil })(obj)
    }

    public override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        false
    }
}
