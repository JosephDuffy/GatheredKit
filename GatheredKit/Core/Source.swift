//
//  Source.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: class {

    /// A boolean indicating if the source is available on the current device
    static var isAvailable: Bool { get }

    /// A delegate that will receive messages about the source
    weak var delegate: SourceDelegate? { get set }

}

/**
 A source that monitors its properties in real-time
 */
public protocol AutomaticallyUpdatingSource: Source {

    /// A boolean indicating if the source is currently performing automatic updated
    var isUpdating: Bool { get }

    /**
     Start monitoring for changes. This will start delegate methods to be called
     and notifications to be posted
     */
    func startMonitoring()

    /**
     Stop monitoring for changes
     */
    func stopMonitoring()

}

/**
 A source that supports updating its properties at a given time interval
 */
public protocol CustomisableUpdateIntervalSource: Source {

    /// The time interval between property updates. A value of `nil` indicates that
    /// the source is not performing periodic updates
    var updateInterval: TimeInterval? { get }

    /// A boolean indicating if the source is performing period updates every `updateInterval`
    var isUpdating: Bool { get }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds

     - parameter updateInterval: The interval between updates, measured in seconds
     */
    func startUpdating(every updateInterval: TimeInterval)

    /**
     Stop performing periodic updates
     */
    func stopUpdating()

}

public extension CustomisableUpdateIntervalSource {

    /// A boolean indicating if the source is currently updating its properties every `updateInterval`
    public var isUpdating: Bool {
        return updateInterval != nil
    }

}

/**
 A source that supports its properties being updated at any given time
 */
public protocol ManuallyUpdatableSource: Source {

    /**
     Force the source to update its properties. Note that there is no guarantee that new data
     will be available
     */
    func updateProperties()
}
