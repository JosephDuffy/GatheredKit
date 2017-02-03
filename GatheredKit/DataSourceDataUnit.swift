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
@objc
public protocol DataSourceDataUnit {

    /// A human-readable name for the unit
    @objc optional var friendlyName: String { get }

    /**
     Generates a human-readable string for the given value.
     
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
 An error thrown by a `DataSourceDataUnit`
 */
public enum DataSourceDataUnitError: Error {

    /// Thrown when the supplied value's type is not supported.
    case unsupportedType(type: Any.Type)

}
