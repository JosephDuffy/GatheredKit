//
//  Timer+Block.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 03/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Foundation

extension Timer {

    /**
     Creates and returns a `Timer` that repeates every `timerInterval` seconds
     
     - parameter timeInterval: The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
     - parameter block: The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
     
     - returns: The newly created `Timer`
    */
    class func createRepeatingTimer(timeInterval interval: TimeInterval, block: @escaping (Timer?) -> Void) -> Timer {
        if #available(iOS 10.0, *) {
            return Timer(timeInterval: interval, repeats: true, block: block)
        } else {
            let fireDate = CFAbsoluteTimeGetCurrent() + interval
            let timer: Timer! = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, block)
            return timer
        }
    }

}
