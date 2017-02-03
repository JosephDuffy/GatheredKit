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

    /// The latest data values. All implementations within GatheredKit have a concistent and
    /// documented order to the data in this array.
    var data: [DataSourceData] { get }

    /// How frequently the data source will update. A value of `nil` indicates that
    /// the data source will not perform automatic updates
    var updateFrequency: TimeInterval? { get }

    /**
     Creates a new instance of the data source
     */
    init()

    /**
     Start monitoring changes to the data source, updating every `updateFrequency` seconds
     
     - parameter updateFrequency: The number of seconds between data refreshes
     */
    func startMonitoring(updateFrequency: TimeInterval)

    /**
     Stop performing automatic date refreshes
     */
    func stopMonitoring()

}

/**
 A `DataSource` that can be requested to update themselves at any time
 */
public protocol ManuallyUpdatableDataSource: DataSource {

    /**
     Force fresh data to be loaded
     */
    @discardableResult
    func refreshData() -> [DataSourceData]

}

// MARK:- Extensions

public extension DataSource {

    /// A boolean indicating if the data source is currently generting new data
    var isMonitoring: Bool {
        return updateFrequency != nil
    }

}
