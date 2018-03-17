//
//  BezierCurve.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public protocol BezierCurve {
    
    var point1: Point { get }
    var point2: Point { get }
    
    func point(at t: Double) -> Point
    func split(at t: Double) -> (BezierCurve, BezierCurve)
    
    func intersections(with line: Line, extended: Bool) -> [Double]
}

public extension BezierCurve {
    subscript(t: Double) -> Point {
        return point(at: t)
    }
}
