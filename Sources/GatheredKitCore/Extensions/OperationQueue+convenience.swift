import Foundation

extension OperationQueue {

    // TODO: Move to "GatheredKitUtils"
    public convenience init(name: String? = nil) {
        self.init()

        self.name = name
    }

}
