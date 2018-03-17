//
//  CubicBezierCurveTests.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import XCTest
@testable import DiagramGeometry

class CubicBezierCurveTests: XCTestCase {

    func testPointAt() {
        let curve = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(14, 3))
        XCTAssertEqual(curve.point(at: 0.4).x, 4.064, accuracy: 0.001)
        XCTAssertEqual(curve.point(at: 0.4).y, 4.368, accuracy: 0.001)
    }
    
    func testSplitAt() {
        
        let curve = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(14, 3))
        let (subCurve1, subCurve2) = curve.split(at: 0.4)
        
        XCTAssert(subCurve1 is CubicBezierCurve)
        XCTAssert(subCurve2 is CubicBezierCurve)
        
        if let cubicSubCurve1 = subCurve1 as? CubicBezierCurve {
            XCTAssertEqual(cubicSubCurve1.point1.x, -2.000, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve1.point1.y, 2.000, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve1.controlPoint1.x, 0.000, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve1.controlPoint1.y, 2.000, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve1.controlPoint2.x, 2.000, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve1.controlPoint2.y, 3.280, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve1.point2.x, 4.064, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve1.point2.y, 4.368, accuracy: 0.001)
        }
        
        if let cubicSubCurve2 = subCurve2 as? CubicBezierCurve {
            XCTAssertEqual(cubicSubCurve2.point1.x, 4.064, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve2.point1.y, 4.368, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve2.controlPoint1.x, 7.160, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve2.controlPoint1.y, 6.000, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve2.controlPoint2.x, 10.400, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve2.controlPoint2.y, 7.200, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve2.point2.x, 14.000, accuracy: 0.001)
            XCTAssertEqual(cubicSubCurve2.point2.y, 3.000, accuracy: 0.001)
        }
    }
    
    func testIntersectionsWithLineZeroIntersections() {
        let curve = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(14, 3))
        let line = Line(point1: Point(12, 0), point2: Point(16, 2))!
        let intersections = curve.intersections(with: line, extended: false)
        XCTAssertEqual(intersections.count, 0)
    }
    
    func testIntersectionsWithLineOneIntersection() {
        let curve = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(14, 3))
        let line = Line(point1: Point(4, 1), point2: Point(6, 8))!
        let intersections = curve.intersections(with: line, extended: true)
        XCTAssertEqual(intersections.count, 1)
        XCTAssertEqual(intersections[0], 0.467, accuracy: 0.001)
    }
    
    func testIntersectionsWithLineTwoIntersection() {
        let curve = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(14, 3))
        let line = Line(point1: Point(2, 4), point2: Point(12, 6))!
        let intersections = curve.intersections(with: line, extended: false).sorted()
        XCTAssertEqual(intersections.count, 2)
        XCTAssertEqual(intersections[0], 0.409, accuracy: 0.001)
        XCTAssertEqual(intersections[1], 0.786, accuracy: 0.001)
    }
    
    func testIntersectionsWithLineThreeIntersection() {
        let curve = CubicBezierCurve(point1: Point(-2.5, 5), controlPoint1: Point(2, -6), controlPoint2: Point(8, 14), point2: Point(14, 3))
        let line = Line(point1: Point(-2, 2), point2: Point(14, 6))!
        let intersections = curve.intersections(with: line, extended: true).sorted()
        XCTAssertEqual(intersections.count, 3)
        XCTAssertEqual(intersections[0], 0.118, accuracy: 0.001)
        XCTAssertEqual(intersections[1], 0.478, accuracy: 0.001)
        XCTAssertEqual(intersections[2], 0.894, accuracy: 0.001)
    }
    
    func testEqual() {
        let curve1 = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(14, 3))
        let curve2 = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(14, 3))
        XCTAssert(curve1 == curve2)
    }
    
    func testNotEqual() {
        let curve1 = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(14, 3))
        let curve2 = CubicBezierCurve(point1: Point(-2, 2), controlPoint1: Point(3, 2), controlPoint2: Point(8, 10), point2: Point(19, 3))
        XCTAssert(curve1 != curve2)
    }
}
