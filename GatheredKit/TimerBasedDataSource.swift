//
//  TimerBasedDataSource.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 The base for a `DataSource` that uses a `Timer` to provide periodic updates. Subclasses should
 implement the missing properties and methods of `ManuallyRefreshableDataSource`. By adding the missing
 properties and methods for `ManuallyRefreshableDataSource` and adding conformance to `CustomisableUpdateFrequencyDataSource`
 the methods required by `CustomisableUpdateFrequencyDataSource` will be provided for free via an extention
 */
open class TimerBasedDataSource {

    /// How frequently the data source will refresh its data. A value of `nil` indicates that
    /// the data source will not perform periodic updates
    public fileprivate(set) var updateFrequency: TimeInterval?

    /// The `Timer` used to provide periodic updates
    fileprivate(set) var monitoringTimer: Timer?

}

public extension CustomisableUpdateFrequencyDataSource where Self: ManuallyRefreshableDataSource, Self: TimerBasedDataSource {

    /**
     Start performing periodic updates, updating every `updateFrequency` seconds. This will cause
     delegate methods to be called every `updateFrequency`, even if the data has not changed. Note that 
     the first data refresh will be in `updateFrequency`. To update the data straight away, call `refreshData()`
     after calling `startUpdating(every:)`

     - parameter updateFrequency: The number of seconds between data refreshes
     */
    public func startUpdating(every updateFrequency: TimeInterval) {
        stopUpdating()

        self.updateFrequency = updateFrequency

        let monitoringTimer = Timer.createRepeatingTimer(timeInterval: updateFrequency) { [weak self] _ in
            guard let `self` = self else { return }

            self.refreshData()
            self.notifyListenersDataUpdated()
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
        self.updateFrequency = nil
    }

}
