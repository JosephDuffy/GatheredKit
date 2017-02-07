//
//  DataSourceDelegate.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 05/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 A protocol that something can conform to to be notified when a data source's  data is updated
 */
public protocol DataSourceDelegate: class {

    /**
     A function that is called when a data source's data is updated. The `updatedData` array
     will contain all data that data source has; it is up to the implementer to do a diff
     of the data to determine what changed
     
     - parameter dataSource: The data source whom's data changed
     - parameter updateData: An array containing the new data
    */
    func dataSource(_ dataSource: DataSource, updatedData data: [DataSourceData])
    
}
