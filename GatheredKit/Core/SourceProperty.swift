//
//  SourceProperty.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 A generic implementation of `SourcePropertyProtocol`, a property of a source
 */
public struct SourceProperty<ValueType>: SourcePropertyProtocol {

    /// A user-friendly name for the property
    public let displayName: String

    /// The value of the property
    public var value: ValueType {
        return data.value
    }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    public var formattedValue: String?

    /// A unit of measurement for the value
    public let unit: SourcePropertyUnit?

    /// The date that the latest value was recorded
    public var date: Date {
        return data.date
    }

    /// A private tuple that stores the backing data to ensure that all 3 properties are set at once
    private var data: (value: ValueType, formattedValue: String?, date: Date)

    /**
     Create a new `SourceProperty`

     - parameter displayName: A user-friendly name for the property
     - parameter value: The value of the data
     - parameter formattedValue: A human-friendly formatted value. Defaults to `nil`
     - parameter unit: A unit of measurement for the value. Defaults to `nil`
     - parameter date: The date and time that the value was recorded. Defaults to the current date and time
     */
    public init(displayName: String, value: ValueType, formattedValue: String? = nil, unit: SourcePropertyUnit? = nil, date: Date = Date()) {
        self.displayName = displayName
        self.data = (value: value, formattedValue: formattedValue, date: date)
        self.formattedValue = formattedValue
        self.unit = unit
    }

    /**
     Updates the data backing this `SourceProperty`

     - parameter value: The new value of the data
     - parameter formattedValue: The new human-friendly formatted value. Defaults to `nil`
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func updateData(value: ValueType, formattedValue: String? = nil, date: Date = Date()) {
        data = (value: value, formattedValue: formattedValue, date: date)
    }
    
}

/**
 A property of a source
 */
public protocol SourcePropertyProtocol {

    /// The type of the `value` property
    associatedtype ValueType

    /// A user-friendly name for the property
    var displayName: String { get }

    /// The value of the property
    var value: ValueType { get }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    var formattedValue: String? { get }

    /// A unit of measurement for the value
    var unit: SourcePropertyUnit? { get }

    /// The date that the latest value was recorded
    var date: Date { get }
}

