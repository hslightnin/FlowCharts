//
//  LinearBezierCurveTests.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import XCTest
@testable import DiagramGeometry

class LinearBezierCurveTests: XCTestCase {

    func testPointAt() {
        let curve = LinearBezierCurve(point1: Point(1.0, 2.0), point2: Point(4.0, 6.0))
        XCTAssertEqual(curve.point(at: 0.5), Point(2.5, 4.0))
    }
    
    func testSplitAt() {
        let curve = LinearBezierCurve(point1: Point(0, 0), point2: Point(10, 5))
        let (subCurve1, subCurve2) = curve.split(at: 0.3)
        XCTAssert(subCurve1 is LinearBezierCurve)
        XCTAssert(subCurve2 is LinearBezierCurve)
        XCTAssertEqual(subCurve1.point1, Point(0, 0))
        XCTAssertEqual(subCurve1.point2, Point(3, 1.5))
        XCTAssertEqual(subCurve2.point1, Point(3, 1.5))
        XCTAssertEqual(subCurve2.point2, Point(10, 5))
    }
    
    func testIntersectionsWithLineZeroIntersections() {
        let curve = LinearBezierCurve(point1: Point(0, 0), point2: Point(10, 5))
        let line = Line(point1: Point(12, 0), point2: Point(14, 4))!
        let intersections = curve.intersections(with: line, extended: false)
        XCTAssertEqual(intersections.count, 0)
    }
    
    func testIntersectionsWithLineOneIntersection() {
        let curve = LinearBezierCurve(point1: Point(0, 0), point2: Point(10, 5))
        let line = Line(point1: Point(12, 0), point2: Point(8, 4))!
        let intersections = curve.intersections(with: line, extended: true)
        XCTAssertEqual(intersections.count, 1)
        XCTAssertEqual(intersections[0], 0.8, accuracy: 0.001)
    }
    
    func testEqual() {
        let curve1 = LinearBezierCurve(point1: Point(1, 1), point2: Point(2, 2))
        let curve2 = LinearBezierCurve(point1: Point(1, 1), point2: Point(2, 2))
        XCTAssert(curve1 == curve2)
    }
    
    func testNotEqual() {
        let curve1 = LinearBezierCurve(point1: Point(1, 1), point2: Point(2, 2))
        let curve2 = LinearBezierCurve(point1: Point(1, 1), point2: Point(3, 2))
        XCTAssert(curve1 != curve2)
    }
}
