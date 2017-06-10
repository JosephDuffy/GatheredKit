//
//  AnySourceProperty.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 10/06/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 A basic implementation of `SourcePropertyProtocol` with `Any` as the `ValueType`
 */
public struct AnySourceProperty: SourcePropertyProtocol {

    /// A user-friendly name for the property
    public let displayName: String

    /// The value of the property
    public let value: Any

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    public let formattedValue: String?

    /// A unit of measurement for the value
    public let unit: SourcePropertyUnit?

    /// The date that the latest value was recorded
    public let date: Date

    fileprivate init(displayName: String, value: Any, formattedValue: String?, unit: SourcePropertyUnit?, date: Date) {
        self.displayName = displayName
        self.value = value
        self.formattedValue = formattedValue
        self.unit = unit
        self.date = date
    }

}

internal extension SourceProperty {

    func any() -> AnySourceProperty {
        return AnySourceProperty(displayName: displayName, value: value, formattedValue: formattedValue, unit: unit, date: date)
    }

}
