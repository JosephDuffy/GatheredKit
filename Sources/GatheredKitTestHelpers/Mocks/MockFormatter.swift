import Foundation

public final class MockFormatter: Formatter {

    public typealias StringFormatter = (_ obj: Any?) -> String?

    public var stringFormatter: StringFormatter?

    public override func string(for obj: Any?) -> String? {
        return (stringFormatter ?? { _ in nil })(obj)
    }

}
