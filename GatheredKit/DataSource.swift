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

    var data: [DataSourceData] { get }

    /// How frequently the data source will update. A value of `nil` indicates that
    /// the data source will not perform automatic updates
    var updateFrequency: TimeInterval? { get }

    init()

    /// Start monitoring changes to the data source, updating every `updateFrequency`
    func startMonitoring(updateFrequency: TimeInterval)

    /// Stop monitoring active changes
    func stopMonitoring()

}

public protocol ManuallyUpdatableDataSource: DataSource {

    /// Force fresh data to be loaded
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
