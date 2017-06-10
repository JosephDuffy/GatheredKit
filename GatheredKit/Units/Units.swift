//
//  Units.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 A struct that represents Beats Per Minute (BPS)
 */
public struct BeatsPerMinute: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 0

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " BPM"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " BPM"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }
    
}

/**
 A struct that represents computer bytes
 */
public struct Byte: SourcePropertyUnit {

    /// How the bytes should be styled
    public let countStyle: ByteCountFormatter.CountStyle

    /**
     Create a new `Byte` instance
     
     - parameter countStyle: How the bytes should be styled. It is recommended that the `files` or `memory` style is used
     */
    public init(countStyle: ByteCountFormatter.CountStyle) {
        self.countStyle = countStyle
    }

    /**
     Generates a human-friendly string for the given number

     - parameter value: The number to be formatted

     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` parameter's type is not an `NSNumber`

     - returns: The formatted string
     */
    public func formattedString(for value: Any) throws -> String {
        guard let numberValue = value as? NSNumber else {
            throw SourcePropertyUnitError.unsupportedType(type: type(of: value))
        }

        return ByteCountFormatter.string(fromByteCount: numberValue.int64Value, countStyle: countStyle)
    }

}

/**
 A struct that represents a value that can be either true or false
 */
public struct Boolean: SourcePropertyUnit {

    /// The string that will be returned from `formattedString(for:)` when the value is `true`. If `nil`, "true" will be returned
    public let trueString: String?

    /// The string that will be returned from `formattedString(for:)` when the value is `false`. If `nil`, "false" will be returned
    public let falseString: String?

    /**
     Create a new `Boolean` instance
     
     - parameter trueString: The string to return from `formattedString(for:)` when the value is `true`. If `nil`, "true" will be used
     - parameter falseString: The string to return from `formattedString(for:)` when the value is `false`. If `nil`, "false" will be used
     */
    public init(trueString: String?, falseString: String?) {
        self.trueString = trueString
        self.falseString = falseString
    }

    /**
     Generates a human-friendly string for the given boolean

     - parameter value: The boolean to be formatted

     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` parameter's type is not a `Bool`

     - returns: The formatted string
     */
    public func formattedString(for value: Any) throws -> String {
        guard let boolValue = value as? Bool else {
            throw SourcePropertyUnitError.unsupportedType(type: type(of: value))
        }

        if boolValue, let trueString = trueString {
            return trueString
        } else if !boolValue, let falseString = falseString {
            return falseString
        } else {
            switch boolValue {
            case true:
                return "true"
            case false:
                return "false"
            }
        }
    }

}

/**
 A struct that represents decibels
 */
public struct Decibel: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 0

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " dB"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " dB"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}


/**
 A struct that represents degrees
 */
public struct Degree: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 0

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = "º"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = "º"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }
    
}

/**
 A struct that represents kilopascals
 */
public struct Kilopascal: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 2

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " kPa"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " kPa"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }
    
}

/**
 A struct that represents microteslas
 */
public struct Microtesla: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 2

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " µT"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " µT"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}

/**
 A struct that represents meters
 */
public struct Meter: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 2

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " Meter"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " Meters"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}

/**
 A struct that represents a percentage
 */
public struct Percent: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 2

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = "%"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = "%"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

    /**
     Generates a human-friendly string for the given value.
     
     This will use a `NumberFormatter` with a `numberStyle` of `percent`, meaning that
     values are multiflied by 100 before being formatter, e.g. "0.79" is represented as "79%"
     
     - parameter value: The value to be formatted. Must be castable to `NSNumber`

     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` cannot be cast to an `NSNumber`

     - returns: The formatted string
    */
    public func formattedString(for value: Any) throws -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = maximumFractionDigits

        return try self.formattedString(for: value, usingFormatter: formatter)
    }
    
}

/**
 A struct that represents a screen's pixels
 */
public struct Pixel: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 0

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " Pixel"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " Pixels"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}

/**
 A struct that represents a screen's resolution measured in points
 */
public struct Point: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 0

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " Point"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " Points"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit

     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
    */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }
    
}
