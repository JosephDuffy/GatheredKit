//
//  TimerBasedSource.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 The base for a `DataSource` that uses a `Timer` to provide periodic updates. Subclasses should
 implement the missing properties and methods of `ManuallyUpdatableSource`. By adding the missing
 properties and methods for `ManuallyUpdatableSource` and adding conformance to `CustomisableUpdateIntervalSource`
 the methods required by `CustomisableUpdateIntervalDataSource` will be provided for free via an extention
 */
open class TimerBasedSource {

    /// How frequently the source will update. A value of `nil` indicates that
    /// the source is not performing automatic periodic updates
    public var updateInterval: TimeInterval? {
        return monitoringTimer?.timeInterval
    }

    /// The `Timer` used to provide periodic updates
    fileprivate(set) var monitoringTimer: Timer?

}

public extension CustomisableUpdateIntervalSource where Self: ManuallyUpdatableSource, Self: TimerBasedSource {

    /**
     Start performing periodic updates, updating every `updateInterval` seconds. This will cause
     delegate methods to be called every `updateInterval`, even if the data has not changed. Note that
     the first data refresh will be in `updateInterval` seconds. To update the data straight away, call
     `updateData()` immediately after calling `startUpdating(every:)`

     - parameter updateInterval: The interval between data refreshes, measured in seconds
     */
    public func startUpdating(every updateInterval: TimeInterval) {
        stopUpdating()

        let monitoringTimer = Timer.createRepeatingTimer(timeInterval: updateInterval) { [weak self] _ in
            guard let `self` = self else { return }

            self.updateProperties()
            self.notifyListenersPropertiesUpdated()
        }
        self.monitoringTimer = monitoringTimer
        RunLoop.current.add(monitoringTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }

    /**
     Stop performing periodic updates
     */
    public func stopUpdating() {
        guard let monitoringTimer = self.monitoringTimer else { return }

        monitoringTimer.invalidate()
        self.monitoringTimer = nil
    }

}
