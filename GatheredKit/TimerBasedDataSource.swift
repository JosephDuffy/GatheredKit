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
 override the `updateData()` method and provide the missing properties and methods of `DataSource`.
 
 Note that to provide a default implementation for `startMonitoring(updateFrequency:)` and `stopMonitoring()`
 the subclass *must* conform to `ManuallyUpdatableDataSource`
 */
open class TimerBasedDataSource {

    public fileprivate(set) var updateFrequency: TimeInterval?

    /// The `Timer` used to provide periodic updates
    fileprivate(set) var monitoringTimer: Timer?

}

public extension ManuallyUpdatableDataSource where Self: TimerBasedDataSource {

    public func startMonitoring(updateFrequency: TimeInterval) {
        stopMonitoring()

        self.updateFrequency = nil

        let monitoringTimer = Timer.createRepeatingTimer(timeInterval: updateFrequency) { [weak self] _ in
            guard let `self` = self else { return }
            
            self.refreshData()
        }
        monitoringTimer.tolerance = updateFrequency/10
        self.monitoringTimer = monitoringTimer
        RunLoop.current.add(monitoringTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }

    public func stopMonitoring() {
        guard let monitoringTimer = self.monitoringTimer else { return }

        monitoringTimer.invalidate()
        self.monitoringTimer = nil
        self.updateFrequency = nil
    }

}
