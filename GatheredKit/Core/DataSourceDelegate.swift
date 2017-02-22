//
//  DataSourceDelegate.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 05/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 The delegate of a `DataSource` object implements this protocol to be notified when a data source's data is update
 */
public protocol DataSourceDelegate: class {

    /**
     A function that is called when a data source's data is refreshed. The `data` array
     will contain all of the data that data source has. It is up to the implementer to do a diff
     of the data to determine what changed. Note that it is not guarenteed that any of the data provided
     will be new if the data source does not conform to `AutomaticallyUpdatingDataSource`
     
     - parameter dataSource: The data source that updated its data
     - parameter data: An array of the data source's data
     */
    func dataSource(_ dataSource: DataSource, updatedData data: [DataSourceData])
    
}

/**
 A protocol that inherits from `DataSourceDelegate` and adds a function to handle errors
 */
public protocol DataSourceErrorHandlingDelegate: DataSourceDelegate {

    /**
     A function that is called when the data source encounters and error when refreshing the data. A value of `nil` for the
     `error` parameter indeicates that an unknown error occurred
     
     - parameter dataSource: The data source that the encountered the error
     - parameter error: The error that occurred, or `nil` if an unknown error occurred
     */
    func dataSource(_ dataSource: DataSource, gotErrorWhileRefreshing error: Error?)

}
