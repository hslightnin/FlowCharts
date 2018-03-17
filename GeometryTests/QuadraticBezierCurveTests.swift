//
//  QuadraticBezierCurveTests.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import XCTest
@testable import DiagramGeometry

class QuadraticBezierCurveTests: XCTestCase {

    func testPointAt() {
        let curve = QuadraticBezierCurve(point1: Point(1, 2), controlPoint: Point(-1, 7), point2: Point(4, 6))
        XCTAssertEqual(curve.point(at: 0.7).x, 1.630, accuracy: 0.001)
        XCTAssertEqual(curve.point(at: 0.7).y, 6.060, accuracy: 0.001)
    }
    
    func testSplitAt() {
        let curve = QuadraticBezierCurve(point1: Point(3, 4), controlPoint: Point(2, 1.5), point2: Point(1, 7))
        let (subCurve1, subCurve2) = curve.split(at: 0.3)
        
        XCTAssert(subCurve1 is QuadraticBezierCurve)
        XCTAssert(subCurve2 is QuadraticBezierCurve)
        
        if let quadSubCurve1 = subCurve1 as? QuadraticBezierCurve {
            XCTAssertEqual(quadSubCurve1.point1.x, 3.00, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve1.point1.y, 4.00, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve1.controlPoint.x, 2.70, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve1.controlPoint.y, 3.25, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve1.point2.x, 2.40, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve1.point2.y, 3.22, accuracy: 0.001)
        }
        
        if let quadSubCurve2 = subCurve2 as? QuadraticBezierCurve {
            XCTAssertEqual(quadSubCurve2.point1.x, 2.40, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve2.point1.y, 3.22, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve2.controlPoint.x, 1.70, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve2.controlPoint.y, 3.15, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve2.point2.x, 1.00, accuracy: 0.001)
            XCTAssertEqual(quadSubCurve2.point2.y, 7.00, accuracy: 0.001)
        }
    }
    
    func testIntersectionsWithLineZeroIntersections() {
        let curve = QuadraticBezierCurve(point1: Point(1, 2), controlPoint: Point(-1, 7), point2: Point(4, 6))
        let line = Line(point1: Point(-2, 1), point2: Point(-3, 4))!
        let intersections = curve.intersections(with: line, extended: true)
        XCTAssertEqual(intersections.count, 0)
    }
    
    func testIntersectionsWithLineOneIntersection() {
        let curve = QuadraticBezierCurve(point1: Point(1, 2), controlPoint: Point(-1, 7), point2: Point(4, 6))
        let line = Line(point1: Point(-2, 1), point2: Point(2, 3))!
        let intersections = curve.intersections(with: line, extended: false)
        XCTAssertEqual(intersections.count, 1)
        XCTAssertEqual(intersections[0], 0.043, accuracy: 0.001)
    }
    
    func testIntersectionsWithLineTwoIntersections() {
        let curve = QuadraticBezierCurve(point1: Point(1, 2), controlPoint: Point(-1, 7), point2: Point(4, 6))
        let line = Line(point1: Point(0, 2), point2: Point(2, 7))!
        let intersections = curve.intersections(with: line, extended: true)
        XCTAssertEqual(intersections.count, 2)
        XCTAssertEqual(intersections[0], 0.152, accuracy: 0.001)
        XCTAssertEqual(intersections[1], 0.699, accuracy: 0.001)
    }
    
    func testEqual() {
        let curve1 = QuadraticBezierCurve(point1: Point(1, 2), controlPoint: Point(-1, 7), point2: Point(4, 6))
        let curve2 = QuadraticBezierCurve(point1: Point(1, 2), controlPoint: Point(-1, 7), point2: Point(4, 6))
        XCTAssert(curve1 == curve2)
    }
    
    func testNotEqual() {
        let curve1 = QuadraticBezierCurve(point1: Point(1, 2), controlPoint: Point(-1, 7), point2: Point(4, 6))
        let curve2 = QuadraticBezierCurve(point1: Point(1, 2), controlPoint: Point(-1, 7), point2: Point(8, 6))
        XCTAssert(curve1 != curve2)
    }
}
