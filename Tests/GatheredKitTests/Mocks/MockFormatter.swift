import Foundation

final class MockFormatter: Formatter {

    typealias StringFormatter = (_ obj: Any?) -> String?

    var stringFormatter: StringFormatter?

    override func string(for obj: Any?) -> String? {
        return (stringFormatter ?? { _ in nil })(obj)
    }

}
