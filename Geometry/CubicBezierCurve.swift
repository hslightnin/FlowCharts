//
//  CubicBezierCurve.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class CubicBezierCurve: BezierCurve, Equatable {
    
    public let point1: Point
    public let controlPoint1: Point
    public let controlPoint2: Point
    public let point2: Point
    
    public init(point1: Point, controlPoint1: Point, controlPoint2: Point, point2: Point) {
        self.point1 = point1
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
        self.point2 = point2
    }
    
    public func point(at t: Double) -> Point {
        return Point(
            (1 - t) * (1 - t) * (1 - t) * point1.x +
                3 * (1 - t) * (1 - t) * t * controlPoint1.x +
                3 * (1 - t) * t * t * controlPoint2.x +
                t * t * t * point2.x,
            (1 - t) * (1 - t) * (1 - t) * point1.y +
                3 * (1 - t) * (1 - t) * t * controlPoint1.y +
                3 * (1 - t) * t * t * controlPoint2.y +
                t * t * t * point2.y
        )
    }
    
    public func split(at t: Double) -> (BezierCurve, BezierCurve) {
    
        // De Casteljau algorithm
        
        let control1 = point1 + t * (controlPoint1 - point1)
        let control2 = controlPoint1 + t * (controlPoint2 - controlPoint1)
        let control3 = controlPoint2 + t * (point2 - controlPoint2)
        let control4 = control1 + t * (control2 - control1)
        let control5 = control2 + t * (control3 - control2)
        let splitPoint = control4 + t * (control5 - control4)
        
        return (
            CubicBezierCurve(point1: point1, controlPoint1: control1, controlPoint2: control4, point2: splitPoint),
            CubicBezierCurve(point1: splitPoint, controlPoint1: control5, controlPoint2: control3, point2: point2)
        )
    }
    
    public func intersections(with line: Line, extended: Bool) -> [Double] {
        
        // Line equation:
        // Ax + By + C = 0                                  (1)
        
        // Bezier curve equation:
        // B(t) = (1 - t)^3 * P0 + 3 * (1 - t)^2 * t * P1 + 3 * (1 - t) * t^2 * P2 + t^3 * P3
        //
        // This equation converts to:
        // B(t) = B3 * t^3 + B2 * t^2 + B1 * t + B0
        // Where:
        // B3 = -P0 + 3 * P1 - 3 * P2 + P3
        // B2 = 3 * P0 - 6 * P1 + 3 * P2
        // B1 = -3 * P0 + 3 * P1
        // B0 = P0
        //
        // The same equation for x and y:
        // x(t) = B3x * t^3 + B2x * t^2 + B1x * t + B0x     (2)
        // y(t) = B3y * t^3 + B2y * t^2 + B1y * t + B0y     (3)
        
        let p0 = point1
        let p1 = controlPoint1
        let p2 = controlPoint2
        let p3 = point2
        
        let b3 = Point(-p0.x + 3 * p1.x - 3 * p2.x + p3.x, -p0.y + 3 * p1.y - 3 * p2.y + p3.y)
        let b2 = Point(3 * p0.x - 6 * p1.x + 3 * p2.x, 3 * p0.y - 6 * p1.y + 3 * p2.y)
        let b1 = Point(-3 * p0.x + 3 * p1.x, -3 * p0.y + 3 * p1.y)
        let b0 = p0
        
        // Substitute curve equations (2) and (3) into line equation (1):
        // A * (B3x * t^3 + B2x * t^2 + B1x * t + B0) + B * (B3y * t^3 + B2y * t^2 + B1y * t + B0) + C = 0
        //
        // This equation converts to:
        // C3 * t^3 + C2 * t^2 + C1 * t + C0 = 0            (4)
        // Where:
        // C3 = A * B3x + B + B3y
        // C2 = A * B2x + B + B2y
        // C1 = A * B1x + B + B1y
        // C0 = A * B0x + B + B0y + C
        //
        // Equation (4) is cubic polynom, which roots are values of t where curve intersects line
        
        let c3 = line.a * b3.x + line.b * b3.y
        let c2 = line.a * b2.x + line.b * b2.y
        let c1 = line.a * b1.x + line.b * b1.y
        let c0 = line.a * b0.x + line.b * b0.y + line.c
        
        let polynom = Polynom(c3, c2, c1, c0)
        
        if extended {
            return polynom.roots
        } else {
            return polynom.roots.filter { $0 >= 0.0 && $0 <= 1.0 }
        }
    }
    
    public static func ==(lhs: CubicBezierCurve, rhs: CubicBezierCurve) -> Bool {
        return lhs.point1 == rhs.point1 &&
            lhs.point2 == rhs.point2 &&
            lhs.controlPoint1 == rhs.controlPoint1 &&
            lhs.controlPoint2 == rhs.controlPoint2
    }
}

extension CubicBezierCurve: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Cubic Curve: (\(point1.x), \(point1.y)) -> " +
                "(\(controlPoint1.x), \(controlPoint1.y)) -> " +
                "(\(controlPoint2.x), \(controlPoint2.y)) -> " +
                "(\(point2.x), \(point2.y))"
    }
}
