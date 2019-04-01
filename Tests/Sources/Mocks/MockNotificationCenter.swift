import Foundation

internal final class MockNotificationCenter: NotificationCenter {
    
    internal private(set) var addObserverLatestParameters: (name: Notification.Name?, object: Any?, queue: OperationQueue?, block: (Notification) -> Void)?
    internal var latestName: Notification.Name?? {
        return addObserverLatestParameters?.name
    }
    internal var latestObject: Any?? {
        return addObserverLatestParameters?.object
    }
    internal var latestQueue: OperationQueue?? {
        return addObserverLatestParameters?.queue
    }
    internal var latestBlock: ((Notification) -> Void)? {
        return addObserverLatestParameters?.block
    }
    internal private(set) var latestOpaqueObject: NSObjectProtocol?
    internal var addObserverHasBeenCalled: Bool {
        return addObserverLatestParameters != nil
    }
    internal private(set) var addObserverLatestParmetersCallCount = 0
    
    override func addObserver(forName name: Notification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        defer {
            addObserverLatestParmetersCallCount += 1
        }
        addObserverLatestParameters = (name: name, object: obj, queue: queue, block: block)
        let opaqueObject = super.addObserver(forName: name, object: obj, queue: queue, using: block)
        self.latestOpaqueObject = opaqueObject
        return opaqueObject
    }
    
}
