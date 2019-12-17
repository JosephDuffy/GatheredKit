import Foundation

internal final class MockNotificationCenter: NotificationCenter {

    typealias AddObserverParameters = (name: Notification.Name?, object: Any?, queue: OperationQueue?, block: (Notification) -> Void)

    typealias RemoveObserverParameters = (observer: Any, name: NSNotification.Name?, object: Any?)
    
    internal private(set) var addObserverParameters: [AddObserverParameters] = []

    internal var latestAddObserverName: Notification.Name?? {
        return addObserverParameters.last?.name
    }

    internal var addObserverNames: [Notification.Name?] {
        return addObserverParameters.map { $0.name }
    }

    internal var latestAddObserverObject: Any?? {
        return addObserverParameters.last?.object
    }

    internal var addObserverObjects: [Any?] {
        return addObserverParameters.map { $0.object }
    }

    internal var latestAddObserverQueue: OperationQueue?? {
        return addObserverParameters.last?.queue
    }

    internal var addObserverQueues: [OperationQueue?] {
        return addObserverParameters.map { $0.queue }
    }

    internal var latestAddObserverBlock: ((Notification) -> Void)? {
        return addObserverParameters.last?.block
    }

    internal var addObserverBlocks: [((Notification) -> Void)?] {
        return addObserverParameters.map { $0.block }
    }

    internal var latestAddObserverOpaqueObject: NSObjectProtocol? {
        return addObserverOpaqueObjects.last
    }

    internal private(set) var addObserverOpaqueObjects: [NSObjectProtocol] = []

    internal var addObserverHasBeenCalled: Bool {
        return !addObserverParameters.isEmpty
    }
    internal private(set) var addObserverCallCount = 0

    internal private(set) var removeObserverParameters: [RemoveObserverParameters] = []

    internal var removeObserverNames: [Notification.Name?] {
        return removeObserverParameters.map { $0.name }
    }
    
    override func addObserver(forName name: Notification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        defer {
            addObserverCallCount += 1
        }

        addObserverParameters.append((name: name, object: obj, queue: queue, block: block))

        let opaqueObject = super.addObserver(forName: name, object: obj, queue: queue, using: block)
        addObserverOpaqueObjects.append(opaqueObject)
        return opaqueObject
    }

    override func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
        let parameters = RemoveObserverParameters(observer, aName, anObject)
        removeObserverParameters.append(parameters)
        super.removeObserver(observer, name: aName, object: anObject)
    }
    
}
