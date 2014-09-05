//
//  FloatingPoint.swift
//  SwiftFloatingPointExperiments
//
//  Created by Daniel Pink on 4/09/2014.
//  Copyright (c) 2014 Daniel Pink. All rights reserved.
//

import Foundation

// These vlues are from Wikipedia. I don't understand enough to be overly confident in them

// Double
extension Double {
    static var minNormal: Double { return 2.2250738585072014e-308 }
    static var min: Double { return 4.9406564584124654e-324 }
    static var max: Double { return 1.7976931348623157e308 }
}

public func nearlyEqual(a: Double, b: Double, epsilon: Double) -> Bool {
    let absA = abs(a)
    let absB = abs(b)
    let diff = abs(a - b)
    
    if (a == b) {
        return true
    } else if (a == 0 || b == 0 || diff < Double.minNormal) {
        return diff < (epsilon * Double.minNormal)
    } else {
        return (diff / (absA + absB)) < epsilon
    }
}

public func nearlyEqual(a: Double, b: Double) -> Bool {
    return nearlyEqual(a, b, 0.00000000000001)
}


// Float
extension Float {
    static var minNormal: Float { return 1.18e-38 }
    static var min: Float { return 1.4e-45 }
    static var max: Float { return 3.4e38 }
}

public func nearlyEqual(a: Float, b: Float, epsilon: Float) -> Bool {
    let absA = abs(a)
    let absB = abs(b)
    let diff = abs(a - b)
    
    if (a == b) {
        return true
    } else if (a == 0 || b == 0 || diff < Float.minNormal) {
        return diff < (epsilon * Float.minNormal)
    } else {
        return (diff / (absA + absB)) < epsilon
    }
}

public func nearlyEqual(a: Float, b: Float) -> Bool {
    return nearlyEqual(a, b, 0.00001)
}
