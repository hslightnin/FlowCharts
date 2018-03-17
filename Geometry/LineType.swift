//
//  LineType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public protocol LineType {
    func path(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath
    func centerCurveIndex(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Int
}
