import Foundation

public struct Action {

    public let title: String

    public let isAvailable: Bool

    private let performClosure: () -> Void

    public init(title: String, isAvailable: Bool, perform: @escaping () -> Void) {
        self.title = title
        self.isAvailable = isAvailable
        self.performClosure = perform
    }

    public func perform() {
        performClosure()
    }

}
