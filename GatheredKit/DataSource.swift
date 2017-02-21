//
//  DataSource.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 An object that can provide data from a specific source on the device
 */
public protocol DataSource: class {

    /// A boolean indicating if the data source is available on the current device
    static var isAvailable: Bool { get }

    /// A user-friendly name for the data source
    static var displayName: String { get }

    /// A delegate that will receive messages about the data source's data
    weak var delegate: DataSourceDelegate? { get set }

    /// The latest data values. All implementations within GatheredKit have a consistent and
    /// documented order to the data in this array, along with type-safe properties for each
    /// of the pieces of data
    var data: [DataSourceData] { get }

}

/**
 A `DataSource` that delivers new data in real-time, rather than manually or at a set frequency
 */
public protocol AutomaticallyUpdatingDataSource: DataSource {

    /// A boolean indicating if the data source is currently generting new data
    var isMonitoring: Bool { get }

    /**
     Start automatically monitoring changes to the data source. This will start delegate methods being called
     when new data is available
     */
    func startMonitoring()

    /**
     Stop monitoring for date updates
     */
    func stopMonitoring()

}

/**
 A data source that supports updating at any given time interval
 */
public protocol CustomisableUpdateIntervalDataSource: DataSource {

    /// The time interval between data updates. A value of `nil` indicates that
    /// the data source is not performing automatic periodic updates
    var updateInterval: TimeInterval? { get }

    /// A boolean indicating if the data source is performing period updates every `updateInterval`
    var isUpdating: Bool { get }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds

     - parameter updateInterval: The interval between data updates, measured in seconds
     */
    func startUpdating(every updateInterval: TimeInterval)

    /**
     Stop performing periodic data updated
     */
    func stopUpdating()

}

/**
 A `DataSource` that supports refreshing its data on request
 */
public protocol ManuallyUpdateableDataSource: DataSource {

    /**
     Force the data source to update its data. Note that there is no guarantee that new data
     will be available
     
     - returns: The data
     */
    @discardableResult
    func updateData() -> [DataSourceData]

}

// MARK:- Extensions

public extension CustomisableUpdateIntervalDataSource {

    /// A boolean indicating if the data source is currently refreshing its data every `updateInterval`
    public var isRefreshing: Bool {
        return updateInterval != nil
    }

}

extension Notification.Name {

    /// Posted when a data source's data updates. Object is the data source that got new data
    public static let dataSourceDataUpdated = Notification.Name("DataSourceDataUpdated")

}

internal extension DataSource {

    /**
     Notifies listeners that the data source got new data. First the delegate is notified,
     then the `dataSourceDataUpdated` notification is posted with `self` as the object
     */
    func notifyListenersDataUpdated() {
        delegate?.dataSource(self, updatedData: data)

        NotificationCenter.default.post(name: .dataSourceDataUpdated, object: self)
    }

    func notifyDelegate(errorOccurred error: Error?) {
        guard let delegate = self.delegate as? DataSourceErrorHandlingDelegate else { return }

        delegate.dataSource(self, gotErrorWhileRefreshing: error)
    }

}
