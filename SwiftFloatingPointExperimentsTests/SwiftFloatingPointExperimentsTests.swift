//
//  SwiftFloatingPointExperimentsTests.swift
//  SwiftFloatingPointExperimentsTests
//
//  Created by Daniel Pink on 4/09/2014.
//  Copyright (c) 2014 Daniel Pink. All rights reserved.
//

import Cocoa
import XCTest
import SwiftFloatingPointExperiments

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



struct TestData<T> {
    var left: T
    var right: T
    var epsilon: T?
    var expected: Bool
    var explanation: String
    
    init(_ left:T, _ right:T, _ expected: Bool, _ explanation:String) {
        self.left = left
        self.right = right
        self.epsilon = nil
        self.expected = expected
        self.explanation = explanation
    }
    init(_ left:T, _ right:T, _ epsilon: T?, _ expected: Bool, _ explanation:String) {
        self.left = left
        self.right = right
        self.epsilon = epsilon
        self.expected = expected
        self.explanation = explanation
    }
}

class SwiftFloatingPointExperimentsTests: XCTestCase {
    
    var floatTestData: [TestData<Float>] = [
        // Large numbers
        TestData<Float>(1000000, 1000001, true, "1. Big numbers that should be true"),
        TestData<Float>(1000001, 1000000, true, "2. Big numbers that should be true"),
        TestData<Float>(10000, 10001, false, "3. Big numbers that should be false"),
        TestData<Float>(10001, 10000, false, "4. Big numbers that should be false"),
        // Large Negative numbers
        TestData<Float>(-1000000, -1000001, true, "5. Big negative numbers that should be true"),
        TestData<Float>(-1000001, -1000000, true, "6. Big negative numbers that should be true"),
        TestData<Float>(-10000, -10001, false, "7. Big negative numbers that should be false"),
        TestData<Float>(-10001, -10000, false, "8. Big negative numbers that should be false"),
        
        // Numbers that are close to 1.0
        TestData<Float>(1.0000001, 1.0000002, true, "9. Mid numbers that should be true"),
        TestData<Float>(1.0000002, 1.0000001, true, "10. Mid numbers that should be true"),
        TestData<Float>(1.0002, 1.0001, false, "11. Mid numbers that should be false"),
        TestData<Float>(1.0001, 1.0002, false, "12. Mid numbers that should be false"),
        // Numbers that are close to -1.0
        TestData<Float>(-1.0000001, -1.0000002, true, "13. Mid negative numbers that should be true"),
        TestData<Float>(-1.0000002, -1.0000001, true, "14. Mid negative numbers that should be true"),
        TestData<Float>(-1.0002, -1.0001, false, "15. Mid negative numbers that should be false"),
        TestData<Float>(-1.0001, -1.0002, false, "16. Mid negative numbers that should be false"),
        
        // Numbers between 1 and 0
        TestData<Float>(0.000000001000001, 0.000000001000002, true, "17. Small numbers that should be true"),
        TestData<Float>(0.000000001000002, 0.000000001000001, true, "18. Small numbers that should be true"),
        TestData<Float>(0.000000000001002, 0.000000000001001, false, "19. Small numbers that should be false"),
        TestData<Float>(0.000000000001001, 0.000000000001002, false, "20. Small numbers that should be false"),
        // Numbers between -1 and 0
        TestData<Float>(-0.000000001000001, -0.000000001000002, true, "21. Small negative numbers that should be true"),
        TestData<Float>(-0.000000001000002, -0.000000001000001, true, "22. Small negative numbers that should be true"),
        TestData<Float>(-0.000000000001002, -0.000000000001001, false, "23. Small negative numbers that should be false"),
        TestData<Float>(-0.000000000001001, -0.000000000001002, false, "24. Small negative numbers that should be false"),

        // Comparisons involving zero
        TestData<Float>(0.0, 0.0, true, "25. Comparisons involving zero that should be true"),
        TestData<Float>(0.0, -0.0, true, "26. Comparisons involving zero that should be true"),
        TestData<Float>(-0.0, -0.0, true, "27. Comparisons involving zero that should be true"),
        TestData<Float>(0.00000001, 0.0, false, "28. Comparisons involving zero that should be false"),
        TestData<Float>(0.0, 0.00000001, false, "29. Comparisons involving zero that should be false"),
        TestData<Float>(-0.00000001, 0.0, false, "30. Comparisons involving zero that should be false"),
        TestData<Float>(0.0, -0.00000001, false, "31. Comparisons involving zero that should be false"),
        
        TestData<Float>(0.0, 1e-40, 0.01, true, "32. Comparisons involving zero that should be true"),
        TestData<Float>(1e-40, 0.0, 0.01, true, "33. Comparisons involving zero that should be true"),
        TestData<Float>(1e-40, 0.0, 0.000001, false, "34. Comparisons involving zero that should be false"),
        TestData<Float>(0.0, 1e-40, 0.000001, false, "35. Comparisons involving zero that should be false"),
        
        TestData<Float>(0.0, -1e-40, 0.1, true, "36. Comparisons involving zero that should be true"),
        TestData<Float>(-1e-40, 0.0, 0.1, true, "37. Comparisons involving zero that should be true"),
        TestData<Float>(-1e-40, 0.0, 0.00000001, false, "38. Comparisons involving zero that should be false"),
        TestData<Float>(0.0, -1e-40, 0.00000001, false, "39. Comparisons involving zero that should be false"),
        
        // Comparisons involving infinities
        TestData<Float>(Float.infinity, Float.infinity, true, "40. Comparisons involving infinities that should be true"),
        TestData<Float>(-Float.infinity, -Float.infinity, true, "41. Comparisons involving infinities that should be true"),
        TestData<Float>(Float.infinity, -Float.infinity, false, "42. Comparisons involving infinities that should be false"),
        TestData<Float>(Float.infinity, Float.max, false, "43. Comparisons involving infinities that should be false"),
        TestData<Float>(-Float.infinity, -Float.max, false, "44. Comparisons involving infinities that should be false"),

        // Comparisons involving NaN values
        TestData<Float>(Float.NaN, Float.NaN, false, "43. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.NaN, 0.0, false, "44. Comparisons involving NaN values that should be false"),
        TestData<Float>(-0.0, Float.NaN, false, "45. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.NaN, -0.0, false, "46. Comparisons involving NaN values that should be false"),
        TestData<Float>(0.0, Float.NaN, false, "47. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.NaN, Float.infinity, false, "48. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.infinity, Float.NaN, false, "49. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.NaN, -Float.infinity, false, "50. Comparisons involving NaN values that should be false"),
        TestData<Float>(-Float.infinity, Float.NaN, false, "51. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.NaN, Float.max, false, "52. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.max, Float.NaN, false, "53. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.NaN, -Float.max, false, "54. Comparisons involving NaN values that should be false"),
        TestData<Float>(-Float.max, Float.NaN, false, "55. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.NaN, Float.min, false, "56. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.min, Float.NaN, false, "57. Comparisons involving NaN values that should be false"),
        TestData<Float>(Float.NaN, -Float.min, false, "58. Comparisons involving NaN values that should be false"),
        TestData<Float>(-Float.min, Float.NaN, false, "59. Comparisons involving NaN values that should be false"),
        
        // Comparisons of numbers on opposite sides of 0
        TestData<Float>(1.000000001, -1.0, false, "60. Comparisons of numbers on opposite sides of 0 that should be false"),
        TestData<Float>(-1.0, 1.000000001, false, "61. Comparisons of numbers on opposite sides of 0 that should be false"),
        TestData<Float>(-1.000000001, 1.0, false, "62. Comparisons of numbers on opposite sides of 0 that should be false"),
        TestData<Float>(1.0, -1.000000001, false, "63. Comparisons of numbers on opposite sides of 0 that should be false"),
        TestData<Float>(10 * Float.min, 10 * -Float.min, true, "64. Comparisons of numbers on opposite sides of 0 that should be true"),
        TestData<Float>(10000 * Float.min, 10000 * -Float.min, false, "65. Comparisons of numbers on opposite sides of 0 that should be false"),

        // Comparisons of numbers very close to zero
        TestData<Float>(Float.min, -Float.min, true, "66. Comparisons of numbers very close to zero that should be true"),
        TestData<Float>(-Float.min, Float.min, true, "67. Comparisons of numbers very close to zero that should be true"),
        TestData<Float>(Float.min, 0, true, "68. Comparisons of numbers very close to zero that should be true"),
        TestData<Float>(0, Float.min, true, "69. Comparisons of numbers very close to zero that should be true"),
        TestData<Float>(-Float.min, 0, true, "70. Comparisons of numbers very close to zero that should be true"),
        TestData<Float>(0, -Float.min, true, "71. Comparisons of numbers very close to zero that should be true"),
        
        TestData<Float>(0.000000001, -Float.min, false, "72. Comparisons of numbers very close to zero that should be false"),
        TestData<Float>(0.000000001, Float.min, false, "73. Comparisons of numbers very close to zero that should be false"),
        TestData<Float>(Float.min, 0.000000001, false, "74. Comparisons of numbers very close to zero that should be false"),
        TestData<Float>(-Float.min, 0.000000001, false, "75. Comparisons of numbers very close to zero that should be false"),
    ]
    
    func testBuiltinEquality() {
        // Using Swifts builtin == operator on Floats
        for test in floatTestData {
            XCTAssert((test.left == test.right) == test.expected, test.explanation)
        }
    }
    
    func testFloatNearlyEqual1() {
        // Using the implementation of serlyEqual from http://floating-point-gui.de/errors/comparison/
        
        for test in floatTestData {
            if let ep = test.epsilon {
                XCTAssert(nearlyEqual(test.left, test.right, ep) == test.expected, test.explanation)
            } else {
                XCTAssert(nearlyEqual(test.left, test.right) == test.expected, test.explanation)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}