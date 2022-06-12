import Foundation

public final class BoolFormatter: Formatter {
    public var trueString: String
    public var falseString: String

    public override convenience init() {
        self.init(
            trueString: NSLocalizedString(
                "yes",
                bundle: .module,
                comment: "The value for a true value"
            ),
            falseString: NSLocalizedString(
                "no",
                bundle: .module,
                comment: "The value for a false value"
            )
        )
    }

    public required init(trueString: String, falseString: String) {
        self.trueString = trueString
        self.falseString = falseString

        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let trueString = aDecoder.decodeObject(of: NSString.self, forKey: "trueString") else {
            return nil
        }
        guard let falseString = aDecoder.decodeObject(of: NSString.self, forKey: "falseString") else {
            return nil
        }

        self.trueString = trueString as String
        self.falseString = falseString as String

        super.init(coder: aDecoder)
    }

    public override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(trueString, forKey: "trueString")
        coder.encode(falseString, forKey: "falseString")
    }

    public func string(for bool: Bool) -> String {
        bool ? trueString : falseString
    }

    public override func string(for obj: Any?) -> String? {
        guard let bool = obj as? Bool else { return nil }
        return string(for: bool)
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        if string == trueString {
            obj?.pointee = NSNumber(booleanLiteral: true)
            return true
        }

        if string == falseString {
            obj?.pointee = NSNumber(booleanLiteral: false)
            return true
        }

        return false
    }
}
