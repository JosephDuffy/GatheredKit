import Foundation

public final class MockNotificationCenter: NotificationCenter {
    public typealias AddObserverParameters = (
        name: Notification.Name?, object: Any?, queue: OperationQueue?,
        block: (Notification) -> Void
    )

    public typealias RemoveObserverParameters = (
        observer: Any, name: NSNotification.Name?, object: Any?
    )

    public private(set) var addObserverParameters: [AddObserverParameters] = []

    public var latestAddObserverName: Notification.Name?? {
        addObserverParameters.last?.name
    }

    public var addObserverNames: [Notification.Name?] {
        addObserverParameters.map(\.name)
    }

    public var latestAddObserverObject: Any?? {
        addObserverParameters.last?.object
    }

    public var addObserverObjects: [Any?] {
        addObserverParameters.map(\.object)
    }

    public var latestAddObserverQueue: OperationQueue?? {
        addObserverParameters.last?.queue
    }

    public var addObserverQueues: [OperationQueue?] {
        addObserverParameters.map(\.queue)
    }

    public var latestAddObserverBlock: ((Notification) -> Void)? {
        addObserverParameters.last?.block
    }

    public var addObserverBlocks: [((Notification) -> Void)?] {
        addObserverParameters.map(\.block)
    }

    public var latestAddObserverOpaqueObject: NSObjectProtocol? {
        addObserverOpaqueObjects.last
    }

    public private(set) var addObserverOpaqueObjects: [NSObjectProtocol] = []

    public var addObserverHasBeenCalled: Bool {
        !addObserverParameters.isEmpty
    }

    public private(set) var addObserverCallCount = 0

    public private(set) var removeObserverParameters: [RemoveObserverParameters] = []

    public var removeObserverNames: [Notification.Name?] {
        removeObserverParameters.map(\.name)
    }

    public override func addObserver(
        forName name: Notification.Name?, object obj: Any?, queue: OperationQueue?,
        using block: @escaping (Notification) -> Void
    ) -> NSObjectProtocol {
        defer {
            addObserverCallCount += 1
        }

        addObserverParameters.append((name: name, object: obj, queue: queue, block: block))

        let opaqueObject = super.addObserver(forName: name, object: obj, queue: queue, using: block)
        addObserverOpaqueObjects.append(opaqueObject)
        return opaqueObject
    }

    public override func removeObserver(
        _ observer: Any, name aName: NSNotification.Name?, object anObject: Any?
    ) {
        let parameters = RemoveObserverParameters(observer, aName, anObject)
        removeObserverParameters.append(parameters)
        super.removeObserver(observer, name: aName, object: anObject)
    }
}
