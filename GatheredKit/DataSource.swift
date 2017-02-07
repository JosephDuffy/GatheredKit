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

    /// A delegate that will recieve messages about the data source
    weak var delegate: DataSourceDelegate? { get set }

    /// The latest data values. All implementations within GatheredKit have a concistent and
    /// documented order to the data in this array.
    var data: [DataSourceData] { get }

    /**
     Creates a new instance of the data source
     */
    init()

}

/**
 A `DataSource` that performs updates in real-time, rather than manually or at a set frequency
 */
public protocol AutomaticallyUpdatingDataSource: DataSource {

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
 A data source that supports a variable update frequency
 */
public protocol VariableUpdateFrequencyDataSource: DataSource {

    /// How frequently the data source will update. A value of `nil` indicates that
    /// the data source will not perform automatic updates
    var updateFrequency: TimeInterval? { get }

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
     Force fresh data to be loaded
     
     - returns: The new data
     */
    @discardableResult
    func refreshData() -> [DataSourceData]

}

/**
 A `DataSource` that supports both manual updating and a variable update frequency
 */
public protocol ManuallyUpdatableVariableUpdateFrequencyDataSource: ManuallyUpdatableDataSource, VariableUpdateFrequencyDataSource {}

// MARK:- Extensions

public extension VariableUpdateFrequencyDataSource {

    /// A boolean indicating if the data source is currently generting new data
    var isMonitoring: Bool {
        return updateFrequency != nil
    }

}
