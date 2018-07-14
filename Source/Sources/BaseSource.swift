import Foundation

open class BaseSource: NSObject {

    private var updateListeners = NSHashTable<SourceUpdateListenerWrapper>.weakObjects()

    public override init() {
        guard type(of: self) != BaseSource.self else {
            fatalError("BaseSource must be subclassed")
        }

        super.init()
    }

    open func addUpdateListener(_ updateListener: @escaping ControllableSource.UpdateListener, queue: DispatchQueue) -> AnyObject {
        let observer = SourceUpdateListenerWrapper(updateListener: updateListener, queue: queue)
        updateListeners.add(observer)
        return observer
    }

    public final func notifyUpdateListeners(latestPropertyValues: [AnyValue]) {
        updateListeners.allObjects.forEach { wrapper in
            wrapper.queue.async {
                wrapper.updateListener(latestPropertyValues)
            }
        }
    }

}

extension ControllableSource where Self: BaseSource {

    public func notifyListenersPropertyValuesUpdated() {
        notifyUpdateListeners(latestPropertyValues: allValues)
    }

}
