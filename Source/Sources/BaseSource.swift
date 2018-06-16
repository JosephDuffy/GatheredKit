import Foundation

public class BaseSource {

    private var updateListeners = NSHashTable<SourceUpdateListenerWrapper>.weakObjects()

    internal init() {
        guard type(of: self) != BaseSource.self else {
            fatalError("BaseSource must be subclassed")
        }
    }

    public func addUpdateListener(_ updateListener: @escaping Source.UpdateListener) -> AnyObject {
        let observer = SourceUpdateListenerWrapper(updateListener: updateListener)
        updateListeners.add(observer)
        return observer
    }

    internal func notifyUpdateListeners(latestPropertyValues: [AnyValue]) {
        if Thread.isMainThread {
            updateListeners.allObjects.forEach { $0.updateListener(latestPropertyValues) }
        } else {
            DispatchQueue.main.sync {
                updateListeners.allObjects.forEach { $0.updateListener(latestPropertyValues) }
            }
        }
    }

}

extension Source where Self: BaseSource {

    internal func notifyListenersPropertyValuesUpdated() {
        notifyUpdateListeners(latestPropertyValues: allValues)
    }

}
