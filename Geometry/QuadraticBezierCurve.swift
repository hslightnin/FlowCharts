//
//  QuadraticBezierCurve.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class QuadraticBezierCurve: BezierCurve, Equatable {
    
    public let point1: Point
    public let controlPoint: Point
    public let point2: Point
    
    public init(point1: Point, controlPoint: Point, point2: Point) {
        self.point1 = point1
        self.controlPoint = controlPoint
        self.point2 = point2
    }
    
    public func point(at t: Double) -> Point {
        return Point(
            (1 - t) * (1 - t) * point1.x + 2 * t * (1 - t) * controlPoint.x + t * t * point2.x,
            (1 - t) * (1 - t) * point1.y + 2 * t * (1 - t) * controlPoint.y + t * t * point2.y
        )
    }
    
    public func split(at t: Double) -> (BezierCurve, BezierCurve) {
        
        // De Casteljau algorithm
        
        let control1 = point1 + t * (controlPoint - point1)
        let control2 = controlPoint + t * (point2 - controlPoint)
        let splitPoint = control1 + t * (control2 - control1)
        
        return (
            QuadraticBezierCurve(point1: point1, controlPoint: control1, point2: splitPoint),
            QuadraticBezierCurve(point1: splitPoint, controlPoint: control2, point2: point2)
        )
    }
    
    public func intersections(with line: Line, extended: Bool) -> [Double] {
        
        // For general idea behind this code see intersections(with line:) for CubicBezierCurve
        
        let p0 = point1
        let p1 = controlPoint
        let p2 = point2
        
        let b2 = Point(p0.x - 2 * p1.x + p2.x, p0.y - 2 * p1.y + p2.y)
        let b1 = Point(-2 * p0.x + 2 * p1.x, -2 * p0.y + 2 * p1.y)
        let b0 = p0
        
        let c2 = line.a * b2.x + line.b * b2.y
        let c1 = line.a * b1.x + line.b * b1.y
        let c0 = line.a * b0.x + line.b * b0.y + line.c
        
        let polynom = Polynom(c2, c1, c0)
        
        if extended {
            return polynom.roots
        } else {
            return polynom.roots.filter { $0 >= 0.0 && $0 <= 1.0 }
        }
    }
    
    public static func ==(lhs: QuadraticBezierCurve, rhs: QuadraticBezierCurve) -> Bool {
        return lhs.point1 == rhs.point1 &&
            lhs.point2 == rhs.point2 &&
            lhs.controlPoint == rhs.controlPoint
    }
}

extension QuadraticBezierCurve: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Quadratic Curve: (\(point1.x), \(point1.y)) -> " +
                "(\(controlPoint.x), \(controlPoint.y)) -> " +
                "(\(point2.x), \(point2.y))"
    }
}



