//
//  Source+Subscribe.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 10/06/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

public extension Source {

    typealias Unsubscriber = () -> Void

    /**
     Subscribes a given closure to changes about this source. To cancel updates either call the returned closure or the closure
     passed as the second parameter when the `listener` is called.

     When the source updates its properties the `listener` closure will be called with the first parameter as the source and the second
     parameter a closure that can be called to unsubscribe

     - parameter queue: The operation queue to which listener closure should be added. Default to main. If you pass nil, the closure is run synchronously on the posting thread
     - parameter updateInterval: If non-nil will start updating source automatically. For `CustomisableUpdateIntervalSource` instances `updateInterval` is used. For `AutomaticallyUpdatingSource` this is ignored
     - parameter listener: The closure to be called when the source's properties are updated
     - returns: A closure that when called will unsubscribe the listener from changes
     */
    @discardableResult
    public func subscribeToChanges(queue: OperationQueue? = .main, updateInterval: TimeInterval? = nil, listener: @escaping (Self, Unsubscriber) -> Void) -> Unsubscriber {
        var observer = NotificationCenter.default.addObserver(forName: .sourcePropertiesUpdated, object: self, queue: queue) { [weak self] notification in
            guard let `self` = self else {
                unsubscribe()
                return
            }

            listener(self, unsubscribe)
        }

        func unsubscribe() {
            NotificationCenter.default.removeObserver(observer)
        }

        if let updateInterval = updateInterval {
            if let automaticallyUpdatingSource = self as? AutomaticallyUpdatingSource {
                automaticallyUpdatingSource.startMonitoring()
            } else if let customisableUpdateIntervalSource = self as? CustomisableUpdateIntervalSource {
                customisableUpdateIntervalSource.startUpdating(every: updateInterval)
            }
        }

        return unsubscribe

    }

}
