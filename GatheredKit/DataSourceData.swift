//
//  DataSourceData.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

public struct DataSourceData {

    /// A user-friendly name for the data source
    public let displayName: String

    /// The data source that supplied the data
    public let dataSource: DataSource.Type

    public let rawValue: Any?

}
