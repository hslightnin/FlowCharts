//
//  CurvedLineType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

let kMaxControlPointOffset = 100.0
let kMinControlPointOffset = 25.0

public class CurvedLineType: LineType {
    
    public init() {
        
    }
    
    public func path(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath {
        
        let curvePath = BezierPath()
        
        curvePath.move(to: point1)
        
        if (direction1 != direction2) {
            
            let control1 = originControlPoint(
                point1: point1,
                direction1: direction1,
                point2: point2,
                direction2: direction2)
            
            let control2 = endingControlPoint(
                point1: point1,
                direction1: direction1,
                point2: point2,
                direction2: direction2)
            
            curvePath.addCubicCurve(to: point2, control1: control1, control2: control2)
            
        } else {
            
            switch direction1 {
            case .right:
                let controlX = min(point1.x, point2.x) - kMaxControlPointOffset / 2
                curvePath.addCubicCurve(
                    to: point2,
                    control1: Point(controlX, point1.y),
                    control2: Point(controlX, point2.y))
            case .left:
                let controlX = max(point1.x, point2.x) + kMaxControlPointOffset / 2
                curvePath.addCubicCurve(
                    to: point2,
                    control1: Point(controlX, point1.y),
                    control2: Point(controlX, point2.y))
            case .up:
                let controlY = max(point1.y, point2.y) + kMaxControlPointOffset / 2
                curvePath.addCubicCurve(
                    to: point2,
                    control1: Point(point1.x, controlY),
                    control2: Point(point2.x, controlY))
            case .down:
                let controlY = min(point1.y, point2.y) - kMaxControlPointOffset / 2
                curvePath.addCubicCurve(
                    to: point2,
                    control1: Point(point1.x, controlY),
                    control2: Point(point2.x, controlY))
            }
        }
        
        return curvePath
    }
    
    private func originControlPoint(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Point {
        return self.controlPoint(point1: point1, direction1: direction1, point2: point2, direction2: direction2)
    }
    
    private func endingControlPoint(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Point {
        return self.controlPoint(point1: point2, direction1: direction2, point2: point1, direction2: direction1)
    }
    
    private func controlPoint(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Point {
        
        var xOffset = 0.0
        var yOffset = 0.0
        
        let xDiff = point2.x - point1.x
        let yDiff = point2.y - point1.y
        
        switch direction1 {
        case .left:
            
            xOffset = kMaxControlPointOffset
            yOffset = 0
            
            if xDiff < 2 * kMaxControlPointOffset {
                xOffset = xDiff / 2
            }
            
            if xOffset < kMinControlPointOffset {
                xOffset = kMinControlPointOffset
            }
            
            if xDiff < 0 {
                
                xOffset = -3 * xDiff / 2
                
                if xOffset < kMinControlPointOffset {
                    xOffset = kMinControlPointOffset
                }
                
                if xOffset > kMaxControlPointOffset {
                    xOffset = kMaxControlPointOffset
                }
            }
            
        case .right:
            
            xOffset = -kMaxControlPointOffset
            yOffset = 0
    
            if xDiff < 0 {
        
                if -xDiff < 2 * kMaxControlPointOffset {
                    xOffset = xDiff / 2
                }
        
                if fabs(xOffset) < kMinControlPointOffset {
                    xOffset = -kMinControlPointOffset
                }
        
            } else {
        
                xOffset = -3 * xDiff / 2;
    
                if xOffset > -kMinControlPointOffset {
                    xOffset = -kMinControlPointOffset
                }
            
                if xOffset < -kMaxControlPointOffset {
                    xOffset = -kMaxControlPointOffset
                }
            }
            
        case .down:
            
            xOffset = 0
            yOffset = -kMaxControlPointOffset
            
            if yDiff < 0 {
                
                if -yDiff < 2 * kMaxControlPointOffset {
                    yOffset = yDiff / 2
                }
                
                if fabs(yOffset) < kMinControlPointOffset {
                    yOffset = -kMinControlPointOffset
                }
            } else {
                
                yOffset = -3 * yDiff / 2
                
                if yOffset > -kMinControlPointOffset {
                    yOffset = -kMinControlPointOffset
                }
                
                if yOffset < -kMaxControlPointOffset {
                    yOffset = -kMaxControlPointOffset
                }
            }
            
        case .up:
            
            xOffset = 0
            yOffset = kMaxControlPointOffset
            
            if yDiff > 0 {
                
                if yDiff < 2 * kMaxControlPointOffset {
                    yOffset = yDiff / 2
                }
                
                if yOffset < kMinControlPointOffset {
                    yOffset = kMinControlPointOffset
                }
            } else {
                
                yOffset = -3 * yDiff / 2
                
                if yOffset < kMinControlPointOffset {
                    yOffset = kMinControlPointOffset
                }
                
                if yOffset > kMaxControlPointOffset {
                    yOffset = kMaxControlPointOffset
                }
            }
        }
        
        return Point(point1.x + xOffset, point1.y + yOffset)
    }
    
    public func centerCurveIndex(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Int {
        return 0
    }
}
