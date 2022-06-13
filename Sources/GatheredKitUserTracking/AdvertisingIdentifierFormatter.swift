import Foundation

open class AdvertisingIdentifierFormatter: Formatter {
    public override init() {
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func string(for uuid: UUID) -> String {
        if uuid.uuidString == "00000000-0000-0000-0000-000000000000" {
            return "Unavailable"
        } else {
            return uuid.uuidString
        }
    }

    public override func string(for obj: Any?) -> String? {
        guard let uuid = obj as? UUID else { return nil }
        return string(for: uuid)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        if let uuid = NSUUID(uuidString: string) {
            obj?.pointee = uuid
            return true
        }

        if string == "Unavailable" {
            obj?.pointee = NSUUID(uuidString: "00000000-0000-0000-0000-000000000000")
            return true
        }

        return false
    }
}
