//
//  DataSourceData.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 An implementation of `TypedDataSourceDataProtocol` that is type-safe  by using generics
 */
public struct TypedDataSourceData<RawValueType: Any>: TypedDataSourceDataProtocol {

    /// A user-friendly name for the data source
    public let displayName: String

    /// The unmodified, unformatted, original value
    public var value: RawValueType?

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    public var formattedValue: String?

    /// A unit of measurement for the data source's value
    public let unit: DataSourceDataUnit?

    /**
     Create a new `DataSourceData`

     - parameter displayName: A user-friendly name for the data source
     - parameter rawValue: The unmodified, unformatted, original value
     - parameter formattedValue: A human-friendly formatted value. Default is `nil`
     - parameter unit: A unit of measurement for the data source's value. Default is `nil`
     */
    public init(displayName: String, value: RawValueType? = nil, formattedValue: String? = nil, unit: DataSourceDataUnit? = nil) {
        self.displayName = displayName
        self.value = value
        self.formattedValue = formattedValue
        self.unit = unit
    }

    /**
     Create a new `DataSourceData`

     - parameter displayName: A user-friendly name for the data source
     */
    public init(displayName: String) {
        self.init(displayName: displayName, value: nil, formattedValue: nil, unit: nil)
    }
    
}

/**
 A piece of data generated by a `DataSource`
 */
public protocol DataSourceData {

    /// A user-friendly name for the data source
    var displayName: String { get }

    /// The unmodified, unformatted, original value
    var rawValue: Any? { get }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    var formattedValue: String? { get set }

    /// A unit of measurement for the data source's value
    var unit: DataSourceDataUnit? { get }

    /**
     Create a new `DataSourceData`
     
     - parameter displayName: A user-friendly name for the data source
     */
    init(displayName: String)

}

/**
 An extension of `DataSourceData` that provided a type-safe `value` property
 */
public protocol TypedDataSourceDataProtocol: DataSourceData {
    associatedtype ValueType

    /// The unmodified, unformatted, original value
    var value: ValueType? { get set }

}

// MARK:- Extensions

public extension TypedDataSourceDataProtocol {

    /// The unmodified, unformatted, original value
    public var rawValue: Any? {
        return value
    }

}

extension Equatable where Self: TypedDataSourceDataProtocol, Self.ValueType: Equatable {

    static func ==(lhs: Self, rhs: Self) -> Bool {
        if let lhsValue = lhs.value, let rhsValue = rhs.value {
            guard lhsValue == rhsValue else { return false }
        }

        guard lhs.value == nil && rhs.value == nil else { return false }

        return lhs.displayName == rhs.displayName &&
            lhs.formattedValue == rhs.formattedValue &&
            type(of: lhs.unit) == type(of: rhs.unit)
    }

}
