//
//  PolynomTests.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import XCTest
@testable import DiagramGeometry

class PolynomTests: XCTestCase {

    func testCubicPolynomWithOneRoot() {
        let polynom = Polynom(3, 2, 2, 0)
        XCTAssertEqual(polynom.roots.count, 1)
        XCTAssertEqual(polynom.roots[0], 0.0)
    }
    
    func testCubicPolynomWithTwoRoot() {
        let polynom = Polynom(2, -11, 12, 9)
        let roots = polynom.roots.sorted()
        XCTAssertEqual(roots.count, 2)
        XCTAssertEqual(roots[0], -0.5, accuracy: 0.001)
        XCTAssertEqual(roots[1], 3.0, accuracy: 0.001)
    }
    
    func testCubicPolynomWithThreeRoots() {
        let polynom = Polynom(5, -8, -8, 5)
        let roots = polynom.roots.sorted()
        XCTAssertEqual(roots.count, 3)
        XCTAssertEqual(roots[0], -1.0, accuracy: 0.001)
        XCTAssertEqual(roots[1], 0.469, accuracy: 0.001)
        XCTAssertEqual(roots[2], 2.131, accuracy: 0.001)
    }
    
    func testQuadraticPolynomWithTwoRoots() {
        let polynom = Polynom(1, 2, -6)
        let roots = polynom.roots.sorted()
        XCTAssertEqual(roots[0], -3.6457513110645907, accuracy: 0.001)
        XCTAssertEqual(roots[1], 1.6457513110645907, accuracy: 0.001)
    }
    
    func testQuadraticPolynomWithOneRoot() {
        let polynom = Polynom(-4, 28, -49)
        let roots = polynom.roots.sorted()
        XCTAssertEqual(roots.count, 1)
        XCTAssertEqual(roots[0], 3.5, accuracy:0.001)
    }
    
    func testQuadraticPolynomWithoutRoots() {
        let polynom = Polynom(5, 6, 2)
        let roots = polynom.roots.sorted()
        XCTAssertEqual(roots.count, 0)
    }
    
    func testLinearPolynom() {
        let polynom = Polynom(0, 7, 28)
        let roots = polynom.roots.sorted()
        XCTAssertEqual(roots.count, 1)
        XCTAssertEqual(roots[0], -4, accuracy: 0.001)
    }
    
    func testConstantPolynom() {
        let polynom = Polynom(0, 0, 28)
        let roots = polynom.roots.sorted()
        XCTAssertEqual(roots.count, 0)
    }
}
