//
//  DataSourceDataUnit.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 A unit of measurement for an instance of `DataSourceData`
 */
public protocol DataSourceDataUnit {

    /**
     Generates a human-friendly string for the given value.
     
     Note: The implementation may choose to throw any arbitrary `Error`, but see
     `DataSourceDataUnitError` for common errors
     
     - parameter value: The value to be formatted
     
     - throws: `DataSourceDataUnitError.unsupportedType` if the `value` parameter's type is not supported
     - throws: Any arbitrary `Error` the implementor decides
     
     - returns: The formatted string
    */
    func formattedString(for value: Any) throws -> String

}

/**
 A unit of measurement that is usually associated to a number.
 */
public protocol NumberBasedDataSourceDataUnit: DataSourceDataUnit {

    static var defaultMaximumFractionDigits: Int { get }

    /// The string that will be appended to the end of the string when
    /// the value is equal to 1, or `pluralValueSuffix` is `nil`
    var singularValueSuffix: String { get }

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1. If the value does not equal 1, but this
    /// vlaue is nil, `singularValueSuffix` will be used
    var pluralValueSuffix: String? { get }

    /// The maximum number of digits to show after the decimal place
    var maximumFractionDigits: Int { get }

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    init(maximumFractionDigits: Int)

}

public extension NumberBasedDataSourceDataUnit {

    /**
     Create a new instance of the unit with the default `maximumFractionDigits` value. See the
     `defaultMaximumFractionDigits` static property for the default value
     */
    init() {
        self.init(maximumFractionDigits: Self.defaultMaximumFractionDigits)
    }

    /**
     Generates a human-friendly string for the given value.

     This will call `formattedString(for:usingFormatter:)` with a formatter configured using the value
     of `self.maximumFractionDigits`

     - parameter value: The value to be formatted. Must be castable to `NSNumber`

     - throws: `DataSourceDataUnitError.unsupportedType` if the `value` cannot be cast to an `NSNumber`

     - returns: The formatted string
     */
    public func formattedString(for value: Any) throws -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = maximumFractionDigits > 0 ? .decimal : .none
        formatter.maximumFractionDigits = maximumFractionDigits

        return try self.formattedString(for: value, usingFormatter: formatter)
    }


    /**
     Uses the supplied formatter and value to create a human-friendly string. The suffix will be `singularValueSuffix`
     if `value` is 1, or `pluralValueSuffix` otherwise
     
     - parameter value: The value to be formatted. Must be castable to `NSNumber`
     - parameter formatter: The formatter to use to format the numeric value

     - throws: `DataSourceDataUnitError.unsupportedType` if the `value` cannot be cast to an `NSNumber`

     - returns: The formatted string
    */
    public func formattedString(for value: Any, usingFormatter formatter: NumberFormatter) throws -> String {
        guard let numberValue = value as? NSNumber else {
            throw DataSourceDataUnitError.unsupportedType(type: type(of: value))
        }

        let defaultValue = String(describing: numberValue)

        let suffix = numberValue == 1 ? singularValueSuffix : (pluralValueSuffix ?? singularValueSuffix)
        let value = formatter.string(from: numberValue) ?? defaultValue

        return value + suffix
    }
    
}

/** 
 An error thrown by a `DataSourceDataUnit`
 */
public enum DataSourceDataUnitError: Error {

    /// Thrown when the supplied value's type is not supported.
    case unsupportedType(type: Any.Type)

}
