
public struct AnyEquatable: Equatable {

    static public func ==(lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.equals(rhs.value)
    }

    private let value: Any
    private let equals: (Any) -> Bool

    public init<UnderlyingType: Equatable>(_ value: UnderlyingType) {
        self.value = value
        self.equals = { $0 as? UnderlyingType == value }
    }
}
