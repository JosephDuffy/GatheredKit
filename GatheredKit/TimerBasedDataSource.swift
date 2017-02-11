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
 implement the missing properties and methods of `ManuallyUpdatableDataSource`. By adding the missing
 properties and methods for `ManuallyUpdatableDataSource` and adding conformance to `CustomisableUpdateFrequencyDataSource`
 the methods required by `CustomisableUpdateFrequencyDataSource` will be provided for free via an extention
 */
open class TimerBasedDataSource {

    /// How frequently the data source will update. A value of `nil` indicates that
    /// the data source will not perform automatic updates
    public fileprivate(set) var updateFrequency: TimeInterval?

    /// The `Timer` used to provide periodic updates
    fileprivate(set) var monitoringTimer: Timer?

}

public extension CustomisableUpdateFrequencyDataSource where Self: ManuallyUpdatableDataSource, Self: TimerBasedDataSource {

    /**
     Start monitoring changes to the data source, updating every `updateFrequency` seconds

     - parameter updateFrequency: The number of seconds between data refreshes
     - parameter updateNow: If `true`, `refreshData()` will be called. Default is `true`
     */
    public func startMonitoring(updateFrequency: TimeInterval, updateNow: Bool = true) {
        stopMonitoring()

        self.updateFrequency = updateFrequency

        if updateNow {
            refreshData()
        }

        let monitoringTimer = Timer.createRepeatingTimer(timeInterval: updateFrequency) { [weak self] _ in
            guard let `self` = self else { return }

            let newData = self.refreshData()
            self.delegate?.dataSource(self, updatedData: newData)
        }
        self.monitoringTimer = monitoringTimer
        RunLoop.current.add(monitoringTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }

    /**
     A convenience method that calls `startMonitoring(updateFrequency:updateNow:)`, passing the `updateFrequency`
     paramater and using `true` for `updateNow`
     
     - parameter updateFrequency: The number of seconds between data refreshes
    */
    public func startMonitoring(updateFrequency: TimeInterval) {
        startMonitoring(updateFrequency: updateFrequency, updateNow: true)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopMonitoring() {
        guard let monitoringTimer = self.monitoringTimer else { return }

        monitoringTimer.invalidate()
        self.monitoringTimer = nil
        self.updateFrequency = nil
    }

}
