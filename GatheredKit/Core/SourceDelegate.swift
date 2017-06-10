//
//  SourceDelegate.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 05/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 The delegate of a `Source` object implements this protocol to be notified when a source's properties are updated
 */
public protocol SourceDelegate: class {

    /**
     A function that is called when a source's properties are updated. Note that it is not guarenteed that
     any of the data provided will be new if the source does not conform to `AutomaticallyUpdatingSource`
     
     - parameter source: The source that updated its properties
     */
    func sourcePropertiesUpdated(_ source: Source)
    
}

/**
 A protocol that inherits from `SourceDelegate` and adds a function to handle errors
 */
public protocol SourceErrorHandlingDelegate: SourceDelegate {

    /**
     A function that is called when the source encounters an error. A value of `nil` for the
     `error` parameter indicates that an unknown error occurred
     
     - parameter source: The source that the encountered the error
     - parameter error: The error that occurred, or `nil` if an unknown error occurred
     */
    func source(_ source: Source, encounteredError error: Error?)

}

extension Notification.Name {

    /// Posted when a source's properties update. Object is the source whom's properties were updated
    public static let sourcePropertiesUpdated = Notification.Name("SourcePropertiesUpdated")

}

internal extension Source {

    /**
     Notifies listeners that the source's properties updated. First the delegate is notified,
     then the `dataSourceDataUpdated` notification is posted with `self` as the object
     */
    func notifyListenersPropertiesUpdated() {
        delegate?.sourcePropertiesUpdated(self)

        NotificationCenter.default.post(name: .sourcePropertiesUpdated, object: self)
    }

    /**
     Notifies the delegate that an error occured

     - parameter error: The error to notify the delegate about
     */
    func notifyDelegate(errorOccurred error: Error?) {
        guard let delegate = self.delegate as? SourceErrorHandlingDelegate else { return }

        delegate.source(self, encounteredError: error)
    }

}
