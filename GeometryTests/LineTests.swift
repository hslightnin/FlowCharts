//
//  LineTests.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import XCTest
@testable import DiagramGeometry

class LineTests: XCTestCase {

    func testInitWithTwoPoints() {
        let line = Line(point1: Point(3, 7), point2: Point(5, 11))!
        XCTAssertEqual(line.a, -4, accuracy: 0.001)
        XCTAssertEqual(line.b, 2, accuracy: 0.001)
        XCTAssertEqual(line.c, -2, accuracy: 0.001)
    }
}
