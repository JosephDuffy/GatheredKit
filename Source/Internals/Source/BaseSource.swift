import Foundation

open class BaseSource: NSObject {

    private var updateListeners = NSHashTable<SourceUpdateListenerWrapper>.weakObjects()

    public override init() {
        guard type(of: self) != BaseSource.self else {
            fatalError("BaseSource must be subclassed")
        }

        super.init()
    }

    open func addUpdateListener(
        _ updateListener: @escaping Controllable.UpdateListener,
        queue: DispatchQueue
    ) -> AnyObject {
        let observer = SourceUpdateListenerWrapper(updateListener: updateListener, queue: queue)
        updateListeners.add(observer)
        return observer
    }

    public final func notifyUpdateListeners(latestPropertyValues: [Value]) {
        updateListeners.allObjects.forEach { wrapper in
            wrapper.queue.async {
                wrapper.updateListener(latestPropertyValues)
            }
        }
    }

}

extension Controllable where Self: BaseSource, Self: ValuesProvider {

    public func notifyListenersPropertyValuesUpdated() {
        notifyUpdateListeners(latestPropertyValues: allValues)
    }

}
