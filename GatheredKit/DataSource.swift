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

    /// A delegate that will receive messages about the data source
    weak var delegate: DataSourceDelegate? { get set }

    /// The latest data values. All implementations within GatheredKit have a consistent and
    /// documented order to the data in this array, along with type-safe properties for each
    /// of the pieces of data
    var data: [DataSourceData] { get }

}

/**
 A `DataSource` that performs updates in real-time, rather than manually or at a set frequency
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
     Stop performing automatic date refreshes
     */
    func stopMonitoring()

}

/**
 A data source that supports updating at any given time interval
 */
public protocol CustomisableUpdateFrequencyDataSource: DataSource {

    /// How frequently the data source will update. A value of `nil` indicates that
    /// the data source will not perform automatic updates
    var updateFrequency: TimeInterval? { get }

    /// A boolean indicating if the data source is currently updating every `updateFrequency`
    var isMonitoring: Bool { get }

    /**
     Start monitoring changes to the data source, updating every `updateFrequency` seconds. This will start
     delegate methods being called when new data is found

     - parameter updateFrequency: The number of seconds between data refreshes
     */
    func startMonitoring(updateFrequency: TimeInterval)

    /**
     Stop performing automatic date refreshes
     */
    func stopMonitoring()

}

/**
 A `DataSource` that supporting refreshing its data on request
 */
public protocol ManuallyUpdatableDataSource: DataSource {

    /**
     Force the loading of new data from the backing data
     
     - returns: The new data
     */
    @discardableResult
    func refreshData() -> [DataSourceData]

}

// MARK:- Extensions

public extension CustomisableUpdateFrequencyDataSource {

    /// A boolean indicating if the data source is currently updating every `updateFrequency`
    public var isMonitoring: Bool {
        return updateFrequency != nil
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

}
