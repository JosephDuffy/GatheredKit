//
//  Units.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

public struct BeatsPerMinute: NumberBasedDataSourceDataUnit {

    public let singularValueSuffix = " BPM"

    public let pluralValueSuffix: String? = nil

    public let maximumFractionDigits: Int

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    public init() {
        self.maximumFractionDigits = 0
    }
    
}

public struct Byte {

    public let countStyle: ByteCountFormatter.CountStyle

    public init(countStyle: ByteCountFormatter.CountStyle) {
        self.countStyle = countStyle
    }

    public func formattedString(for value: Any) throws -> String {
        guard let numberValue = value as? NSNumber else {
            throw DataSourceDataUnitError.unsupportedType(type: type(of: value))
        }

        return ByteCountFormatter.string(fromByteCount: numberValue.int64Value, countStyle: countStyle)
    }

}

public struct Boolean: DataSourceDataUnit {

    public let trueString: String?

    public let falseString: String?

    public init(trueString: String?, falseString: String?) {
        self.trueString = trueString
        self.falseString = falseString
    }

    public func formattedString(for value: Any) throws -> String {
        guard let boolValue = value as? Bool else {
            throw DataSourceDataUnitError.unsupportedType(type: type(of: value))
        }

        if boolValue, let trueString = trueString {
            return trueString
        } else if !boolValue, let falseString = falseString {
            return falseString
        } else {
            return boolValue.description
        }
    }

}

public struct Decibel: NumberBasedDataSourceDataUnit {

    public let singularValueSuffix = " dB"

    public let pluralValueSuffix: String? = nil

    public let maximumFractionDigits: Int

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    public init() {
        self.maximumFractionDigits = 0
    }

}

public struct Degree: NumberBasedDataSourceDataUnit {

    public let singularValueSuffix = "º"

    public let pluralValueSuffix: String? = nil

    public let maximumFractionDigits: Int

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    public init() {
        self.maximumFractionDigits = 0
    }
    
}

public struct Kilopascal: NumberBasedDataSourceDataUnit {

    public let singularValueSuffix = " kPa"

    public let pluralValueSuffix: String? = nil

    public let maximumFractionDigits: Int

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    public init() {
        self.maximumFractionDigits = 2
    }
    
}


public struct Meter: NumberBasedDataSourceDataUnit {

    public let singularValueSuffix = " Meter"

    public let pluralValueSuffix: String? = " Meters"

    public let maximumFractionDigits: Int

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    public init() {
        self.maximumFractionDigits = 2
    }
}

public struct Percent: NumberBasedDataSourceDataUnit {

    public let singularValueSuffix = "%"

    public let pluralValueSuffix: String? = nil

    public let maximumFractionDigits: Int

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    public init() {
        self.maximumFractionDigits = 0
    }

    /**
     Generates a human-friendly string for the given value.
     
     This will use a `NumberFormatter` with a `numberStyle` of `percent`, meaning that
     values are multiflied by 100 before being formatter, e.g. "0.79" is represented as "79%"
     
     - parameter value: The value to be formatted. Must be castable to `NSNumber`

     - throws: `DataSourceDataUnitError.unsupportedType` if the `value` cannot be cast to an `NSNumber`

     - returns: The formatted string
    */
    public func formattedString(for value: Any) throws -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = maximumFractionDigits

        return try self.formattedString(for: value, usingFormatter: formatter)
    }
    
}

public struct Pixel: NumberBasedDataSourceDataUnit {

    public let singularValueSuffix = " Pixel"

    public let pluralValueSuffix: String? = nil

    public let maximumFractionDigits: Int

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    public init() {
        self.maximumFractionDigits = 0
    }

}

public struct Point: NumberBasedDataSourceDataUnit {

    public let singularValueSuffix = " Point"

    public let pluralValueSuffix: String? = " Points"

    public let maximumFractionDigits: Int

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    public init() {
        self.maximumFractionDigits = 0
    }
    
}
