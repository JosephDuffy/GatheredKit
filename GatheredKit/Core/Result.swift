//
//  Result.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 21/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

/**
 An enum that respresents the result of an action
 */
internal enum Result<SuccessType> {

    /// This value indicates that the action was successful
    case success(SuccessType)

    /// This value indicates that the action failed. If the property is `nil` an unknown error occurred
    case failure(Error?)

}
