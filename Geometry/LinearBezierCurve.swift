//
//  LinearBezierCurve.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class LinearBezierCurve: BezierCurve, Equatable {
    
    public let point1: Point
    public let point2: Point
    
    public init(point1: Point, point2: Point) {
        self.point1 = point1
        self.point2 = point2
    }
        
    public func point(at t: Double) -> Point {
        return Point(
            point1.x + t * (point2.x - point1.x),
            point1.y + t * (point2.y - point1.y)
        )
    }
    
    public func split(at t: Double) -> (BezierCurve, BezierCurve) {
        let splitPoint = self.point(at: t)
        return (
            LinearBezierCurve(point1: point1, point2: splitPoint),
            LinearBezierCurve(point1: splitPoint, point2: point2)
        )
    }
    
    public func intersections(with line: Line, extended: Bool) -> [Double] {
        
        // For general idea behind this code see intersections(with line:) for CubicBezierCurve
        
        let b1 = -point1 + point2
        let b0 = point1
        
        let c1 = line.a * b1.x + line.b * b1.y
        let c0 = line.a * b0.x + line.b * b0.y + line.c
        
        let polynom = Polynom(0.0, c1, c0)
        
        if extended {
            return polynom.roots
        } else {
            return polynom.roots.filter { $0 >= 0.0 && $0 <= 1.0 }
        }
    }
    
    public static func ==(lhs: LinearBezierCurve, rhs: LinearBezierCurve) -> Bool {
        return lhs.point1 == rhs.point1 && lhs.point2 == rhs.point2
    }
}

extension LinearBezierCurve: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Linear Curve: (\(point1.x), \(point1.y)) -> (\(point2.x), \(point2.y))"
    }
}
