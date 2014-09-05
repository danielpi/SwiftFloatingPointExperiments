// Playground - noun: a place where people can play

import Cocoa

extension Float {
    static var minNormal: Float { return 1.18e-38 }
    static var min: Float { return 1.4e-45 }
    static var max: Float { return 3.4e38 }
}

extension Double {
    static var minNormal: Double { return 2.2250738585072014e-308 }
    static var min: Double { return 4.9406564584124654e-324 }
    static var max: Double { return 1.7976931348623157e308 }
}


let floatMin = Float.min
let floatMinNormal = Float.minNormal
let floatEpsilon = FLT_EPSILON
let floatNearlyEqualThreshold = 0.00001
let floatMax = Float.max

let doubleMin = Double.min
let doubleMinNormal = Double.minNormal
let doubleEpsilon = DBL_EPSILON
let doubleNearlyEqualThreshold = 0.00000000000001 // I picked this. It is probably wrong
let doubleMax = Double.max // If you drop the least significant digit off this it becomes a number again (rather than +infinity)



